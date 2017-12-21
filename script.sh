#!/usr/bin/env bash

args=("$@");
REPO="api-issa-proxy";
GO_REPO_NAME="issa-api";

SS_WORKSPACE="~/workspace";
GOPATH=`go env GOPATH`;


echo "Smartshop workspace: ${SS_WORKSPACE}";
echo "Repository name: ${REPO}";
echo "GOPATH: ${GOPATH}";
echo "";

SS_SERVICES_DIR="${SS_WORKSPACE}/smartshop-services";
REPO_PATH="${SS_SERVICES_DIR}/$REPO";
REPO_GO_PATH="${GOPATH}/src/github.com/JSainsburyPLC/${GO_REPO_NAME}"
REPO_SERVICES_DEV_NAME=`echo ${REPO//-/_}`
REPO_SERVICES_DEV_PATH="${SS_WORKSPACE}/smartshop-services-dev/ansible/roles/services/${REPO_SERVICES_DEV_NAME}";

echo "Moving ${REPO_PATH} to ${REPO_GO_PATH}\n";

COMMAND_MOVE="mv ${REPO_PATH} ${REPO_GO_PATH}";
COMMAND_SYMLINK="ln -s ${REPO_GO_PATH} ${REPO_PATH}";
COMMAND_VAGRANT="cd ${REPO_SERVICES_DEV_PATH} && vagrant halt";

echo "Vagrant command: '${COMMAND_VAGRANT}'";
echo "Move command: '${COMMAND_MOVE}'\n";
echo "Symlink command: '${COMMAND_SYMLINK}'\n";

eval "${COMMAND_VAGRANT}";
eval "${COMMAND_MOVE}";
eval "${COMMAND_SYMLINK}";
