#!/bin/sh
PLUGINLIST= 'build-timeout@1.19 , email-ext@2.62 , file-operations@1.7 , github@1.29.0 , gradle@1.29 , postbuild-task@1.8 , msbuild@1.29 , workflow-aggregator@2.5 , pipeline-github-lib@1.0 , s3@0.11.2 , timestamper@1.8.10 , ws-cleanup@0.34'
GITREPO='https://github.com/nagarwal28/Assignments.git'
GITBRANCHNAME='core'
TARGETFILEPATH='project/project.csproj'
MAILINGLIST='apandey@tavisca.com dsingh@tavisca.com vtripathi@tavisca dghogare@tavisca.com vbhumare@tavisca.com'
./jenkins_setup.sh "$PLUGINLIST" "$GITREPO" "$GITBRANCHNAME" "$TARGETFILEPATH" "$MAILINGLIST"