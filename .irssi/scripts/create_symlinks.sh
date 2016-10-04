#!/bin/bash

FORCE_RECREATE=${FORCE:-0}
HARD_STOP=$SCRIPT_DIR/.do_not_scan
SCRIPT_DIR=/home/$USER/.irssi/scripts
SCRIPT_DIR_AUTORUN=/home/$USER/.irssi/scripts/autorun

if [ -f "$HARD_STOP" ]; then
    # Symlink creation has already completed, the script won't run again until
    # the $HARD_STOP trigger file is removed.
    printf "INFO: The script has already been run and the symlinks created.\n"
    printf "INFO: Remove the .do_not_symlink file and run the script again.\n"
    exit
else
    # Push the current working directory.
    # Useful if we're being run out of tree so we can return to it later.
    pushd `pwd`
    # Make sure we're in the right directory if this is run out of tree
    cd $SCRIPT_DIR_AUTORUN
    # Walk $SCRIPT_DIR for .pl files and link them here.
    
    if [ "$FORCE_RECREATE" = "1" ]; then
        # Force creation of existing symbolic links.
        printf "INFO: Forceing creation of existing symbolic links.\n"
        find $SCRIPT_DIR -maxdepth 1 -type f -name "*.pl" -exec ln -fs '{}' \;
    else
        # Only create new symbolic links.
        # Send the STDERR noise about existing symbolic links to /dev/null
        printf "INFO: Only creating new symbolic links.\n"
        printf "INFO: To force creation of existing symbolic links run with:\n"
        printf "      FORCE=1 create_symlinks.sh"
        find $SCRIPT_DIR -maxdepth 1 -type f -name "*.pl" -exec ln -s '{}' \; 2>/dev/null
    fi
    # Create the $HARD_STOP file.
    touch $HARD_STOP
    # Pop the original working directory.
    popd
    exit
fi
