/*
Copyright 2019 The Rook Authors. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package csi

import (
	"bytes"
	"strconv"
	"strings"
	"text/template"

	"github.com/pkg/errors"
	k8sutil "github.com/rook/rook/pkg/operator/k8sutil"
	apps "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/yaml"
)

func loadTemplate(name, templateData string, p templateParam) ([]byte, error) {
	var writer bytes.Buffer
	t := template.New(name)
	t, err := t.Parse(templateData)
	if err != nil {
		return nil, errors.Wrapf(err, "failed to parse template %v", name)
	}
	err = t.Execute(&writer, p)
	return writer.Bytes(), err
}

func templateToService(name, templateData string, p templateParam) (*corev1.Service, error) {
	var svc corev1.Service
	t, err := loadTemplate(name, templateData, p)
	if err != nil {
		return nil, errors.Wrap(err, "failed to load service template")
	}

	err = yaml.Unmarshal(t, &svc)
	if err != nil {
		return nil, errors.Wrap(err, "failed to unmarshal service template")
	}
	return &svc, nil
}

func templateToDaemonSet(name, templateData string, p templateParam) (*apps.DaemonSet, error) {
	var ds apps.DaemonSet
	t, err := loadTemplate(name, templateData, p)
	if err != nil {
		return nil, errors.Wrap(err, "failed to load daemonset template")
	}

	err = yaml.Unmarshal(t, &ds)
	if err != nil {
		return nil, errors.Wrap(err, "failed to unmarshal daemonset template")
	}
	return &ds, nil
}

func templateToDeployment(name, templateData string, p templateParam) (*apps.Deployment, error) {
	var dep apps.Deployment
	t, err := loadTemplate(name, templateData, p)
	if err != nil {
		return nil, errors.Wrap(err, "failed to load deployment template")
	}

	err = yaml.Unmarshal(t, &dep)
	if err != nil {
		return nil, errors.Wrap(err, "failed to unmarshal deployment template")
	}
	return &dep, nil
}

func applyResourcesToContainers(opConfig map[string]string, key string, podspec *corev1.PodSpec) {
	resource := getComputeResource(opConfig, key)
	if len(resource) > 0 {
		for i, c := range podspec.Containers {
			for _, r := range resource {
				if c.Name == r.Name {
					podspec.Containers[i].Resources = r.Resource
				}
			}
		}
	}
}

func getComputeResource(opConfig map[string]string, key string) []k8sutil.ContainerResource {
	// Add Resource list if any
	resource := []k8sutil.ContainerResource{}
	var err error

	if resourceRaw := k8sutil.GetValue(opConfig, key, ""); resourceRaw != "" {
		resource, err = k8sutil.YamlToContainerResource(resourceRaw)
		if err != nil {
			logger.Warningf("failed to parse %q. %v", resourceRaw, err)
		}
	}
	return resource
}

func getToleration(opConfig map[string]string, tolerationsName string, defaultTolerations []corev1.Toleration) []corev1.Toleration {
	// Add toleration if any, otherwise return defaultTolerations
	tolerationsRaw := k8sutil.GetValue(opConfig, tolerationsName, "")
	if tolerationsRaw == "" {
		return defaultTolerations
	}
	tolerations, err := k8sutil.YamlToTolerations(tolerationsRaw)
	if err != nil {
		logger.Warningf("failed to parse %q for %q. %v", tolerationsRaw, tolerationsName, err)
		return defaultTolerations
	}
	for i := range tolerations {
		if tolerations[i].Key == "" {
			tolerations[i].Operator = corev1.TolerationOpExists
		}

		if tolerations[i].Operator == corev1.TolerationOpExists {
			tolerations[i].Value = ""
		}
	}
	return tolerations
}

func getNodeAffinity(opConfig map[string]string, nodeAffinityName string, defaultNodeAffinity *corev1.NodeAffinity) *corev1.NodeAffinity {
	// Add NodeAffinity if any, otherwise return defaultNodeAffinity
	nodeAffinity := k8sutil.GetValue(opConfig, nodeAffinityName, "")
	if nodeAffinity == "" {
		return defaultNodeAffinity
	}
	v1NodeAffinity, err := k8sutil.GenerateNodeAffinity(nodeAffinity)
	if err != nil {
		logger.Warningf("failed to parse %q for %q. %v", nodeAffinity, nodeAffinityName, err)
		return defaultNodeAffinity
	}
	return v1NodeAffinity
}

func applyToPodSpec(pod *corev1.PodSpec, n *corev1.NodeAffinity, t []corev1.Toleration) {
	pod.Tolerations = t
	pod.Affinity = &corev1.Affinity{
		NodeAffinity: n,
	}
}

func getPortFromConfig(data map[string]string, env string, defaultPort uint16) (uint16, error) {
	port := k8sutil.GetValue(data, env, strconv.Itoa(int(defaultPort)))
	if strings.TrimSpace(k8sutil.GetValue(data, env, strconv.Itoa(int(defaultPort)))) == "" {
		return defaultPort, nil
	}
	p, err := strconv.ParseUint(port, 10, 64)
	if err != nil {
		return defaultPort, errors.Wrapf(err, "failed to parse port value for %q.", env)
	}
	if p > 65535 {
		return defaultPort, errors.Errorf("%s port value is greater than 65535 for %s.", port, env)
	}
	return uint16(p), nil
}

// Get PodAntiAffinity from a key and value pair
func GetPodAntiAffinity(key, value string) corev1.PodAntiAffinity {
	return corev1.PodAntiAffinity{
		RequiredDuringSchedulingIgnoredDuringExecution: []corev1.PodAffinityTerm{
			{
				LabelSelector: &metav1.LabelSelector{
					MatchExpressions: []metav1.LabelSelectorRequirement{
						{
							Key:      key,
							Operator: metav1.LabelSelectorOpIn,
							Values:   []string{value},
						},
					},
				},
				TopologyKey: corev1.LabelHostname,
			},
		},
	}
}

func applyVolumeToPodSpec(opConfig map[string]string, configName string, podspec *corev1.PodSpec) {
	volumesRaw := k8sutil.GetValue(opConfig, configName, "")
	if volumesRaw == "" {
		return
	}
	volumes, err := k8sutil.YamlToVolumes(volumesRaw)
	if err != nil {
		logger.Warningf("failed to parse %q for %q. %v", volumesRaw, configName, err)
		return
	}
	if len(volumes) > 0 {
		for i := range volumes {
			found := false
			for j := range podspec.Volumes {
				// check do we need to override any existing volumes
				if volumes[i].Name == podspec.Volumes[j].Name {
					podspec.Volumes[j] = volumes[i]
					found = true
					break
				}
			}
			if !found {
				// if not found add volume to volumes list
				podspec.Volumes = append(podspec.Volumes, volumes[i])
			}
		}
	}
}

func applyVolumeMountToContainer(opConfig map[string]string, configName, containerName string, podspec *corev1.PodSpec) {
	volumeMountsRaw := k8sutil.GetValue(opConfig, configName, "")
	if volumeMountsRaw == "" {
		return
	}
	volumeMounts, err := k8sutil.YamlToVolumeMounts(volumeMountsRaw)
	if err != nil {
		logger.Warningf("failed to parse %q for %q. %v", volumeMountsRaw, configName, err)
		return
	}
	if len(volumeMounts) > 0 {
		for i, c := range podspec.Containers {
			if c.Name == containerName {
				for j := range volumeMounts {
					found := false
					for k := range podspec.Containers[i].VolumeMounts {
						// override if the name is matching
						if volumeMounts[j].Name == podspec.Containers[i].VolumeMounts[k].Name {
							found = true
							podspec.Containers[i].VolumeMounts[k] = volumeMounts[j]
							break
						}
					}
					if !found {
						// if not found append it to the exiting volumes
						podspec.Containers[i].VolumeMounts = append(podspec.Containers[i].VolumeMounts, volumeMounts[j])
					}
				}
				// return as we finished with found container
				return
			}
		}
	}
}
