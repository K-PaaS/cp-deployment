GRANT ALL PRIVILEGES ON *.* TO '<%= p("admin_user.id") %>'@'%' IDENTIFIED BY '<%= p("admin_user.password") %>' WITH GRANT OPTION;
FLUSH PRIVILEGES;

/*
MySQL - 10.1.22-MariaDB : Database - CaaS broker & dashboard
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`broker` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;

USE `broker`;

/*Table structure for table `admin_token` */

DROP TABLE IF EXISTS `admin_token`;

CREATE TABLE `admin_token` (
  `token_name` varchar(255) NOT NULL,
  `token_value` varchar(1200) NOT NULL,
  PRIMARY KEY (`token_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for jenkins_instance
-- ----------------------------
DROP TABLE IF EXISTS `jenkins_instance`;
CREATE TABLE `jenkins_instance`  (
  `organization_guid` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `name_space` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `service_instance_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`service_instance_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Compact;

/*Table structure for table `service_instances` */

DROP TABLE IF EXISTS `service_instance`;

CREATE TABLE `service_instance` (
  `service_instance_id` varchar(255) NOT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `caas_account_token_name` varchar(255) DEFAULT NULL,
  `caas_account_name` varchar(255) DEFAULT NULL,
  `caas_namespace` varchar(255) DEFAULT NULL,
  `dashboard_url` varchar(255) DEFAULT NULL,
  `organization_guid` varchar(255) DEFAULT NULL,
  `plan_id` varchar(255) DEFAULT NULL,
  `service_definition_id` varchar(255) DEFAULT NULL,
  `space_guid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`service_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE DATABASE /*!32312 IF NOT EXISTS*/`cp` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `cp`;

-- ----------------------------
-- Table structure for admin_token
-- ----------------------------
DROP TABLE IF EXISTS `admin_token`;
CREATE TABLE `admin_token`  (
  `token_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'token name(토큰 명)',
  `token_value` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'token value(토큰 값)',
  PRIMARY KEY (`token_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '클러스터 어드민 토큰' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for cp_clusters
-- ----------------------------
DROP TABLE IF EXISTS `cp_clusters`;
CREATE TABLE `cp_clusters`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id(아이디)',
  `cluster_api_url` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'cluster api url(클러스터 API URL)',
  `cluster_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'cluster name(클러스터 명)',
  `cluster_token` varchar(2000) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'cluster token(클러스터 토큰)',
  `created` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'created(생성일)',
  `last_modified` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'last modified(수정일)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci COMMENT = '클러스터' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for cp_limit_ranges
-- ----------------------------
DROP TABLE IF EXISTS `cp_limit_ranges`;
CREATE TABLE `cp_limit_ranges`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id(아이디)',
  `default_limit` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'default limit(기본 상한 값)',
  `default_request` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'default request(기본 요청 값)',
  `max` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'max(컨테이너에 지정할 리밋레인지 최대 값)',
  `min` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'min(컨테이너에 지정할 리밋레인지 최소 값)',
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'name(리밋 레인지 명)',
  `resource` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'resource(리밋 레인지 리소스)',
  `type` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'type(리밋 레인지 유형)',
  `created` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'created(생성일)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci COMMENT = '리밋 레인지' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cp_limit_ranges
-- ----------------------------
INSERT INTO `cp_limit_ranges`(`id`, `default_limit`, `default_request`, `max`, `min`, `name`, `resource`, `type`, `created`) VALUES (1, '100m', '-', '-', '-', 'paas-ta-container-platform-low-limit-range', 'cpu', 'Container', '2020-11-05 13:26:24');
INSERT INTO `cp_limit_ranges`(`id`, `default_limit`, `default_request`, `max`, `min`, `name`, `resource`, `type`, `created`) VALUES (2, '500Mi', '-', '-', '-', 'paas-ta-container-platform-low-limit-range', 'memory', 'Container', '2020-11-05 13:27:24');
INSERT INTO `cp_limit_ranges`(`id`, `default_limit`, `default_request`, `max`, `min`, `name`, `resource`, `type`, `created`) VALUES (3, '300m', '-', '-', '-', 'paas-ta-container-platform-medium-limit-range', 'cpu', 'Container', '2020-11-05 13:27:59');
INSERT INTO `cp_limit_ranges`(`id`, `default_limit`, `default_request`, `max`, `min`, `name`, `resource`, `type`, `created`) VALUES (4, '1500Mi', '-', '-', '-', 'paas-ta-container-platform-medium-limit-range', 'memory', 'Container', '2020-11-05 13:27:59');
INSERT INTO `cp_limit_ranges`(`id`, `default_limit`, `default_request`, `max`, `min`, `name`, `resource`, `type`, `created`) VALUES (5, '900m', '-', '-', '-', 'paas-ta-container-platform-high-limit-range', 'cpu', 'Container', '2020-11-05 13:27:59');
INSERT INTO `cp_limit_ranges`(`id`, `default_limit`, `default_request`, `max`, `min`, `name`, `resource`, `type`, `created`) VALUES (6, '3Gi', '-', '-', '-', 'paas-ta-container-platform-high-limit-range', 'memory', 'Container', '2020-11-05 13:27:59');

-- ----------------------------
-- Table structure for cp_resource_quotas
-- ----------------------------
DROP TABLE IF EXISTS `cp_resource_quotas`;
CREATE TABLE `cp_resource_quotas`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id(아이디)',
  `limit_cpu` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'limit cpu(cpu 상한 값)',
  `limit_memory` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'limit memory(memory 상한 값)',
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'name(리소스 쿼터 명)',
  `request_cpu` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'request cpu(cpu 요청 값)',
  `request_memory` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'request memory(memory 요청 값)',
  `status` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'status(할당량 및 현재 사용량 상태)',
  `created` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'created(생성일)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci COMMENT = '리소스 쿼터' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cp_resource_quotas
-- ----------------------------
INSERT INTO `cp_resource_quotas`(`id`, `limit_cpu`, `limit_memory`, `name`, `request_cpu`, `request_memory`, `status`, `created`) VALUES (1, '2', '2Gi', 'paas-ta-container-platform-low-rq', '-', '-', '{\"cpu\":{\"used\":\"200m\",\"hard\":\"2\"}, \"memory\":{\"used\":\"1800Mi\",\"hard\": \"2Gi\"}}', '2020-11-05 13:26:24');
INSERT INTO `cp_resource_quotas`(`id`, `limit_cpu`, `limit_memory`, `name`, `request_cpu`, `request_memory`, `status`, `created`) VALUES (2, '4', '6Gi', 'paas-ta-container-platform-medium-rq', '-', '-', '{\"cpu\":{\"used\":\"200m\",\"hard\":\"4\"}, \"memory\":{\"used\":\"1800Mi\",\"hard\": \"6Gi\"}}', '2020-11-05 13:26:24');
INSERT INTO `cp_resource_quotas`(`id`, `limit_cpu`, `limit_memory`, `name`, `request_cpu`, `request_memory`, `status`, `created`) VALUES (3, '8', '12Gi', 'paas-ta-container-platform-high-rq', '-', '-', '{\"cpu\":{\"used\":\"200m\",\"hard\":\"8\"}, \"memory\":{\"used\":\"1800Mi\",\"hard\": \"12Gi\"}}', '2020-11-05 13:26:24');

-- ----------------------------
-- Table structure for cp_users
-- ----------------------------
DROP TABLE IF EXISTS `cp_users`;
CREATE TABLE `cp_users`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id(아이디)',
  `cluster_api_url` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'cluster api url(클러스터 API URL)',
  `cluster_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'cluster name(클러스터 명)',
  `cluster_token` varchar(2000) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'cluster token(클러스터 토큰)',
  `created` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'created(생성일)',
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'description(설명)',
  `email` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'email(이메일)',
  `last_modified` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'last modified(수정일)',
  `password` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'password(비밀번호)',
  `role_set_code` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'role set code(권한)',
  `service_account_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'service account name(service account 명)',
  `user_id` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'user id(사용자 아이디)',
  `user_type` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'user type(사용자 유형)',
  `namespace` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'namespace(namespace 명)',
  `is_active` varchar(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'N' COMMENT 'is active(사용 여부)',
  `service_account_secret` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'service account secret(service account secret 명)',
  `service_account_token` varchar(2000) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'service account token(service account 토큰)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1178 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci COMMENT = '사용자' ROW_FORMAT = Dynamic;

INSERT INTO `cp`.`admin_token`(`token_name`, `token_value`) VALUES ('caas_admin', '<%= p("k8s_auth_bearer") %>');
INSERT INTO `broker`.`admin_token`(`token_name`, `token_value`) VALUES ('caas_admin', '<%= p("k8s_auth_bearer") %>');

-- ----------------------------
-- Table structure for private_repository
-- ----------------------------
DROP TABLE IF EXISTS `private_repository`;
CREATE TABLE `private_repository`  (
  `seq` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'seq(시퀀스)',
  `repository_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'repository url(저장소 URL)',
  `repository_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'repository name(저장소 명)',
  `image_name` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'image name(이미지명)',
  `image_version` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'image version(이미지버전)',
  PRIMARY KEY (`seq`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '프라이빗 레파지토리' ROW_FORMAT = Dynamic;

INSERT INTO `cp`.`private_repository`(`repository_url`, `image_name`, `image_version`) VALUES ('<%= link("private-image-repository-link").p("image_repository.registry.url") %>', '<%= link("private-image-repository-link").p("image_repository.registry.name") %>','<%= link("private-image-repository-link").p("image_repository.registry.version") %>');


CREATE DATABASE /*!32312 IF NOT EXISTS*/`caas` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `caas`;

/*Table structure for table `admin_token` */
DROP TABLE IF EXISTS `admin_token`;

CREATE TABLE `admin_token` (
  `token_name` varchar(255) NOT NULL,
  `token_value` varchar(1000) NOT NULL,
  PRIMARY KEY (`token_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

INSERT INTO `caas`.`admin_token`(`token_name`, `token_value`) VALUES ('caas_admin', '<%= p("k8s_auth_bearer") %>');

/*Table structure for table `user` */
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `service_instance_id` varchar(255) NOT NULL,
  `caas_namespace` varchar(255) NOT NULL,
  `caas_account_token_name` varchar(255) DEFAULT NULL,
  `caas_account_name` varchar(255) DEFAULT NULL,
  `organization_guid` varchar(255) DEFAULT NULL,
  `space_guid` varchar(255) DEFAULT NULL,
  `role_set_code` char(6) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `plan_name` varchar(255) DEFAULT NULL,
  `plan_description` varchar(255) DEFAULT NULL,
  `created` varchar(255) NOT NULL,
  `last_modified` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/*Table structure for table `caas_user_role_set` */
DROP TABLE IF EXISTS `caas_user_role_set`;

CREATE TABLE `caas_user_role_set` (
  `role_set_code` char(6) NOT NULL,
  `resource_code` varchar(20) NOT NULL,
  `verb_code` varchar(20) NOT NULL,
  `description` varchar(400) DEFAULT NULL,
  `created` varchar(20) DEFAULT NULL,
  PRIMARY KEY (role_set_code, resource_code, verb_code)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*INSERT INIT DATA*/
INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.administrator_code") %>', 'user_management', 'create', '', now());
INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.administrator_code") %>', 'user_management', 'delete', '', now());
INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.administrator_code") %>', 'user_management', 'get', '', now());
INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.administrator_code") %>', 'user_management', 'list', '', now());
INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.administrator_code") %>', 'user_management', 'patch', '', now());
INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.administrator_code") %>', 'user_management', 'update', '', now());
INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.administrator_code") %>', 'user_management', 'watch', '', now());

INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.regular_user_code") %>', 'user_management', 'get', '', now());
INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.regular_user_code") %>', 'user_management', 'list', '', now());
INSERT INTO `caas`.`caas_user_role_set`(`role_set_code`, `resource_code`, `verb_code`, `description`, `created`) VALUES ('<%= p("role_set.regular_user_code") %>', 'user_management', 'watch', '', now());


SET FOREIGN_KEY_CHECKS = 1;

