#!/bin/sh

rm -fr ${HOME}/.tmp/jekyll

JEKYLL_ENV=production jekyll build --destination $HOME/.tmp/jekyll

git checkout gh-pages

#
#git add -A
#git status
#git commit -m "Initial - branch1"
#git push --set-upstream origin branch1

