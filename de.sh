#!/bin/bash

# Less painful then rm :(

# Author: Aaron Coffey (aaron@coffey.works)
# No idea when this was written, probably around 2014.
# Adding it to github for a laugh.

# ToDo:
# -Make the -p switch safer by suggesting -l to double check, and making the user hit y to confirm.
# -Either catch errors from mv or double check that all files to be deleted actually exist.

# Path to trash folder, remember this is the same path that root will use.
trash=~/trash

# Prints message if no file is given
if [ -z "$1" ]; then
    echo "de is less painful then rm"
    echo "de -h for help"
    exit 0
fi

# Gives help messages and commands check, purge, and list.
while getopts ":chpl" opt; do
    case $opt in
        c)
            # Gives the size of the trash directory, this could use improvement.
            echo `du -sh $trash/`
            exit 0
            ;;
        h)
            echo "Very simple, type 'de filename' without quotes."
            echo "de -h for this help message"
            echo "de -c to check trash size"
            echo "de -p to purge trash"
            echo "de -l to list trash contents"
            echo "Using $trash as trashbin"
            exit 0
            ;;
        p)
            # this needs a check to make sure the -p switch was not selected by mistake
            # should also encourage the use of the -l switch to double check files to be discarded
            # First checks that trash is full, then permenently deletes the trash.
            if [ "$(ls -A $trash)" ]; then
                                echo "de - Purging Trash..."
                            rm -r $trash/*
                            echo "de - Trash Purged"
                            exit 0
                        else
                                echo "de - Trash is Empty. Unable to Purge"
                                exit 1
                        fi
            ;;
        l)
            # First checks if trash is empty, if not, displays the contents via less.
            if [ "$(ls -A $trash)" ]; then
                ls -lAhR $trash/* | less
                exit 0
            else
                echo "de - Trash is Empty. Unable to List"
                exit 1
            fi
            ;;
        \?)
            echo "de -h for help"
            exit 1
            ;;
    esac
done

# Checks that the file to be removed actually exists
# This needs work, currently does not check any file other than the first, sorta useless, unimplemented for now.
#if [ ! -e "$1" ]; then
#   echo "de - $1 does not exist. Cannot Remove"
#   exit 1
#fi

# ensures the trash folder exists
if [ ! -e "$trash" ]; then
    echo "de - no trash folder"
    mkdir $trash
    echo "de - created trash folder at $trash/"
    echo "de - continuing with trash removal"
fi

# To avoid clobbering files already in the trash we first check if a similarly named folder exists
# then create a folder with the date command, and move all named files into the folder.
sec=`date +%s`
if [ -e "$trash/$sec" ]; then
    echo "de - woah, too quick, try again in a second"
    exit 1
else
    mkdir $trash/$sec
    mv $@ $trash/$sec/
    exit 0
fi

echo "de - hmm, something went wrong, try again?"
exit 1
