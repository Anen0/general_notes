
## `Create a new repository on the command line`
	echo "# hello_world" >> README.md
	git init
	git add README.md
	git commit -m "first commit"
	git branch -M main
	git remote add origin https://github.com/Anen0/hello_world.git
	git push -u origin main
					
	…or push an existing repository from the command line
	git remote add origin https://github.com/Anen0/hello_world.git
	git branch -M main
	git push -u origin main

	pull from a repository
	git pull origin main

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Putting Personal Access Token`:
	git remote add origin https://<username>:<token>@github.com/<repo>.git
	   
------------------------------------------------------------------------------------------------------------------------------
	git config --global user.name 'Nomad'
	git config --global user.email "yur email"

	see the signed in user
	git config --global --list

        
## Ubuntu VM: `add shared folder`
	sudo usermod -aG vboxsf userName
_src_ : https://askubuntu.com/questions/161759/how-to-access-a-shared-folder-in-virtualbox

------------------------------------------------------------------------------------------------------------------------------
## `Set/change origin URL`
	git remote set-url origin (https://git-repo/new-repository.git)

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Renaming branches`
If you have a local clone, you can update it by running the following commands.

	git branch -m main_2 main
	git fetch origin
	git branch -u origin/main main
	git remote set-head origin -a

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Verify origin`
	git remote -v

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Delete a repo locally` 
	rm -rf .git*

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Show the URL to repo is taken from`
	git remote get-url origin

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Choose / make a branch`
	git checkout -b (name of branch)

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## Deleting `Branches`
-	Local branch
		
		git branch -d <branch>

-	Delete a branch that is not fully merged
	
		git branch -D <branch>

-	Remote branch
		
		git push <remote> --delete <branch>


<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## Exclude file or directory with `.gitignore`
-	Add .gitignore
		
	example :

		__pycache__/

-	If file/directory already tracked (already in GitHub)

		git rm -r --cache __pycache__

	-	`git rm -r` :	Removes the specified directory and its contents recursively
	-	`--cached` 	:	Specifies that the removal should only happen in the Git index (the repository history), not from your local filesystem 

	another example to ignore all of `__pycache__`:

		**/__pycache__/



<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `How can I remove a commit on GitHub?`
https://stackoverflow.com/questions/448919/how-can-i-remove-a-commit-on-github

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Forcing a push on unrelated branches`
	git pull origin branchname --allow-unrelated-histories

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Force a push` 
	git push origin <your_branch_name> --force

<!-- ------------------------------------------------------------------------------------------------------------------------------ -->


## `Syncing a fork` 
_source_:
https://stackoverflow.com/questions/7244321/how-do-i-update-a-github-forked-repository

The ***Setup***  
Before you can sync, you need to add a remote that points to the upstream repository. You may have done this when you originally forked.
Tip: Syncing your fork only updates your local copy of the repository; it does not update your repository on GitHub.

	$ git remote -v
	# List the current remotes
	origin  https://github.com/user/repo.git (fetch)
	origin  https://github.com/user/repo.git (push)

	$ git remote add upstream https://github.com/otheruser/repo.git
	# Set a new remote

	$ git remote -v
	# Verify new remote
	origin    https://github.com/user/repo.git (fetch)
	origin    https://github.com/user/repo.git (push)
	upstream  https://github.com/otheruser/repo.git (fetch)
	upstream  https://github.com/otheruser/repo.git (push)

***Syncing***  
There are two steps required to sync your repository with the upstream: first you must fetch from the remote, then you must merge the desired branch into your local branch.

***Fetching***  
Fetching from the remote repository will bring in its branches and their respective commits. These are stored in your local repository under special branches.

	$ git fetch upstream
	# Grab the upstream remote's branches
	remote: Counting objects: 75, done.
	remote: Compressing objects: 100% (53/53), done.
	remote: Total 62 (delta 27), reused 44 (delta 9)
	Unpacking objects: 100% (62/62), done.
	From https://github.com/otheruser/repo
	 * [new branch]      master     -> upstream/master

We now have the upstream's master branch stored in a local branch, upstream/master

	$ git branch -va
	# List all local and remote-tracking branches
	* master                  a422352 My local commit
	  remotes/origin/HEAD     -> origin/master
	  remotes/origin/master   a422352 My local commit
	  remotes/upstream/master 5fdff0f Some upstream commit

***Merging***
Now that we have fetched the upstream repository, we want to merge its changes into our local branch. This will bring that branch into sync with the upstream, without losing our local changes.

	$ git checkout master
	# Check out our local master branch
	Switched to branch 'master'

	$ git merge upstream/master
	# Merge upstream's master into our own
	Updating a422352..5fdff0f
	Fast-forward
	 README                    |    9 -------
	 README.md                 |    7 ++++++
	 2 files changed, 7 insertions(+), 9 deletions(-)
	 delete mode 100644 README
	 create mode 100644 README.md

If your local branch didn't have any unique commits, git will instead perform a "fast-forward":

	$ git merge upstream/master
	Updating 34e91da..16c56ad
	Fast-forward
	 README.md                 |    5 +++--
	 1 file changed, 3 insertions(+), 2 deletions(-)
 

<!-- ------------------------------------------------------------------------------------------------------------------------------   -->

## `Install GIT in Ubuntu`
	
	sudo apt install git-all


<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Reset to a previous version of a branch`

	git reset --hard <commit hash_key>


<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `Rebase/merge/ pro & con`

	GIT REBASE
		pro	-	allwos for a cleaner commit history
			-	provides a linear commit timeline
		con	-	reduces traceability	

	GIT MERGE
		pro	-	preserves commit history
		con	-	make the history messy	


<!-- ------------------------------------------------------------------------------------------------------------------------------ -->
## `GIT LOOSE OBJECT`
_src_ : https://stackoverflow.com/questions/4254389/git-corrupt-loose-objects

Your best bet is probably to simply re-clone from the remote repository (i.e., GitHub or other). 
Unfortunately you will lose any unpushed commits and stashed changes, however your working copy should remain intact.

First make a backup copy of your local files. Then do this from the root of your working tree:

	rm -fr .git
	git init
	git remote add origin [your-git-remote-url]
	git fetch
	git reset --mixed origin/master
	git branch --set-upstream-to=origin/master master

Then commit any changed files as necessary.


<!-- ------------------------------------------------------------------------------------------------------------------------------ -->


## `Missing credentials when logging in VSCode terminal`:
src : https://stackoverflow.com/questions/62860280/git-push-missing-or-invalid-credentials-fatal-authentication-failed-for-http

You are trying to use git from a terminal in vscode. The problem comes from the authentication handler of vscode. To solve the problem:

-	Open vscode File > Preferences > Settings
-	Search for git.terminalAuthentication
-	Uncheck the option

You have to re-open the terminal to make it work.





