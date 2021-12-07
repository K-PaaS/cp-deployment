#!/bin/bash

pkill cloudcore
nohup cloudcore > cloudcore.log 2>&1 &
