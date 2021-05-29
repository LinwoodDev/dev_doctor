#!/bin/bash

if [[ "$BRANCH" == "gh-pages" ]] ; then
  # Do not build
  exit 0;

else
  # Build
  exit 1;
fi
