#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ ! -d "${SCRIPT_DIR}/backend/venv" ]]
then
  echo "No python virtual environment present, setting that up first..." | tee -a "${SCRIPT_DIR}"/installation.log
  python3.8 -m venv "${SCRIPT_DIR}"/backend/venv
  source "${SCRIPT_DIR}"/backend/venv/bin/activate
  pip3 install --upgrade pip wheel
  pip3 install -r "${SCRIPT_DIR}"/backend/requirements.txt
else
  source "${SCRIPT_DIR}"/backend/venv/bin/activate
  pip3 install --upgrade pip --quiet
  pip3 install -r "${SCRIPT_DIR}"/backend/requirements.txt --quiet
fi


if [[ ! -d "${SCRIPT_DIR}/frontend/node_env" ]]
then
  source "${SCRIPT_DIR}/backend/venv/bin/activate"
  echo "node environment was not yet set up. Setting up now... (This only needs to happen once.)" | tee -a "${SCRIPT_DIR}"/installation.log
  pip3 install nodeenv | tee -a "${SCRIPT_DIR}"/../installation.log
  python3 -m nodeenv -n lts "${SCRIPT_DIR}"/frontend/node_env | tee -a "${SCRIPT_DIR}"/installation.log
  deactivate
fi

if [[ ! -d "${SCRIPT_DIR}/frontend/node_modules" ]]
then
  echo "node packages not installed. Setting up now... (This only needs to happen once.)" | tee -a "${SCRIPT_DIR}"/installation.log
  source "${SCRIPT_DIR}"/frontend/node_env/bin/activate
  (cd "${SCRIPT_DIR}/frontend"
  npm install -g @angular/cli --silent | tee -a "${SCRIPT_DIR}"/../installation.log
  npm install --silent | tee -a "${SCRIPT_DIR}"/../installation.log
  deactivate_node)
fi

