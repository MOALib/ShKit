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
# These functions should be used with $(), like $Var = $(readFile filePath)

# base utilities

# check if variable is defined
function isDefined() {
    # $1 is the variable to be tested
    if test -z "$1"
    then
        echo "notdef"
    else
        echo "def"
    fi
}

# get file extension
function getFileExtension(){
    # $1 is the name of the file
    echo ${$1%%.*}
}

# clear screen
function cls(){
    clear
}

# shell and process stuff

# get shell path
function getShellPath(){
    # no parameters needed
    echo $(readlink /proc/$$/exe)
}

# get shell name
function getShellName(){
    # no parameters needed
    echo $(basename $(getShellPath))
}


# get current working directory
function getCWD(){
    echo $(readlink /proc/$$/cwd)
}

# process stuff
function getProcessShellPath(){
    # $1 is the process ID
    echo $(readlink /proc/$1/exe)
}

function getProcessShellName(){
    echo $(basename $(getProcessShellPath $1))
}

function getProcessCWD(){
    echo $(readlink /proc/$1/cwd)
}


# misc/special functions

# read file
function readFile() {
    # $1 is the file path

    FilePath="$1";
    echo $(<$FilePath);
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



# say Hi on certain conditions
if test $(isDefined "$ShKit_NO_SPEAK") = "notdef"
then
    echo "Hi, I am ShKit. I am written by MXPSQL with shell script. Define the \$ShKit_NO_SPEAK variable if you want to tell me not to speak this message.";
fi

# check If I was sourced
BASH_SOURCE=".$0" # cannot be changed in bash
if test ".$0" = ".$BASH_SOURCE"
then
    echo "I was not sourced, please source or embed me to use me."
fi
