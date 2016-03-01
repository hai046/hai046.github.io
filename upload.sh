#!/usr/bin/env bash

git add .

git commit -m "merge"

git push origin master


cd developer

git add .
git commit -m "add md"
git push origin master
