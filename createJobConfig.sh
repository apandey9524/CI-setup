#!/bin/sh

GITREPO="$1"
GITBRANCHNAME="$2"
TARGETFILEPATH="$3"
MAILINGLIST="$4"
git clone https://github.com/apandey9524/jenkin-job-templates.git
cd jenkin-job-templates
git checkout -b dotnetcore-job-template
cat template-config.xml>>job-config.xml
sudo sed -i "s/\-\-GITREPO\-\-//g${GITREPO}" job-config.xml
sudo sed -i "s/\-\-GITBRANCHNAME\-\-//g${GITBRANCHNAME}" job-config.xml
sudo sed -i "s/\-\-TARGETFILEPATH\-\-//g${TARGETFILEPATH}" job-config.xml
sudo sed -i "s/\-\-MAILINGLIST\-\-//g${MAILINGLIST}" job-config.xml

