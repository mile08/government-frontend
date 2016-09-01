#!/bin/bash

if ! type phantomjs > /dev/null; then
  echo 'PhantomJS was not found - installing...'
  sudo npm install --global phantomjs-prebuilt@2.1.7
fi

if ! type wraith > /dev/null; then
  echo 'Wraith was not found installing...'
  sudo gem install wraith -v 3.2.1
fi

current_checked_out_branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)

if [ $current_checked_out_branch == 'master' ]; then
  echo 'You are on master, check out your feature branch and try again.'
else
  if [[ ! -z $(git status -s) ]]; then
    echo 'You have dirty changes, commit them then try again.'
  else
    git checkout master

    cd test/wraith
    wraith history configs/history.yaml

    git checkout -

    wraith latest configs/history.yaml
    cd ../../
  fi
fi