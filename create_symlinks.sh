#!/bin/bash
#
# Description:
# This script will create a symlink for all the files and folders 
# in this repository in the $HOME folder.
################################################################################

################################################################################
# Constant Variables 
################################################################################

IGNORE_LIST=(".DS_Store" "." ".." ".gitignore" ".git")
COPY_LIST=(".vim")
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

  copy_file_flag=false
  for copy_file in "${COPY_LIST[@]}"; do
    if [[ "${copy_file}" = "${file}" ]]; then
      copy_file_flag=true
      break
    fi
  done

  if [[ "${copy_file_flag}" = true ]]; then
    echo Copying "${file}"
    cp -r "${PWD}/${file}" "${HOME}/"
    continue
  fi

  if [[ -L "${HOME}/${file}" ]]; then
    # Ignore if the file exists and is already a symlink 
    if [[ "${PWD}/${file}" = `readlink ${HOME}/${file}` ]]; then
      echo "Symlink already exists for ${file}"
    else
      echo "Symlink already exists but have a different link."
    fi
  elif [[ -f "${HOME}/${file}" ]]; then
      echo "An existing file was found at ${HOME}/${file}"
  else
    # Create a symlink for the remaining files
    echo Creating symlink for "${file}"
    ln -s "${PWD}/${file}" "${HOME}/${file}"
  fi
done
