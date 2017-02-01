# Using git locally with iMacs

1. Make a local repository on your working machine that you can push changes to.
> git init --bare ~/Local/imacsoft-local.git
2. Go to your development repo and add the new local repo as a remote.
> cd imac-software
> git remote add imacsoft-local ~/Local/imacsoft-local.git/
3. Update the local repository with the latest files from your development repo.
> git push imacsoft-local master

4. Now connect your iMac to the working machine (via firewire, ethernet, etc...)
5. SSH into the iMac or log in to the terminal. Initially you probably want to clone the repo from github. But you can also clone it from your local machine.
>imac> git clone https://github.com/jreus/imac.git
or if there's no internet connection
>imac> git clone jon@192.168.178.25:/Volumes/Store/jon/Local/imacsoft-local.git
6. Add the remote repo
>imac> git remote add jonmachine jon@192.168.178.25:/Volumes/Store/jon/Local/imacsoft-local.git
7. Now when you want to do some work on the dev machine, you can push/pull from your local repository.
> ???
8. And then pull the changes on your iMac
>imac> git pull jonmachine master
9. And if you make some changes on the iMac, you can push them to the remote
>imac> git push jonmachine master
10. And get those changes on the dev machine
> git pull imacsoft-local master

## More on working with remotes
https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes

## NOTE
*you may need to delete the RSA host key for 192.168.7.1 from known_hosts as its*
*possible someone else was working from a different machine with this Bela before you*
> nano /root/.ssh/known_hosts
