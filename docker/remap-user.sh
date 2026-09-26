#!/bin/bash

# This script's purpose is to perform user remapping of user IDs so that the users within the docker container
# match those that were specified in environment variables. This way one can use volumes, without running into
# permission issues.
# Original source: https://raw.githubusercontent.com/schmidigital/permission-fix/master/tools/permission_fix

set -e

echo "RUNNING permission remap!"

UNUSED_USER_ID=21338
UNUSED_GROUP_ID=21337

echo "Fixing permissions."

# Specify the name of the owner of the files within the container.
CONTAINER_FILES_OWNER_NAME=dnsmasq

# Specify the name of the group assigned to the files within the container.
CONTAINER_FILES_GROUP_NAME=dnsmasq

# Specify the IDs we wish for the user and groups to have, so they match the host.
DESIRED_USER_ID=$HOST_USER_ID
DESIRED_GROUP_ID=$HOST_GROUP_ID


# Figure out what the current IDs are for the owner and group names.
CURRENT_GROUP_ID=`cut -d: -f3 < <(getent group ${CONTAINER_FILES_GROUP_NAME})`
CURRENT_USER_ID=`id -u ${CONTAINER_FILES_OWNER_NAME}`



# setting www-data group permissions
if [ $CURRENT_GROUP_ID -eq $DESIRED_GROUP_ID ]; then
    echo "$CONTAINER_FILES_GROUP_NAME already has the correct group ID. Nice!"
else
    echo "Check if group with ID $DESIRED_GROUP_ID already exists"
    EXISTING_NAME_FOR_DESIRED_GROUP_ID=`getent group $DESIRED_GROUP_ID | cut -d: -f1`

    if [ -z "$EXISTING_NAME_FOR_DESIRED_GROUP_ID" ]; then
        echo "Group ID is free. Good."
    else
        echo "Group ID is already taken by group: $EXISTING_NAME_FOR_DESIRED_GROUP_ID"
        echo "Changing the ID of $EXISTING_NAME_FOR_DESIRED_GROUP_ID group to $UNUSED_GROUP_ID"
        groupmod --gid $UNUSED_GROUP_ID $EXISTING_NAME_FOR_DESIRED_GROUP_ID
    fi

    echo "Changing the ID of $CONTAINER_FILES_GROUP_NAME group to $DESIRED_GROUP_ID"
    groupmod --gid $DESIRED_GROUP_ID $CONTAINER_FILES_GROUP_NAME
    echo "Finished"
    echo "-- -- -- -- --"
fi

# Setting User Permissions

if [ $CURRENT_USER_ID -eq $DESIRED_USER_ID ]; then
    echo "$CONTAINER_FILES_OWNER_NAME user is already mapped to $DESIRED_USER_ID. Nice!"

else
    echo "Check if user with ID $DESIRED_USER_ID already exists"
    EXISTING_USER_NAME_FOR_DESIRED_USER_ID=`getent passwd $DESIRED_USER_ID | cut -d: -f1`

    if [ -z "$EXISTING_USER_NAME_FOR_DESIRED_USER_ID" ]; then
        echo "User ID is free. Good."
    else
        echo "Desired user ID of $DESIRED_USER_ID is already taken by group: $EXISTING_USER_NAME_FOR_DESIRED_USER_ID"
        echo "Changing the user ID of $EXISTING_USER_NAME_FOR_DESIRED_USER_ID to $UNUSED_USER_ID"
        usermod --uid $UNUSED_USER_ID $EXISTING_USER_NAME_FOR_DESIRED_USER_ID
    fi

    usermod --uid $DESIRED_USER_ID $CONTAINER_FILES_OWNER_NAME
    echo "Finished"
fi
