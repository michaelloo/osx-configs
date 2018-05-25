#!/bin/bash

# Local branches
git branch --merged | grep -Ev "(develop|master)" | xargs -I branch git b -d branch

# Remote branches
# git branch -r --merged | grep -Ev "(develop|master)"  | sed "s/origin\///" | xargs -I branch git push -d origin branch
