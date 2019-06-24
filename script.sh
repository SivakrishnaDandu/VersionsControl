#!/bin/bash
orgSprint=`cat /opt/scripts/VersionsControl/Sprint | awk -F '=' '{print $2}'`
echo orgSprint value is: $orgSprint

sprint1=`echo $orgSprint | awk -F '.' '{print $1}'`
echo sprint1 is: $sprint1
sprint2=`echo $orgSprint | awk -F '.' '{print $2}'`
echo sprint2 is: $sprint2

orgOldVersion=`cat /opt/scripts/VersionsControl/PreviousVersion | awk -F '=' '{print $2}'`
echo orgOldVersion is: $orgOldVersion

oldVersion1=`echo $orgOldVersion | awk -F '.' '{print $1}'`
echo oldVersion1: $oldVersion1
oldVersion2=`echo $orgOldVersion | awk -F '.' '{print $2}'`
echo oldVersion2 is: $oldVersion2
count=`echo $orgOldVersion | awk -F '.' '{print $3}'`
echo count is: $count

if [ $sprint1 -eq $oldVersion1 ] && [ $sprint2 -eq $oldVersion2 ]
then
echo "both the versions are matched..!"
count=$((count+1))
echo "version=$orgSprint.$count" > verison.properties 
else
echo "Versions are not matched..!"
count=0
echo "version=$orgSprint.$count" > verison.properties
fi

finalVersion=`cat verison.properties | cut -d '=' -f2`
echo "finalVersion is: $finalVersion"
cd /opt/my-app/ 
pom_version=`/usr/share/maven/bin/mvn help:evaluate -Dexpression=project.version | tail -8 | head -n 1`
echo "pom_version is: $pom_version"
sed -i "s/<version>$pom_version<\/version>/<version>$finalVersion<\/version>/" /opt/my-app/pom.xml
if [ $? == 0 ]
then
echo "Executed Successfully ..!"
else
echo "Failed to replace..!"
fi
