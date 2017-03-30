#!/bin/bash
# This command gets the location of the directory that holds this script.  We
# use this to set up the rest of the paths for launching.  If you want to copy
# this script elsewhere, you should modify BPHOMEDIR to explicitly set the 
# location where BridgePoint is installed to.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BPHOMEDIR="$DIR/../../.."

function die() {
  echo -e $@
  exit 1
}

function displayHelp() {
  echo -e ""
  echo -e "Usage:  ./CLI.sh <Build | Import | Execute | Merge | Launch> <Argument List>"
  echo -e ""
  echo -e "Example:"
  echo -e "  ./CLI.sh Build -project MicrowaveOven -buildConfig Debug -cleanCLI"
  echo -e ""
  echo -e "To list complete usage information for a command:"
  echo -e "   ./CLI.sh Build -help"
  echo -e "   ./CLI.sh Import -help"
  echo -e "   ./CLI.sh Execute -help"
  echo -e "   ./CLI.sh Merge -help"
  echo -e "   ./CLI.sh Launch -help"
  echo -e ""
  echo -e "Note that you must edit the WORKSPACE variable inside this CLI.sh"
  echo -e "to point at the appropriate workspace."
  echo -e ""
  echo -e "For additional information, see the Command Line Interface "
  echo -e "documentation inside the Help system."
  echo -e "" 
  exit 2
}

# Check that a valid argument is specified
if [ "$1" != "Build" ]; then
  if [ "$1" != "Execute" ]; then
    if [ "$1" != "Import" ]; then
       if [ "$1" != "Merge" ]; then
           if [ "$1" != "Launch" ]; then
              displayHelp
           fi
       fi
    fi
  fi
fi

if [ "${WORKSPACE}" == "" ]; then
    #
    # Since the workspace to use is not set, use the standard location.  
    # Users may choose to set the value in the environment, or modify 
    # the following line to point to the correct location.    
    #
    export WORKSPACE="$HOME/workspace"
fi

[ $WORKSPACE ] || die "No workspace to use is set up in ENV variable WORKSPACE."

#
# DO NOT MODIFY ANY OF THE FOLLOWING LINES.
#
APPLICATION="org.xtuml.bp.cli.$1"
export JVM_ARG="-vm $BPHOMEDIR/jre/bin/java"
if [[ `uname` == "Darwin" ]]; then
    export JVM_ARG=""
fi

# handle Launch commands
export BPHOME=$BPHOMEDIR
CLI_FILE=$DIR/CLI_PORT.txt
if [ "$1" == "Launch" ]; then
    # exit the launched eclipse instance
    if [[ $# -eq 2 && "$2" == "-exit" ]]; then
        stat $CLI_FILE &> /dev/null
        if [ $? -eq 0 ]; then
            python $DIR/launch-cli.py cmd `cat $CLI_FILE` exit
            rm -f $CLI_FILE
        else
            echo "No command line instance running"
            exit 1
        fi
    # launch an instance
    elif [ $# -eq 1 ]; then
        python $DIR/launch-cli.py launch $CLI_FILE
        chmod 400 $CLI_FILE
    # show launch command help
    elif [[ $# -eq 2 && "$2" == "-help" ]]; then
        echo "USAGE:"
        echo
        echo "./CLI.sh Launch"
        echo
        echo "    Launch a command line instance of BridgePoint in the background. Following"
        echo "    calls to CLI.sh will attach to this instance."
        echo
        echo "./CLI.sh Launch -exit"
        echo
        echo "    Terminate the current running CLI instance"
        echo
        echo "./CLI.sh Launch -help"
        echo
        echo "    Display command help"
    else
        displayHelp
    fi
else
    stat $CLI_FILE &> /dev/null
    if [ $? -eq 0 ]; then
        # an instance is running, attach to it
        python $DIR/launch-cli.py cmd `cat $CLI_FILE` ${@:1}
    else
        # run the normal way
        $BPHOMEDIR/bridgepoint --launcher.suppressErrors $JVM_ARG -clean -noSplash -data $WORKSPACE -application $APPLICATION $2 "$3" $4 "$5" $6 "$7" $8 "$9"
    fi
fi
 
exit 0
