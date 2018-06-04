#!/bin/sh

# #install oracle java 8 and set it default java tool
 sudo add-apt-repository ppa:webupd8team/java -y
 sudo apt-get update
 echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
 sudo apt-get install oracle-java8-installer -y
 sudo apt-get install oracle-java8-set-default

# #install git
sudo apt install git

# #install dotnetcore
wget -q packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.1.200 -y

# #install and start jenkins 
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins -y
sudo ufw allow 8080
#disable security for jenkins and restart
sudo service jenkins restart
# sudo sed -i "s/<useSecurity>true/<useSecurity>false/g" /var/lib/jenkins/config.xml
# sudo sed -i "s/<authorizationStrategy/<\!--authorizationStrategy/g" /var/lib/jenkins/config.xml
# sudo sed -i "s/securityRealm>/securityRealm-->/g" /var/lib/jenkins/config.xml
git clone https://github.com/apandey9524/jenkins-config.git
cp -f jenkins-config/config.xml /var/lib/jenkins/config.xml
sudo service jenkins restart
# sudo wget -q --auth-no-challenge --user USERNAME --password PASSWORD --output-document crumb.txt 'http://localhost:8080//crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
# crumbid=$(<crumb.txt)
#jenkinspublicip=$(curl ipinfo.io/ip)
crumbheader = $(wget -q --auth-no-challenge --user USERNAME --password PASSWORD --output-document crumb.txt 'http://localhost:8080//crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
sleep 20
sudo curl -X POST  -d "" -H "$crumbheader" -o - http://lcoalhost:8080/setupWizard/completeInstall
sudo service jenkins restart
#sudo curl -X POST -o - -d "" http://"$jenkinspublicip":8080/setupWizard/completeInstall
#create list of plugins to be installed and install plugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=build-timeout@1.19/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=email-ext@2.62/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=file-operations@1.7/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=github@1.29.0/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=postbuild-task@1.8/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=msbuild@1.29/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=pipeline-github-lib@1.0/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=s3@0.11.2/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=timestamper@1.8.10/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
curl -X POST -H "$crumbheader" -d "<jenkins><install plugin=ws-cleanup@0.34/></jenkins>" -H 'Content-Type:text/xml' -H "$crumbid" http://localhost:8080/pluginManager/installNecessaryPlugins
# pluginlist="$1"
# echo $pluginlist
# def_ifs=$IFS
# IFS=','
# read -ra PLUGINS <<< "$pluginlist"
# for i in "${PLUGINS[@]}"; do
	# curl -X POST -d "<jenkins><install plugin=$i/></jenkins>" -H 'Content-Type:text/xml'  http://"$jenkinspublicip":8080/pluginManager/installNecessaryPlugins
# done
# IFS=$def_ifs

# plugins=(build-timeout@1.19  email-ext@2.62  file-operations@1.7  github@1.29.0  gradle@1.29  postbuild-task@1.8  msbuild@1.29  workflow-aggregator@2.5  pipeline-github-lib@1.0  s3@0.11.2  timestamper@1.8.10  ws-cleanup@0.34)
# for i in "${plugins[@]}"; do
	 # curl -X POST -d "<jenkins><install plugin=$i/></jenkins>" -H 'Content-Type:text/xml'  http://"$jenkinspublicip":8080/pluginManager/installNecessaryPlugins
 # done
# for ((i=0; i<${#PLUGINS[@]}; ++i)); do
  # curl -X POST -d "<jenkins><install plugin=${PLUGINS[$i]}/></jenkins>" -H 'Content-Type:text/xml'  http://"$jenkinspublicip":8080/pluginManager/installNecessaryPlugins   
# done

# pluginlist = "$1"
# IFS=',' read -ra PLUGINS <<< "$pluginlist"
# for plugin in "${PLUGINS[@]}"; do
    # # process "$i"
        # curl -X POST -d "<jenkins><install plugin=$plugin /></jenkins>" -H 'Content-Type:text/xml'  http://localhost:8080/pluginManager/installNecessaryPlugins
# done

#add webhook to jenkins config


#call job-creation script with parameters
GITREPO="$2"
GITBRANCHNAME="$3"
TARGETFILEPATH="$4"
MAILINGLIST="$5"
pwd
./createJobConfig.sh "$GITREPO" "$GITBRANCHNAME" "$TARGETFILEPATH" "$MAILINGLIST"
ls -a
#post job creation request to localhost
sudo curl -X POST -H "Content-Type:application/xml" -H "$crumbheader" -d @job-config.xml  http://localhost:8080/createItem?name=dotnetcore_app