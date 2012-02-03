#!/bin/bash
# This script will assist in moving an old TG2 project from a git repo onto the
# OpenShift Framework put together by Luke Macken.

proj="tg2app"
pack="tg2app"

read -p "Enter project name [$proj]: " -e temp
if [ -n "$temp" ]
then
    proj="$temp"
fi
read -p "Enter package name [$pack]: " -e temp
if [ -n "$temp" ]
then
    pack="$temp"
fi
read -p "Enter git repository to use: " -e repo

# Modify important files.
sed -e "s|tg2app/public|$proj/public|g" -e "s|wsgi/tg2app|wsgi/$pack|g" \
    -i .openshift/action_hooks/build
sed -e "s|wsgi/tg2app|wsgi/$pack|g" -i .openshift/action_hooks/deploy
sed -e "s|tg2app|$proj|g" -i wsgi/application
sed -e "s|tg2app|$proj|g" -i wsgi/tg2app/openshift.ini

# Remove the existing wsgi/tg2app directory to avoid confusion.
mv wsgi/tg2app/openshift.ini . 
rm -r wsgi/tg2app

# Pull the existing repository as a submodule.
git submodule add "$repo" "wsgi/$proj"
mv openshift.ini wsgi/$proj/

patch "wsgi/$proj/$pack/config/app_cfg.py" < app_cfg.patch
