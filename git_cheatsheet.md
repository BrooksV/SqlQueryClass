& "C:\Program Files (x86)\Info Keep\info keep.exe"

Photography Co-worker Kevin Hecht (kevin.a.hecht@pwc.com)

# git config commands

- ps.readinglist.md -- Quick Reference Reading list of helpful PowerShell sites, articles, and documents

### Support for Long Paths

git config --system core.longpaths true

### git remote urls

git remote -v

## User Config

### To Set your username

git config --global user.name "FIRST_NAME LAST_NAME"

### To Set your email address

git config --global user.email "MY_NAME@example.com"

git config --global user.name "Brooks Vaughn"
git config --global user.email "18422308+BrooksV@users.noreply.github.com"

git config --worktree user.name "Brooks Vaughn"
git config --global user.email "18422308+BrooksV@users.noreply.github.com"

### Check configuration for your user

$ cat $HOME/.gitconfig

## Proxy Config

### Get system value

git config --system --get https.proxy
git config --system --get http.proxy

### Get global value

git config --global --get https.proxy
git config --global --get http.proxy

### Unset system value

$ git config --system --unset https.proxy
$ git config --system --unset http.proxy

### Unset global value

$ git config --global --unset https.proxy
$ git config --global --unset http.proxy

## Proxy Config using Environment Variables

Your proxy could also be set as an environment variable. Check if your environment has any of the env variables http_proxy or https_proxy set up and unset them. Examples of how to set up:

### Linux

export http_proxy=http://proxy:8080
export https_proxy=https://proxy:8443 

### Windows

set http_proxy http://proxy:8080 
set https_proxy https://proxy:8443

## SSL Config

git config --global http.sslVerify
git config --global http.sslVerify true

### Repro Clone SSL Errors

SSL_VERIFY=false
git config --global http.sslVerify false

My agents are running as Network Service too but that wasn't really a problem to use user level config. Here is what I did:
1.Save all the necessary certificates in folder %systemroot%\ServiceProfiles\NetworkService\.gitcerts\.
2.Create a file at %systemroot%\ServiceProfiles\NetworkService\.gitconfig with the following content:

[http "https://tfs.com/"](http "https://tfs.com/")
	sslCAInfo = ~/.gitcerts/certificate.pem

[adding-a-corporate-or-self-signed-certificate-authority-to-git-exes-store](https://blogs.msdn.microsoft.com/phkelley/2014/01/20/adding-a-corporate-or-self-signed-certificate-authority-to-git-exes-store/)

git config --global http.sslBackend schannel

[how-to-make-git-work-with-self-signed-ssl-certificates-on-tfs2018](https://www.benday.com/2017/12/15/how-to-make-git-work-with-self-signed-ssl-certificates-on-tfs2018/)
[fix-git-self-signed-certificate-in-certificate-chain-on-windows](https://mattferderer.com/fix-git-self-signed-certificate-in-certificate-chain-on-windows)

# Git Repo and Branch Commands

### Reset Local Master

git fetch origin master
git checkout master
git reset --hard origin/master
git reset origin/master --hard
git pull origin master

### Reset Local Main

git fetch origin main
git checkout main
git reset --hard origin/main
git pull origin main

If you want to create a new branch to retain commits you create, you may do so (now or later) by using -c with the switch command. 

Example:
  git switch -c <new-branch-name>

Or undo this operation with:
  git switch -

## Status and Info Commands

git status
git log
git branch --all
git branch features/<Branch name>


git fetch origin
git fetch origin master
git checkout master
git pull origin master
git checkout features/<Branch name>
git merge branch master
git status
git log
git push


git pull
git branch -a

## To Create Branch from Master

git fetch origin master
git checkout master
git pull origin master
git checkout -b features/???
git push --set-upstream origin features/???
git checkout features/???

### Create local branch

git checkout -b features/<branch name>
git status
git add foo.txt
git commit -m "<comment>"
git commit -a -m "<comment>" # ?
git push

### Create Branch on origin (UpStream) to Repository

git push --set-upstream origin features/<branch name>

### To sync local master

git checkout master
git pull

git checkout features/readme-updates
git merge master ????

# Notes

Origin is the plcae where the branch was cloned from

git remote add <name> <url>
git add -p
git log --online

npm config set strict-ssl false


# Git Merging commands

git merge branch master
git status
git log
git push


git config --get --local  core.filemode
false

git config --local --list

## Commits

git add yaml\???.yml
git commit -m "???"
git commit -a -m "<comment>" # ?
git push
git merge --abort
git branch -a --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
(git reflog > reflog.md) | Invoke-Item
git reflog | Select-String <issue trackerID>

### Explanation of what each of those Git commands do

### `git add yaml???.yml`

- **Description**: Adds files matching the pattern `yaml???.yml` to the staging area.
- **Wildcard**: The `???` matches exactly three characters, so this would match files like `yaml123.yml` or `yamlABC.yml`.
- **Example**: `git add yaml123.yml` or `git add yamlABC.yml`.

### `git commit -m "???"`

- **Description**: Commits the staged changes to the repository with a commit message `"???"`.
- **Purpose**: The message `"???"` is a placeholder and should be replaced with a meaningful description of the changes.
- **Example**: `git commit -m "Added new YAML configuration files"`.

### `git commit -a -m ""`

- **Description**: Commits all changes to tracked files (bypassing the staging area) with an empty commit message.
- **Purpose**: This is unusual because an empty commit message is generally not recommended. It's better to provide a meaningful commit message.
- **Example**: `git commit -a -m "Updated configuration files"`.

### `git push`

- **Description**: Pushes the committed changes from your local repository to the remote repository.
- **Purpose**: Sends your local commits to the remote repository (e.g., GitHub).
- **Example**: `git push origin master`.

### `git merge --abort`

- **Description**: Aborts the current merge process and attempts to revert the repository back to the state before the merge began.
- **Purpose**: Used when a merge conflict occurs, and you decide to cancel the merge and resolve conflicts later.
- **Example**: `git merge --abort` while in the middle of a conflicting merge.

### `git branch -a --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'`

- **Description**: Lists all branches sorted by the most recent commit date, with a custom format for the output.
- **Purpose**: Provides a detailed, color-coded list of branches, showing which branch is current (HEAD), commit hash, subject of the commit, author name, and the date relative to now.
- **Example**: `git branch -a --sort=-committerdate --format='...'`.

### `(git reflog > reflog.md) | Invoke-Item`

- **Description**: Redirects the output of `git reflog` to a file named `reflog.md` and opens the file.
- **Purpose**: Records the reflog (history of changes) into a markdown file and opens it in the default text editor.
- **Example**: `(git reflog > reflog.md) | Invoke-Item`.

### `git reflog | Select-String`

- **Description**: Displays the reflog and filters the results using `Select-String`.
- **Purpose**: Allows you to search the reflog for specific patterns or keywords.
- **Example**: `git reflog | Select-String "commit"` to find entries related to commits.

These commands cover a range of Git operations, from staging and committing changes to managing branches and searching through logs. Let me know if you have any more questions or need further details!

## Git Command docs

git remote add upstream 
git fetch upstream
git rebase upstream/master
git push origin master --force

### Explanation of what each of those Git commands does:

### `git remote add upstream`

This command adds a new remote repository, typically the original repository from which you forked your project.

```bash
git remote add upstream <URL>
```

- **Purpose**: To add a reference to the original repository (upstream) so you can pull updates from it.
- **Example**: If you forked a repository on GitHub, you would use the URL of the original repository.

### `git fetch upstream`

This command fetches updates from the `upstream` remote repository.

```bash
git fetch upstream
```

- **Purpose**: To get the latest changes from the upstream repository without merging them into your working branch.
- **Example**: This updates your local copy of the remote branches from the upstream repository.

### `git rebase upstream/master`

This command rebases your current branch on top of the `master` branch from the `upstream` repository.

```bash
git rebase upstream/master
```

- **Purpose**: To integrate changes from the upstream repository into your current branch by applying your local commits on top of the upstream/master branch.
- **Example**: Useful for keeping your forked repository up-to-date with the original repository.

### `git push origin master --force`

This command pushes your local `master` branch to the remote repository (origin) with force.

```bash
git push origin master --force
```

- **Purpose**: To overwrite the remote `master` branch with your local changes, even if it results in non-fast-forward updates.
- **Example**: Use with caution as it can overwrite changes in the remote repository that others may be relying on.
