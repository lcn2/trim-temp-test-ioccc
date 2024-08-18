#!/usr/bin/env bash
#
# sort.gitignore.sh - sort .gitignore file
#
# Usage:
#
#	sort.gitignore.sh YYYY/dir
#
# Recommended usage:
#
#	bin/all-run.sh bin/sort.gitignore.sh
#
# We use bin/sgi.sh to sort the content of a .gitignore file as follows:
#
# We sort with lines starting with # first.
# We sort with lines starting with * second.
# We sort with lines that do not start with [#!*] third.
# We sort with lines starting with ! fourth.
#
# Copyright (c) 2024 by Landon Curt Noll.  All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright, this permission notice and text
# this comment, and the disclaimer below appear in all of the following:
#
#       supporting documentation
#       source copies
#       source works derived from this source
#       binaries derived from this source or from derived source
#
# LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
# EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# chongo (Landon Curt Noll, http://www.isthe.com/chongo/index.html) /\oo/\
#
# Share and enjoy! :-)


# firewall - run only with a bash that is version 5.1.8 or later
#
# The "/usr/bin/env bash" command must result in using a bash that
# is version 5.1.8 or later.
#
# We could relax this version and insist on version 4.2 or later.  Versions
# of bash between 4.2 and 5.1.7 might work.  However, to be safe, we will require
# bash version 5.1.8 or later.
#
# WHY 5.1.8 and not 4.2?  This safely is done because macOS Homebrew bash we
# often use is "version 5.2.26(1)-release" or later, and the RHEL Linux bash we
# use often use is "version 5.1.8(1)-release" or later.  These versions are what
# we initially tested.  We recommend you either upgrade bash or install a newer
# version of bash and adjust your $PATH so that "/usr/bin/env bash" finds a bash
# that is version 5.1.8 or later.
#
# NOTE: The macOS shipped, as of 2024 March 15, a version of bash is something like
#	bash "version 3.2.57(1)-release".  That macOS shipped version of bash
#	will NOT work.  For users of macOS we recommend you install Homebrew,
#	(see https://brew.sh), and then run "brew install bash" which will
#	typically install it into /opt/homebrew/bin/bash, and then arrange your $PATH
#	so that "/usr/bin/env bash" finds "/opt/homebrew/bin" (or whatever the
#	Homebrew bash is).
#
# NOTE: And while MacPorts might work, we noticed a number of subtle differences
#	with some of their ported tools to suggest you might be better off
#	with installing Homebrew (see https://brew.sh).  No disrespect is intended
#	to the MacPorts team as they do a commendable job.  Nevertheless we ran
#	into enough differences with MacPorts environments to suggest you
#	might find a better experience with this tool under Homebrew instead.
#
if [[ -z ${BASH_VERSINFO[0]} ||
	 ${BASH_VERSINFO[0]} -lt 5 ||
	 ${BASH_VERSINFO[0]} -eq 5 && ${BASH_VERSINFO[1]} -lt 1 ||
	 ${BASH_VERSINFO[0]} -eq 5 && ${BASH_VERSINFO[1]} -eq 1 && ${BASH_VERSINFO[2]} -lt 8 ]]; then
    echo "$0: ERROR: bash version needs to be >= 5.1.8: $BASH_VERSION" 1>&2
    echo "$0: Warning: bash version >= 4.2 might work but 5.1.8 was the minimum we tested" 1>&2
    echo "$0: Notice: For macOS users: install Homebrew (see https://brew.sh), then run" \
	 ""brew install bash" and then modify your \$PATH so that \"#!/usr/bin/env bash\"" \
	 "finds the Homebrew installed (usually /opt/homebrew/bin/bash) version of bash" 1>&2
    exit 4
fi


# setup bash file matching
#
# We must declare arrays with -ag or -Ag, and we need loops to "export" modified variables.
# This requires a bash with a version 4.2 or later.  See the larger comment above about bash versions.
#
shopt -s nullglob	# enable expanded to nothing rather than remaining unexpanded
shopt -u failglob	# disable error message if no matches are found
shopt -u dotglob	# disable matching files starting with .
shopt -u nocaseglob	# disable strict case matching
shopt -u extglob	# enable extended globbing patterns
shopt -s globstar	# enable ** to match all files and zero or more directories and subdirectories


# set variables referenced in the usage message
#
export VERSION="1.1.8 2024-07-28"
NAME=$(basename "$0")
export NAME
export V_FLAG=0
GIT_TOOL=$(type -P git)
export GIT_TOOL
if [[ -z "$GIT_TOOL" ]]; then
    echo "$0: FATAL: git tool is not installed or not in PATH" 1>&2
    exit 5
fi
"$GIT_TOOL" rev-parse --is-inside-work-tree >/dev/null 2>&1
status="$?"
if [[ $status -eq 0 ]]; then
    TOPDIR=$("$GIT_TOOL" rev-parse --show-toplevel)
fi
export TOPDIR
export REPO_TOP_URL="https://github.com/ioccc-src/temp-test-ioccc"
# GitHub puts individual files under the "blob/master" sub-directory.
export REPO_URL="$REPO_TOP_URL/blob/master"
export TOP_URL="https://ioccc-src.github.io/temp-test-ioccc"


# set usage message
#
export USAGE="usage: $0 [-h] [-v level] [-V] [-d topdir] [-n] [-N]
			YYYY/dir

	-h		print help message and exit
	-v level	set verbosity level (def level: 0)
	-V		print version string and exit

	-d topdir	set topdir (def: $TOPDIR)

	-n		go thru the actions, but do not update any files (def: do the action)
	-N		do not process file, just parse arguments and ignore the file (def: process the file)

	YYYY/dir	path from topdir to entry directory: must contain the files: README.md, .path and .entry.json

Exit codes:
     0         all OK
     1	       some internal tool exited non-zero
     2         -h and help string printed or -V and version string printed
     3         command line error
     4         bash version is too old
     5	       some internal tool is not found or not an executable file
     6	       problems found with or in the topdir or topdir/YYYY directory
     7	       problems found with or in the entry topdir/YYYY/dir directory
 >= 10         internal error

$NAME version: $VERSION"


# setup
#
export NOOP=
export DO_NOT_PROCESS=


# parse command line
#
while getopts :hv:Vd:nN flag; do
  case "$flag" in
    h) echo "$USAGE" 1>&2
	exit 2
	;;
    v) V_FLAG="$OPTARG"
	;;
    V) echo "$VERSION"
	exit 2
	;;
    d) TOPDIR="$OPTARG"
	;;
    n) NOOP="-n"
	;;
    N) DO_NOT_PROCESS="-N"
	;;
    \?) echo "$0: ERROR: invalid option: -$OPTARG" 1>&2
	echo 1>&2
	print_usage 1>&2
	exit 3
	;;
    :) echo "$0: ERROR: option -$OPTARG requires an argument" 1>&2
	echo 1>&2
	echo "$USAGE" 1>&2
	exit 3
	;;
    *) echo "$0: ERROR: unexpected value from getopts: $flag" 1>&2
	echo 1>&2
	echo "$USAGE" 1>&2
	exit 3
	;;
  esac
done
#
# parse the command line arguments
#
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: debug level: $V_FLAG" 1>&2
fi
#
shift $(( OPTIND - 1 ));
#
if [[ $V_FLAG -ge 5 ]]; then
    echo "$0: debug[5]: file argument count: $#" 1>&2
fi
if [[ $# -ne 1 ]]; then
    echo "$0: ERROR: expected 1 arg, found: $#" 1>&2
    exit 3
fi
#
export ENTRY_PATH="$1"


# verify that we have a topdir directory
#
REPO_NAME=$(basename "$REPO_TOP_URL")
export REPO_NAME
if [[ -z $TOPDIR ]]; then
    echo "$0: ERROR: cannot find top of git repo directory" 1>&2
    echo "$0: Notice: if needed: $GIT_TOOL clone $REPO_TOP_URL; cd $REPO_NAME" 1>&2
    exit 6
fi
if [[ ! -e $TOPDIR ]]; then
    echo "$0: ERROR: TOPDIR does not exist: $TOPDIR" 1>&2
    echo "$0: Notice: if needed: $GIT_TOOL clone $REPO_TOP_URL; cd $REPO_NAME" 1>&2
    exit 6
fi
if [[ ! -d $TOPDIR ]]; then
    echo "$0: ERROR: TOPDIR is not a directory: $TOPDIR" 1>&2
    echo "$0: Notice: if needed: $GIT_TOOL clone $REPO_TOP_URL; cd $REPO_NAME" 1>&2
    exit 6
fi


# cd to topdir
#
if [[ ! -e $TOPDIR ]]; then
    echo "$0: ERROR: cannot cd to non-existent path: $TOPDIR" 1>&2
    exit 6
fi
if [[ ! -d $TOPDIR ]]; then
    echo "$0: ERROR: cannot cd to a non-directory: $TOPDIR" 1>&2
    exit 6
fi
export CD_FAILED
if [[ $V_FLAG -ge 5 ]]; then
    echo "$0: debug[5]: about to: cd $TOPDIR" 1>&2
fi
cd "$TOPDIR" || CD_FAILED="true"
if [[ -n $CD_FAILED ]]; then
    echo "$0: ERROR: cd $TOPDIR failed" 1>&2
    exit 6
fi
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: now in directory: $(/bin/pwd)" 1>&2
fi


# verify that we have a bin subdirectory
#
export BIN_PATH="$TOPDIR/bin"
if [[ ! -d $BIN_PATH ]]; then
    echo "$0: ERROR: bin is not a directory under topdir: $BIN_PATH" 1>&2
    exit 6
fi
export BIN_DIR="bin"


# verify that the bin/sgi.sh tool is executable
#
export SGI_TOOL="$BIN_DIR/sgi.sh"
if [[ ! -e $SGI_TOOL.sh ]]; then
    echo  "$0: ERROR: bin/sgi.sh does not exist: $SGI_TOOL.sh" 1>&2
    exit 5
fi
if [[ ! -f $SGI_TOOL.sh ]]; then
    echo  "$0: ERROR: bin/sgi.sh is not a regular file: $SGI_TOOL.sh" 1>&2
    exit 5
fi
if [[ ! -x $SGI_TOOL.sh ]]; then
    echo  "$0: ERROR: bin/sgi.sh is not an executable file: $SGI_TOOL.sh" 1>&2
    exit 5
fi


# verify that ENTRY_PATH is a entry directory
#
if [[ ! -d $ENTRY_PATH ]]; then
    echo "$0: ERROR: arg is not a directory: $ENTRY_PATH" 1>&2
    exit 3
fi
if [[ ! -w $ENTRY_PATH ]]; then
    echo "$0: ERROR: arg is not a writable directory: $ENTRY_PATH" 1>&2
    exit 3
fi
export YEAR_DIR=${ENTRY_PATH%%/*}
if [[ -z $YEAR_DIR ]]; then
    echo "$0: ERROR: arg not in YYYY/dir form: $ENTRY_PATH" 1>&2
    exit 3
fi
export ENTRY_DIR=${ENTRY_PATH#*/}
if [[ -z $ENTRY_DIR ]]; then
    echo "$0: ERROR: arg: $ENTRY_PATH not in $YEAR_DIR/dir form: $ENTRY_PATH" 1>&2
    exit 3
fi
if [[ $ENTRY_DIR = */* ]]; then
    echo "$0: ERROR: dir from arg: $ENTRY_PATH contains a /: $ENTRY_DIR" 1>&2
    exit 3
fi
if [[ ! -d $YEAR_DIR ]]; then
    echo "$0: ERROR: YYYY from arg: $ENTRY_PATH is not a directory: $YEAR_DIR" 1>&2
    exit 3
fi
export ENTRY_ID="${YEAR_DIR}_${ENTRY_DIR}"
export DOT_YEAR="$YEAR_DIR/.year"
if [[ ! -s $DOT_YEAR ]]; then
    echo "$0: ERROR: not a non-empty file: $DOT_YEAR" 1>&2
    exit 6
fi
# Now that we have moved to topdir, form and verify YYYY_DIR is a writable directory
export YYYY_DIR="$YEAR_DIR/$ENTRY_DIR"
if [[ ! -e $YYYY_DIR ]]; then
    echo "$0: ERROR: YYYY/dir from arg: $ENTRY_PATH does not exist: $YYYY_DIR" 1>&2
    exit 7
fi
if [[ ! -d $YYYY_DIR ]]; then
    echo "$0: ERROR: YYYY/dir from arg: $ENTRY_PATH is not a directory: $YYYY_DIR" 1>&2
    exit 7
fi
if [[ ! -w $YYYY_DIR ]]; then
    echo "$0: ERROR: YYYY/dir from arg: $ENTRY_PATH is not a writable directory: $YYYY_DIR" 1>&2
    exit 7
fi
export DOT_PATH="$YYYY_DIR/.path"
if [[ ! -s $DOT_PATH ]]; then
    echo "$0: ERROR: not a non-empty file: $DOT_PATH" 1>&2
    exit 7
fi
DOT_PATH_CONTENT=$(< "$DOT_PATH")
export DOT_PATH_CONTENT
if [[ $ENTRY_PATH != "$DOT_PATH_CONTENT" ]]; then
    echo "$0: ERROR: arg: $ENTRY_PATH does not match $DOT_PATH contents: $DOT_PATH_CONTENT" 1>&2
    exit 7
fi
export ENTRY_JSON="$YYYY_DIR/.entry.json"
if [[ ! -e $ENTRY_JSON ]]; then
    echo "$0: ERROR: .entry.json does not exist: $ENTRY_JSON" 1>&2
    exit 7
fi
if [[ ! -f $ENTRY_JSON ]]; then
    echo "$0: ERROR: .entry.json is not a file: $ENTRY_JSON" 1>&2
    exit 7
fi
if [[ ! -r $ENTRY_JSON ]]; then
    echo "$0: ERROR: .entry.json is not a readable file: $ENTRY_JSON" 1>&2
    exit 7
fi


# verify .gitignore
#
export GITIGNORE="$YEAR_DIR/$ENTRY_DIR/.gitignore"
if [[ ! -e $GITIGNORE ]]; then
    echo "$0: ERROR: .entry.json does not exist: $GITIGNORE" 1>&2
    exit 7
fi
if [[ ! -f $GITIGNORE ]]; then
    echo "$0: ERROR: .entry.json is not a file: $GITIGNORE" 1>&2
    exit 7
fi
if [[ ! -w $GITIGNORE ]]; then
    echo "$0: ERROR: .entry.json is not a writable file: $GITIGNORE" 1>&2
    exit 7
fi


# parameter debugging
#
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: VERSION=$VERSION" 1>&2
    echo "$0: debug[3]: NAME=$NAME" 1>&2
    echo "$0: debug[3]: V_FLAG=$V_FLAG" 1>&2
    echo "$0: debug[3]: GIT_TOOL=$GIT_TOOL" 1>&2
    echo "$0: debug[3]: TOPDIR=$TOPDIR" 1>&2
    echo "$0: debug[3]: REPO_TOP_URL=$REPO_TOP_URL" 1>&2
    echo "$0: debug[3]: REPO_URL=$REPO_URL" 1>&2
    echo "$0: debug[3]: TOP_URL=$TOP_URL" 1>&2
    echo "$0: debug[3]: NOOP=$NOOP" 1>&2
    echo "$0: debug[3]: DO_NOT_PROCESS=$DO_NOT_PROCESS" 1>&2
    echo "$0: debug[3]: ENTRY_PATH=$ENTRY_PATH" 1>&2
    echo "$0: debug[3]: REPO_NAME=$REPO_NAME" 1>&2
    echo "$0: debug[3]: CD_FAILED=$CD_FAILED" 1>&2
    echo "$0: debug[3]: BIN_PATH=$BIN_PATH" 1>&2
    echo "$0: debug[3]: BIN_DIR=$BIN_DIR" 1>&2
    echo "$0: debug[3]: SGI_TOOL=$SGI_TOOL" 1>&2
    echo "$0: debug[3]: YEAR_DIR=$YEAR_DIR" 1>&2
    echo "$0: debug[3]: ENTRY_DIR=$ENTRY_DIR" 1>&2
    echo "$0: debug[3]: ENTRY_ID=$ENTRY_ID" 1>&2
    echo "$0: debug[3]: DOT_YEAR=$DOT_YEAR" 1>&2
    echo "$0: debug[3]: YYYY_DIR=$YYYY_DIR" 1>&2
    echo "$0: debug[3]: DOT_PATH=$DOT_PATH" 1>&2
    echo "$0: debug[3]: DOT_PATH_CONTENT=$DOT_PATH_CONTENT" 1>&2
    echo "$0: debug[3]: ENTRY_JSON=$ENTRY_JSON" 1>&2
    echo "$0: debug[3]: GITIGNORE=$GITIGNORE" 1>&2
fi


# If -N, time to exit
#
if [[ -n $DO_NOT_PROCESS ]]; then
    if [[ $V_FLAG -ge 1 ]]; then
	echo "$0: debug[1]: arguments parsed, -N given, exit 0" 1>&2
    fi
    exit 0
fi


# create a temporary markdown for pandoc to process
#
export TMP_FILE="$ENTRY_PATH/.tmp.$NAME.FILE.$$.tmp"
if [[ $V_FLAG -ge 3 ]]; then
    echo  "$0: debug[3]: temporary markdown file: $TMP_FILE" 1>&2
fi
if [[ -z $NOOP ]]; then
    trap 'rm -f $TMP_FILE; exit' 0 1 2 3 15
    rm -f "$TMP_FILE"
    if [[ -e $TMP_FILE ]]; then
	echo "$0: ERROR: cannot remove temporary markdown file: $TMP_FILE" 1>&2
	exit 10
    fi
    :> "$TMP_FILE"
    if [[ ! -e $TMP_FILE ]]; then
	echo "$0: ERROR: cannot create temporary markdown file: $TMP_FILE" 1>&2
	exit 11
    fi
elif [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: because of -n, temporary markdown file is not used: $TMP_FILE" 1>&2
fi


# convert temporary markdown file into HTML
#
if [[ -z $NOOP ]]; then
    if [[ $V_FLAG -ge 3 ]]; then
	echo  "$0: debug[3]: about to execute: $SGI_TOOL < $GITIGNORE > $TMP_FILE" 1>&2
    fi
    "$SGI_TOOL" < "$GITIGNORE" > "$TMP_FILE"
    status="$?"
    if [[ $status -ne 0 ]]; then
	echo "$0: ERROR: sgi.sh failed, error: $status" 1>&2
	exit 12
    fi
    if cmp -s "$TMP_FILE" "$GITIGNORE"; then
	if [[ $V_FLAG -ge 3 ]]; then
	    echo  "$0: debug[3]: $GITIGNORE is already sorted" 1>&2
	fi
    else
	if [[ $V_FLAG -ge 1 ]]; then
	    echo  "$0: debug[1]: about to execute: mv -f $TMP_FILE $GITIGNORE" 1>&2
	fi
	mv -f "$TMP_FILE" "$GITIGNORE"
	status="$?"
	if [[ $status -ne 0 ]]; then
	    echo "$0: ERROR: sgi.sh failed, error: $status" 1>&2
	    exit 13
	fi
    fi
elif [[ $V_FLAG -ge 1 ]]; then
    echo  "$0: debug[1]: -n disabled execution of: $SGI_TOOL < $GITIGNORE > $TMP_FILE" 1>&2
    echo  "$0: debug[1]: -n disabled execution of:  mv -f $TMP_FILE $GITIGNORE" 1>&2
fi


# All Done!!! All Done!!! -- Jessica Noll, Age 2
#
if [[ -z $NOOP ]]; then
    rm -f "$TMP_FILE"
elif [[ $V_FLAG -ge 1 ]]; then
    echo  "$0: debug[1]: -n disabled execution of: rm -f $TMP_FILE" 1>&2
fi
exit 0
