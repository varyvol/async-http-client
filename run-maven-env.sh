#!/bin/bash

# This script makes it easier to get the right environment for this repo.
# Ideally, we should be using a JDK6, but it's not the easiest choice
# because JDK6 cannot do more than TLSv1.
# So we use JDK7 instead, and not JDK8 because a default method `replace`
# got added to `java.util.Map`

# Checking that maven related files are found to stop and spit a clearer
# message in case it's not found.

MAVEN_SETTINGS=$HOME/.m2/settings.xml
MAVEN_SETTINGS_SECURITY=$HOME/.m2/settings-security.xml

if [ -f "$MAVEN_SETTINGS" ]
then
	echo "Using $MAVEN_SETTINGS file found."
    MAVEN_FILES_MOUNTS="-v $MAVEN_SETTINGS:/root/.m2/settings.xml:ro"
else
   	echo "Maven settings.xml file not found, it's required for credentials. Stopping."
    exit 1
fi

if [ -f "$MAVEN_SETTINGS_SECURITY" ]
then
	echo "Using $MAVEN_SETTINGS_SECURITY file."
    MAVEN_FILES_MOUNTS="$MAVEN_FILES_MOUNTS -v $MAVEN_SETTINGS_SECURITY:/root/.m2/settings-security.xml:ro "
else
   	echo "Maven settings.xml file not found, it's required for credentials. Stopping."
    exit 2
fi

exec docker run -ti  \
                -w /work \
                $MAVEN_FILES_MOUNTS \
                -v $PWD:/work \
                maven:3.6.0-jdk-7 bash
