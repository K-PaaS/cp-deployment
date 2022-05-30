#!/bin/bash

sudo chmod o+w /tmp
sudo chmod o+w /var/tmp

source kubespray_var_stacked.sh
source kubeedge_var.sh
source kubeedge_setting.sh
source kubeedge_install.sh
