#!/bin/bash

function parseInputs {
  thWorkingDir="."
  if [[ -n "${INPUT_TH_WORKING_DIR}" ]]; then
    thWorkingDir=${INPUT_TH_WORKING_DIR}
  fi
}

function main {
  parseInputs
  cd "${GITHUB_WORKSPACE}"/"${thWorkingDir}" || exit 1

  exec "terrahelp ${*}"
}

main "${*}"
