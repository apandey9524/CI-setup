#!/bin/sh

#install oracle java 8 and set it default java tool
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install oracle-java8-installer -y
sudo apt-get install oracle-java8-set-default

#install git
sudo apt install git

#install dotnetcore
wget -q packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.1.200 -y

#install and start jenkins 
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins -y
sudo ufw allow 8080
#disable security for jenkins and restart
sudo service jenkins stop
# sudo sed -i "s/<useSecurity>true/<useSecurity>false/g" /var/lib/jenkins/config.xml
# sudo sed -i "s/<authorizationStrategy/<\!--authorizationStrategy/g" /var/lib/jenkins/config.xml
# sudo sed -i "s/securityRealm>/securityRealm-->/g" /var/lib/jenkins/config.xml
git clone https://github.com/apandey9524/jenkins-config.git
cp -f jenkins-config/config.xml /var/lib/jenkins/config.xml
sudo service jenkins start
#wget -q --auth-no-challenge --user USERNAME --password PASSWORD --output-document crumb.txt 'http://localhost:8080//crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
#crumbid=$(<crumb.txt)

#sudo curl -X POST -H "$crumbid" -d "" http://localhost:8080/setupWizard/completeInstall
sudo curl -X POST -v -o -  -d "" http://localhost:8080/setupWizard/completeInstall
#create list of plugins to be installed and install plugins
pluginlist = $1
OIFS=$IFS;
IFS=",";
PLUGINS="$pluginlist";
for ((i=0; i<${#PLUGINS[@]}; ++i)); do
  curl -X POST -d "<jenkins><install plugin=${PLUGINS[$i]}/></jenkins>" -H 'Content-Type:text/xml'  http://localhost:8080/pluginManager/installNecessaryPlugins   
done

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
./createJobConfig.sh "$GITREPO" "$GITBRANCHNAME" "$TARGETFILEPATH" "$MAILINGLIST"

#post job creation request to localhost
curl -X POST -d @job-config.xml -H "Content-Type:application/xml" http://localhost:8080/createItem?name=dotnetcore_app