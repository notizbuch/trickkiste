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

#### create a branch "fix" with a fix, then merge the fix into master
```
git branch
(should be master)
git checkout -b fix
vi somefile
git add somefile
git commit
(now the fix is in "fix", go back to master and merge)
git checkout master
cat somefile
(is still unchanged)
git merge fix
cat somefile
(file is changed, fix is also in master)
```


#### roll back a local change (e.g. if accidentally changed a file)
```
checkout -f
```

#### store crednetials
```
git config --global credential.helper cache
```
