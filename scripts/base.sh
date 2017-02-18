#!/bin/sh -e

set -x

# Base Install
yum -y update
yum -y install yum-utils
yum -y install git curl wget epel-release gcc
yum -y groupinstall development
