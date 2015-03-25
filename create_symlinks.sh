#!/bin/bash
#
# Description:
# This script will create a symlink for all the files and folders 
# in this repository in the $HOME folder.
################################################################################

################################################################################
# Constant Variables 
################################################################################

IGNORE_LIST=(".DS_Store" "." "..")
PWD=`pwd`

################################################################################
# Start of script
################################################################################

# Exit on any failure
set -e

# Loop through the files in this repository
for file in .*; do

  # Ignore any file from the ignore list
  ignore_file_flag=false
  for ignore_file in "${IGNORE_LIST[@]}"; do
    if [[ "${ignore_file}" = "${file}" ]]; then
      ignore_file_flag=true
      break
    fi
  done

  if [[ "${ignore_file_flag}" = true ]]; then
    echo Ignoring "${file}"
    continue
  fi

  # Create a symlink for the remaining files
  echo Creating symlink for "${file}"
  ln -s "${PWD}/${file}" "${HOME}/${file}"

done
