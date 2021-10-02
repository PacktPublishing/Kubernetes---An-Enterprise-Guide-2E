#!/bin/bash

ssh-keyscan -p 2222 $1 2>&1 | sed 's/[:]2222//g' | sed 's/[[]//g' | sed 's/[]]//g'  | sed "s/$1/gitlab-gitlab-shell.gitlab.svc.cluster.local/g"