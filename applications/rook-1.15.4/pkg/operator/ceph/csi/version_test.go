/*
Copyright 2020 The Rook Authors. All rights reserved.

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
	"testing"

	"github.com/stretchr/testify/assert"
)

var (
	testMinVersion   = CephCSIVersion{3, 11, 0}
	testReleaseV390  = CephCSIVersion{3, 9, 0}
	testReleaseV391  = CephCSIVersion{3, 9, 1}
	testreleasev310  = CephCSIVersion{3, 10, 0}
	testReleaseV3101 = CephCSIVersion{3, 10, 1}
	testReleaseV3102 = CephCSIVersion{3, 10, 2}
	testReleaseV3110 = CephCSIVersion{3, 11, 0}
	testReleaseV3120 = CephCSIVersion{3, 12, 0}

	testVersionUnsupported = CephCSIVersion{4, 0, 0}
)

func TestIsAtLeast(t *testing.T) {
	// Test version which is smaller
	var version = CephCSIVersion{1, 40, 10}
	ret := testMinVersion.isAtLeast(&version)
	assert.Equal(t, true, ret)

	// Test version which is equal
	ret = testMinVersion.isAtLeast(&testMinVersion)
	assert.Equal(t, true, ret)

	// Test for 3.9.0
	ret = testReleaseV390.isAtLeast(&testMinVersion)
	assert.Equal(t, false, ret)

	// Test for 3.9.1
	ret = testReleaseV391.isAtLeast(&testMinVersion)
	assert.Equal(t, false, ret)

	// Test for 3.10.0
	ret = testreleasev310.isAtLeast(&testReleaseV390)
	assert.Equal(t, true, ret)

	// Test for 3.10.1
	ret = testReleaseV3101.isAtLeast(&testReleaseV3101)
	assert.Equal(t, true, ret)

	// Test for 3.10.2
	ret = testReleaseV3102.isAtLeast(&testReleaseV3102)
	assert.Equal(t, true, ret)

	// Test for 3.11.0
	ret = testReleaseV3110.isAtLeast(&testReleaseV3110)
	assert.Equal(t, true, ret)

	// Test for 3.12.0
	ret = testReleaseV3120.isAtLeast(&testReleaseV3120)
	assert.Equal(t, true, ret)

}

func TestSupported(t *testing.T) {
	AllowUnsupported = false
	ret := testMinVersion.Supported()
	assert.Equal(t, true, ret)

	ret = testVersionUnsupported.Supported()
	assert.Equal(t, false, ret)

	// 3.9.x is not supported after 3.11.0 release
	ret = testReleaseV390.Supported()
	assert.Equal(t, false, ret)

	ret = testReleaseV391.Supported()
	assert.Equal(t, false, ret)

	ret = testreleasev310.Supported()
	assert.Equal(t, false, ret)

	ret = testReleaseV3101.Supported()
	assert.Equal(t, false, ret)

	ret = testReleaseV3110.Supported()
	assert.Equal(t, true, ret)

	ret = testReleaseV3120.Supported()
	assert.Equal(t, true, ret)
}

func Test_extractCephCSIVersion(t *testing.T) {
	expectedVersion := CephCSIVersion{3, 0, 0}
	csiString := []byte(`Cephcsi Version: v3.0.0
		Git Commit: e58d537a07ca0184f67d33db85bf6b4911624b44
		Go Version: go1.12.15
		Compiler: gc
		Platform: linux/amd64
		`)
	version, err := extractCephCSIVersion(string(csiString))

	assert.Equal(t, &expectedVersion, version)
	assert.Nil(t, err)

	csiString = []byte(`Cephcsi Version: rubbish
	Git Commit: e58d537a07ca0184f67d33db85bf6b4911624b44
	Go Version: go1.12.15
	Compiler: gc
	Platform: linux/amd64
	`)
	version, err = extractCephCSIVersion(string(csiString))

	assert.Nil(t, version)
	assert.Contains(t, err.Error(), "failed to parse version from")
}
