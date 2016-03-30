#!/bin/bash

ignore_branches=("develop" "master")

local_branches=`git b`
local_branches=(${local_branches//\*})

remote_branches=`git b -r | grep -v HEAD`
remote_branches=${remote_branches//\*}
remote_branches=(${remote_branches//origin\/})

for local_branch in "${local_branches[@]}"; do
  ignore=false

  for ignore_branch in "${ignore_branches[@]}"; do
    if [[ ${local_branch} = ${ignore_branch} ]]; then
      ignore=true
      break
    fi
  done

  if [[ $ignore = true ]]; then
    continue
  fi

  found_on_remote=false

  for remote_branch in "${remote_branch[@]}"; do
    if [[ ${local_branch} = ${remote_branch} ]]; then
      found_on_remote=true
    fi
  done

  if [[ $found_on_remote ]]; then
    git branch -d ${local_branch}
  fi
done

