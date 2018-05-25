#!/bin/bash

set -e

# Script to branch out from develop and name the branch according to the inputs

card_number=$1
branch_details=$2

git up
git co develop
git co -b feature/DMPM-${card_number}-ML-${branch_details}

