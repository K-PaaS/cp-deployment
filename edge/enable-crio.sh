#!/bin/bash

sed -i 's/,metacopy=on//g' /etc/containers/storage.conf

systemctl daemon-reload
systemctl enable crio.service
systemctl start crio.service
