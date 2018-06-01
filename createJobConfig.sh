#!/bin/sh

GITREPO="$1"
GITBRANCHNAME="$2"
TARGETFILEPATH="$3"
MAILINGLIST="$4"
git clone https://github.com/apandey9524/jenkin-job-templates.git
cd jenkin-job-templates
git checkout dotnetcore-job-template
mv template-config.xml job-config.xml
chmod +r job-config.xml
# sudo sed -i "s/<useSecurity>true/<useSecurity>false/g" /var/lib/jenkins/config.xml
# sudo sed -i "s/\-\-GITREPO\-\-/${GITREPO}/g" job-config.xml
# sudo sed -i "s/\-\-GITBRANCHNAME\-\-/${GITBRANCHNAME}/g" job-config.xml
# sudo sed -i "s/\-\-TARGETFILEPATH\-\-/${TARGETFILEPATH}/g" job-config.xml
# sudo sed -i "s/\-\-MAILINGLIST\-\-/${MAILINGLIST}" job-config.xml