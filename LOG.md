## VIDEO CONVERSION
Audio Codec - AC3
Video Codec - MPEG1 seems to work well given the processing power of the imac
H264 works but is very slow...



# GITHUB SYNC
How to get git synching between a laptop and an iMac? Similar to how syncing works with Bela.

1. Download & install Git command line utilities on iMac and Laptop. For the imac this can be done by installing git and adding an alias git that goes to /opt/git/bin/git
2. Make a local copy of the repository on the laptop that will be used as a syncing point between the machines. You can put this repository wherever it makes sense.

mypc> git init --bare /Volumes/Store/Drive/DEV/imacmusic/imaclocal.git

3. Now go to your development repository (on your computer, linked to a repo on github) and add a new remote for the local sync repository:

mypc> cd imac/
mypc> git remote add local /Volumes/Store/Drive/DEV/imacmusic/imaclocal.git

4. Update the local sync repository with all the latest files from the master branch of your development repository.

mypc> git push local master


5. Now get a clone of the local sync repository on the iMac. You'll need to get the imac somehow networked to your laptop. This can be done via firewire. Go into the imac...

  1. Go into the imac... in Sharing enable Remote Login
  2. Go to Network settings and enable Built-in FireWire. In network port configurations drag built-in firewire up so that it's the primary network source.
  3. Give the imac an IP address, or use DHCP,
  4. Go back to your laptop, enable internet sharing for firewire/thunderbolt networks and enable remote login.
  5. On the firewire/thunderbolt port give your laptop a fixed IP address (with DHCP) like 192.168.7.10   
  5. SSH into the imac `ssh imac@192.168.2.2` and then enter the password `imac`

Alternatively, you can go into the terminal in the imac and clone from the laptop.
`git clone jon@192.168.7.10:Drive/DEV/imacmusic/imaclocal.git`

### listing the remotes is easy
$ git remote -v
origin  https://github.com/schacon/ticgit (fetch)
origin  https://github.com/schacon/ticgit (push


6. Finally, make an alias to your development laptop on the imac, so it's easy to transfer commits in both directions. If you use other development machines you may have to create multiple aliases.
`imac> git remote add jon jon@192.168.7.10:Drive/DEV/imacmusic/imaclocal.git`

To pull changes from the laptop, use
`imac> git pull jon master`

And push commits to the development machine... you'll be asked for jon's pw on the dev machine.
Note: you may need to enable ssh and other services in your working machine's system preferences.
`imac> git push jon master`

From there you can pull the changes into your development repo.
`mypc> git pull local master`
And push them up to Github



## Thurs Feb 19 2015
Last minute stuff before heading out to Leuven.
Make a control framework for supercollider
- SC scene switching from keyboard
- auto start on launch (hidden SC window --- hidden SC in general)
- make multiple scenes
- Can I route sound to light and to cpu?
Play a bunch and take notes of the effect of different probe placements
Write out a rough scoring of scenes and gestures. Give them names
Calibrate monitors

## Wed Feb 18 2015

Today I made some great progress in a number of areas. I was able to get two machines up and running - making the realization that one of my indigo machines has a pair of drop-in Samsung DRAM chips that are pin-for-pin identical to the Hynix chips in my other machine. About those Hynix chips, they were actually not Hynix chips at all but Micron chips - also drop-ins. Both the Micron and the Samsung chips are running not at 125Mhz as previously thought but at 166Mhz.

I marked these notes in the datasheets for those ram chips, and included them in the imac project folder.

Otherwise, I've made progress with SuperCollider, discovering the extremely powerful CocoaBridge hooks that allow one to create and utilize objects within the Cocoa Objective-C runtime via SuperCollider. This includes creating OSX-native windows and views of all shapes and colors. It's really wonderful.

It is also proven quite possible to run a signal from one machine's chips to another's mic input and have that signal be analyzed by SuperCollider in order to trigger graphic responses. At the moment I have only done very simple window opening and closing, but I imagine a window grid - or various scenes on both computers, and being able to move my focus from one to the other during the performance --- with the end having probes on both computers picking up the PWM signal.

I was able today to start playing around a bit, and it is clearly difficult to focus attention on both machines simulatenously, so it must be so that the two work together as a single instrument. I was able to get some truly beautiful glitch animations via slight messings of the operating system. And slowly adding more and more grabbers, which can be attached in-performance and even aligned on adjacent pins. I just have to be very conscious about which pins have what effect, both sonically and visually. These grabbers, though, give a phenomenally more malleable and fluid way of playing with the material.

Absolutely in future work I will need to experiment more with dynamics between sound response and visual response -- as well as the kind of analysis that can be done in SuperCollider. (frequency spectrum, window grids and patterning, modal rain, opacity waves, opening apps such as itunes and mail, running applescript commands - close all finder windows.., and have some keyboard commands for captaining the supercollider brain).

Also found this --- how to keep an installation running.. with tips for using SC in a non-standard way
http://sc3howto.blogspot.co.uk/2014/05/how-to-keep-installation-running.html



## Tue Feb 17 2015

Future Goals

- explore aesthetic and narrative dynamics between multiple machines (2 machines!)
- more stable / robust video handling and monitoring
- deeper understanding of video system and limitations
- new non-destructive probing + patching system (!)
- research into above and other similar possibilities (discussions with pro ee's)
- understanding of the functionality and limitations of the above (signal reflections, rf transmissions, problems with parallel lines and long line lengths)
- explorations of OS scripting and iconography (media archeological exploration of obsolete programming frameworks and OS structures)
- explorations of interconnections between machines (direct @ STEIM), indirect via SuperCollider and windowing
- finer, more accurate performance probe
- circuit prototypes for attachable/replaceable amplification tools for probe
- logging of compositional scenes
- incorporating the whole body into the ecosystem

This is my v2 iteration performance and what I can best expect. Whereas before it was simply probing and sound, now it is patching and interconnections.


## Sun Feb 15 2015
Experimented with new SMD micrograbber probes. They work very well but require special 0.8mm connectors.
