#!/usr/bin/env bash

args=("$@");
SS_WORKSPACE_DEFAULT="~/workspace"
SS_SERVICES_DEV_DEFAULT="${SS_WORKSPACE_DEFAULT}/smartshop-services-dev"
GOPATH=`go env GOPATH`

# Ask the user to close all IDEs and code editors where the project is currently open
read -p "Please exit all IDEs (e.g PhpStorm, GoLand) and press [y/Y] to continue " -n 1 -r CONTINUE
echo ""
if [[ ! "${CONTINUE}" =~ ^[Yy]$ ]]
then
  echo "Aborting..."
  exit 1
fi

# Ask for Smartshop workspace
read -p "Smartshop workspace [${SS_WORKSPACE_DEFAULT}]: " SS_WORKSPACE
SS_WORKSPACE=${SS_WORKSPACE:-$SS_WORKSPACE_DEFAULT}

# Ask for Smartshop-services-dev directory
read -p "Smartshop services dev directory [${SS_SERVICES_DEV_DEFAULT}]: " SS_SERVICES_DEV
SS_SERVICES_DEV=${SS_SERVICES_DEV:-$SS_WORKSPACE_DEFAULT}

# Ask for the repository name that needs to be moved
read -p "Go project that needs to moved to correct place e.g api-issa-proxy: " REPO
if [ -z "$REPO" ]
then
  echo "Repository name cannot be empty"
  exit 1
fi

# Ask for the correct go repo name
read -p "Correct Go repository name e.g issa-api instead of api-issa-proxy: " GO_REPO_NAME
if [ -z "$GO_REPO_NAME" ]
then
  echo "Go repository name cannot be empty"
  exit 1
fi

REPO_GO_PATH_DEFAULT="${GOPATH}/src/github.com/JSainsburyPLC/${GO_REPO_NAME}"
echo "Your go repository will be moved to: '${REPO_GO_PATH_DEFAULT}'"
read -p "Press enter to confirm: " REPO_GO_PATH
REPO_GO_PATH=${REPO_GO_PATH:-$REPO_GO_PATH_DEFAULT}

SS_SERVICES_DIR="${SS_WORKSPACE}/smartshop-services"
REPO_PATH="${SS_SERVICES_DIR}/$REPO"
REPO_SERVICES_DEV_NAME=`echo ${REPO//-/_}`
REPO_SERVICES_DEV_PATH="${SS_WORKSPACE}/smartshop-services-dev/ansible/roles/services/${REPO_SERVICES_DEV_NAME}"
COMMAND_MOVE="mv ${REPO_PATH} ${REPO_GO_PATH}"
COMMAND_SYMLINK="ln -s ${REPO_GO_PATH} ${REPO_PATH}"
COMMAND_VAGRANT="cd ${REPO_SERVICES_DEV_PATH} && vagrant "

# Check if the project repository exists
# if [ ! -d "${REPO_PATH}" ]; then
#   echo "Project directory '${REPO_PATH}' does not exist"
#   exit 1;
# fi

echo ""
echo "Repository: ${REPO_PATH}"
echo "Your \$GOPATH: ${GOPATH}"
echo ""

# Stop the VM
echo "Executing vagrant halt command: '${COMMAND_VAGRANT} halt'"
eval "${COMMAND_VAGRANT} halt";
echo ""

# Move the go project to it's correct place
echo "Executing move command: '${COMMAND_MOVE}'\n"
eval "${COMMAND_MOVE}"
echo ""

# Make a symlink inside smartshop services directory for VM
echo "Making a symlink in your workspace so that your project is available in your VM ['${COMMAND_SYMLINK}']\n"
eval "${COMMAND_SYMLINK}"
echo ""

# Ask if the user wants VM to be started
read -p "Do you want me to start the VM [y/Y]?" -n 1 -r CONTINUE
echo ""
if [[ "${CONTINUE}" =~ ^[Yy]$ ]]
then
  echo "Executing vagrant up command: '${COMMAND_VAGRANT} up'"
  eval "${COMMAND_VAGRANT} up";
  echo ""
fi

echo "\n*************** All done ~ Finito ***************\n"
