# WizFight
This is the open source release of WizFight, a side-scrolling local multiplayer shooter with wizards that have oddly specific powers. It is provided as-is. Anything in this repository (except HaxePunk, which has its own license) should be considered public domain, but the assets are not.

##Requirements

To build the game as-is, you will need to install the following:

* [Haxe](https://haxe.org)
* HXCPP
* NME
* OpenFL
* A C/C++ compiler like gcc, mingw, or MSVC.

Once Haxe is installed, you can install everything else through Haxelib. You can then build the game by opening a command line or terminal, navigating to the wizfight folder that was created when you cloned the repository, and building and running it with the command `haxelib run nme test build.nmml cpp`. While you can attempt to build the game for other targets, it is only confirmed to work with the cpp target.

This copy of the source code will not compile without the assets. You can get the assets to build the game by downloading the pre-compiled release of the game from the itch.io page (https://twocredits.itch.io/wizfight). You should be able to simply copy the assets into their respective folders.

##Current build status

I recently cleaned up the game code, fixing the few errors that were keeping it from compiling and altering the compiler macros to allow it to build on Linux without any errors.

Here is the current build status for each platform.

###Windows

I have confirmed that the game builds and runs on Windows when built using mingw-w64. It will likely build and run with MSVC, as well, but I have not personally tested it.

###Linux

The game builds on Linux without any errors, but I have yet to be able to get it to run. Upon running, it throws an error, stating that it cannot find the sound device specified. I am currently looking for a fix.

###Mac OS X

While I can compile a Mac OS X build, I am unable to test it, as I no longer have a Mac OS X computer.

You can find more information about me and my current projects at https://twocredits.co.
