#!/bin/bash
#
# Description:
# This script will create a symlink for all the files and folders
# in this repository in the $HOME folder.
################################################################################

################################################################################
# Constant Variables
################################################################################

SCRIPT=`basename $0`
IGNORE_LIST=(".DS_Store" "." ".." ".gitignore" ".git")
PWD=`pwd`
OVERRIDE_FILES=false
NUMARGS=$#
NOW=$(date +"%m_%d_%Y")

################################################################################
# Methods
################################################################################

# Print help message to STDOUT
help_message() {
  echo ""
  log "Help documentation for ${SCRIPT}"
  log "Basic usage: ${SCRIPT}"
  log "The following switches are recognized."
  log "-o  -- optional, override existing files"
  log "-h  -- Displays this help message."\\n
  log "Example: ${SCRIPT}"\\n
  exit 1
}

################################################################################
# Command line arguments
################################################################################
log () {
  echo -e "${SCRIPT}_${NOW}: $@"
}

# Parse command line flags
while getopts oh flag; do
  case $flag in
    o) # Set the OVERRIDE_FILES variable to true
      OVERRIDE_FILES=true
      ;;
    h) # show help message
      help_message
      ;;
    \?) # unrecognized option - show help message
      log -e \\n"Option -${OPTARG} not allowed." \\n\\n
      help_message
      ;;
  esac
done

################################################################################
# Start of script
################################################################################

# Exit on any failure
set -e

# Create Vim backup folder
mkdir -p ~/.vim/backup/

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
    log Ignoring "${file}"
    continue
  fi

  if [[ -e "${HOME}/${file}" && "${OVERRIDE_FILES}" = true ]]; then
    mv -f "${HOME}/${file}" "/tmp/${file}-$(date '+%Y-%m-%d_%H:%M:%S')"
  fi

  if [[ -L "${HOME}/${file}" ]]; then
    # Ignore if the file exists and is already a symlink
    if [[ "${PWD}/${file}" = `readlink ${HOME}/${file}` ]]; then
      log "Symlink already exists for ${file}"
    else
      log "Symlink already exists but have a different link."
    fi
  elif [[ -f "${HOME}/${file}" ]]; then
      log "An existing file was found at ${HOME}/${file}"
  elif [[ -d "${HOME}/${file}" ]]; then
      log "An existing folder was found at ${HOME}/${file}"
  else
    # Create a symlink for the remaining files
    log "Creating symlink for ${file}"
    ln -s "${PWD}/${file}" "${HOME}/${file}"
  fi
done
