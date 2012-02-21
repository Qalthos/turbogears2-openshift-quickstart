rm -rf wsgi .git/modules .gitmodules
git checkout -- wsgi/ .openshift/
git reset HEAD
