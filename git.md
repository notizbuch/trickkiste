#### create branch / switch between branches:

```
 1003  mkdir my-git-practice
 1004  cd my-git-practice
 1005  git add .
 1006  git init
 1007  vi test
 1008  git add test
 1009  git commit
 1010  git branch -v
 1011  git checkout -b production
 1012  vi test 
 1013  git add test
 1014  git commit 
 1015  cat test 
 1016  git checkout master
 1017  cat test 
```
#### roll back a local change (e.g. if accidentally changed a file)
```
checkout -f
```
