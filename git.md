#### create branch / switch between branches:

```
 mkdir my-git-practice
 cd my-git-practice
 git add .
 git init
 vi test
 git add test
 git commit
 git branch -v
 git checkout -b production
 vi test 
 git add test
 git commit 
 cat test 
 git checkout master
 cat test 
```

#### roll back a local change (e.g. if accidentally changed a file)
```
checkout -f
```
