#!/bin/sh

#set -e

# use specified user name or use `default` if not specified
MY_USERNAME="${MY_USERNAME:-default}"

# use specified group name or use the same user name also as the group name
MY_GROUP="${MY_GROUP:-${MY_USERNAME}}"

# use the specified UID for the user
MY_UID="${MY_UID:-1000}"

# use the specified GID for the user
MY_GID="${MY_GID:-${MY_UID}}"


# check to see if group exists; if not, create it
if grep -q -E "^${MY_GROUP}:" /etc/group > /dev/null 2>&1
then
  echo "INFO: Group exists; skipping creation"
else
  echo "INFO: Group doesn't exist; creating..."
  # create the group
  groupadd -g "${MY_GID}" "${MY_GROUP}"
fi


# check to see if user exists; if not, create it
if id -u "${MY_USERNAME}" > /dev/null 2>&1
then
  echo "INFO: User exists; skipping creation"
else
  echo "INFO: User doesn't exist; creating..."
  # create the user
  useradd -u "${MY_UID}" -g "${MY_GID}" -d "/home/${MY_USERNAME}" -s /bin/bash "${MY_USERNAME}"
fi

# create home directory and set permissions
mkdir -p /home/"${MY_USERNAME}"
chown "${MY_UID}":"${MY_GID}" /home/"${MY_USERNAME}"

# verify that ~/.cache exists and that the permissions are correct
if [ ! -d "/home/${MY_USERNAME}/.cache" ]
then
  mkdir "/home/${MY_USERNAME}/.cache"
  chown "${MY_UID}":"${MY_GID}" "/home/${MY_USERNAME}/.cache"
else
  # get current owner details
  OWNER="$(stat -c '%u' "/home/${MY_USERNAME}/.cache")"
  GROUP="$(stat -c '%g' "/home/${MY_USERNAME}/.cache")"

  # check to see if UID and GID match
  if [ "${OWNER}" != "${MY_UID}" ] || [ "${GROUP}" != "${MY_GID}" ]
  then
    # UID or GID doesn't match, set permissions
    echo "WARNING: owner or group (${OWNER}:${GROUP}) not set correctly on '/home/${MY_USERNAME}/.cache'"
    echo "INFO: setting correct permissions (${MY_UID}:${MY_GID})"
    chown "${MY_UID}":"${MY_GID}" "/home/${MY_USERNAME}/.cache"
  fi
fi

# verify that ~/.local exists and that the permissions are correct
if [ ! -d "/home/${MY_USERNAME}/.local" ]
then
  mkdir "/home/${MY_USERNAME}/.local"
  chown "${MY_UID}":"${MY_GID}" "/home/${MY_USERNAME}/.local"
else
  # get current owner details
  OWNER="$(stat -c '%u' "/home/${MY_USERNAME}/.local")"
  GROUP="$(stat -c '%g' "/home/${MY_USERNAME}/.local")"

  # check to see if UID and GID match
  if [ "${OWNER}" != "${MY_UID}" ] || [ "${GROUP}" != "${MY_GID}" ]
  then
    # UID or GID doesn't match, set permissions
    echo "WARNING: owner or group (${OWNER}:${GROUP}) not set correctly on '/home/${MY_USERNAME}/.local'"
    echo "INFO: setting correct permissions (${MY_UID}:${MY_GID})"
    chown "${MY_UID}":"${MY_GID}" "/home/${MY_USERNAME}/.local"
  fi
fi

# start the CMD
echo "INFO: Running ${1} as ${MY_USERNAME}:${MY_GROUP} (${MY_UID}:${MY_GID})"

# exec and run the actual process specified in the CMD of the Dockerfile (which gets passed as ${*})
exec gosu "${MY_USERNAME}" "${@}"
