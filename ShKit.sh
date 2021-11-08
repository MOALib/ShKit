#!/bin/false

# MIT License
# 
# Copyright (c) 2021 MXPSQL Server 20953 onetechguy
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 

# ShKit
# Shel Utilities
#
# This file should be sourced, not runned. In fact, I used #!/bin/false to prevent standalone execution
# Some of hese functions should be used with $(), like $Var = $(readFile filePath)

# base utilities

# check if variable is defined
function isDefined() {
    # $1 is the variable to be tested
    if test -z "$1"
    then
        echo "notdef";
    else
        echo "def";
    fi
}

# clean the tmp directory
function cleanTmp() {
    # no parameters needed
    rm -r /tmp/*;
}

# make script executable
function ExecutableChmod() {
    # $1 is the script to be made executable
    chmod u+x "$1";
}

# error out
function die() {
    # $1 is the error code, $2 is the message

    local code=$? now=$(date +%T.%N)
    if [ "$1" -ge 0 ] 2>/dev/null; then  # assume $1 is an error code if numeric
      code="$1"
      shift
    fi
    echo "$0: ERROR at ${now%???}${1:+: $*}" >&2
    exit $code
}

# get file extension
function getFileExtension(){
    # $1 is the name of the file
    echo ${$1%%.*};
}

# clear screen
function cls(){
    # no parameters needed
    clear;
}

# shell and process stuff

# get shell path
function getShellPath(){
    # no parameters needed
    echo $(readlink /proc/$$/exe);
}

# get shell name
function getShellName(){
    # no parameters needed
    echo $(basename $(getShellPath));
}


# get current working directory
function getCWD(){
    echo $(readlink /proc/$$/cwd)
}

# process stuff

# get process shell path
function getProcessShellPath(){
    # $1 is the process ID
    echo $(readlink /proc/$1/exe);
}

# get process shell name
function getProcessShellName(){
    # $1 is the process ID
    echo $(basename $(getProcessShellPath $1));
}

# get process current working directory
function getProcessCWD(){
    # $1 is the process ID
    echo $(readlink /proc/$1/cwd);
}


# misc/special functions

# read file
function readFile() {
    # $1 is the file path

    FilePath="$1";
    echo $(cat $FilePath);
    FilePath="";
}




# generate random number
function  randInt() {
    # $1 is the min number, $2 is the max number, $3 is the count and it is one if not provided
    Count="";
    if test $(isDefined $3) = "def"
    then
        Count=$3
    else
        Count="1"
    fi


    RandIntRes=$(shuf -i $1-$2 -n $Count)
    echo $RandIntRes;
    RandIntRes="";
    Count="";
}

# dictionaries

if test $(isDefined $ShKit_NO_DICTIONARIES) = "notdef"
then
    # make new dictionary
    function newDictionary() {
        # no parameters needed
        echo $(mktemp -d);
    }

    # set dictionary keys
    function setDictionaryKey() {
        # $1 is the dictionary, $2 is the key, $3 is the value
        echo "$3" > "$1/$2";
    }

    # get dictionary keys
    function getDictionaryKey() {
        # $1 is the dictionary, $2 is the key
        echo $(readFile "$1/$2");
    }

    # remove dictionary keys
    function remDictionaryKey() {
        # $1 is the dictionary, $2 is the key
        rm "$1/$2";
    }

    # delete dictionary from enviorment and existence by snapping the infinity glove that thanos has.
    function delDictionary() {
        # $1 is th;e dictionary
        rm -r "$1"
    }
fi

# pager cat, this is a bad version of more
function pgcat () {
    # $1 is the file to be cat and paged, put $2 for the duration of the sleep and don't define it if you don't want sleep


    if test $(isDefined $1) = "notdef"
    then
        die 1 "Argument not provided";
    fi

    Pgcat_n=1;

    Pgcat_line="";

    Pgcat_read="";

    echo "pgcat, press [ENTER] to continue when paging.";
    echo "";

    while read line; do
        # reading each line
        echo $line


        while true; do
            read -n 1 -p "" < /dev/tty;
            break
        done
        
    done < $1;

    echo "";
    echo "EOF";

    if test $(isDefined $2) = "def"
    then
        sleep $2;
    fi
}


# say Hi on certain conditions
if test $(isDefined "$ShKit_NO_SPEAK") = "notdef"
then
    echo "Hi, I am ShKit. I am written by MXPSQL with shell script. Define the \$ShKit_NO_SPEAK variable if you want to tell me not to speak this message.";
fi

# check If I was sourced
BASH_SOURCE=".$0" # cannot be changed in bash
if test ".$0" = ".$BASH_SOURCE"
then
    echo "I was not sourced, please source or embed me to use me. I do not permit standalone execution of my self.";
    die 1 "Standalone execution not permitted.";
fi
