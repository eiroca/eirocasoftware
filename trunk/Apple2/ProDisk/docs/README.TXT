===============================================================================
                             PRODISK 1.0
                      Prodos HD <-> MsDos File

                           by Enrico Croce

                  Copyright (c) 1996 All Rights Reserved.
===============================================================================

This program is under GPL. PLEASE READ LICENSE.TXT for the complete authorization
notice.

DONATIONS of any kind are accepted and mails are appreciated. Please, send bug 
reports and requests to the author.

OVERVIEW

ProDisk allows inspection and import/export of the files contained in a Apple 2
ProDos Hard Disk Image file, for example the *.HDV file used by the ApplePC
emulator.

The program is a CLI (command line interpreter) that can be activated with: 
  ProDisk [harddisk[.hdv]]
harddisk.hdv is the optional name of then first opened Apple2-HD.
Now the following commands are available:
 exit                - exit the program
 help                - show the available commands
 open HD_name[.hdv]  - open the Apple2-HD called HD_name.hdv
 close               - close the current Apple2-HD
 dir or car or ls    - show file(s) contained in the current directory
 cd (or only DirName)- change the current directory
 import              - import a Ms-Dos file into ProDos one
 export              - esport a Prodos file into MS-Dos one
 importDir           - as import, but for all the file in the MsDos Dir.
 exportDir           - as export, but for all the file in the Prodos Dir.

A tipical session to import the file FOO.TXT of the Ms-Dos directory
c:\mydir into Prodos HD called c:\apple2\Hardy.HDV is:
ProDisk                    (* recall the program *)
open c:\apple2\hardy.hdv   (* CLI shows the label of Prodos HD *)
dir                        (* show the files in the directory  *)
import c:\mydir\foo.txt    (* import the file                  *)
quit                       (* bye                              *)

It is also present a Pascal unit (ProDos.pas) that allows to use Prodos HD in
your programs, unfortunately there is no specific documentation and the only 
way to learn about it is to show how the ProDisk program use it.

Sorry for this small documentation and the bad english.

REQUIREMENTS

  IBM PC or 100% compatible
  Windows compatible OS

 For recompilation is required:
  Delphi XE2
  Working knowledge of Pascal

===============================================================================

