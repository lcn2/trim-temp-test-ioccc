#!/usr/bin/env bash
#
# subst.winner-index.sh - print substitutions for a winner index.html
#
# This tool is used in conjunction with the inc/md2html.cfg configuration
# file, and "readme2index.sh" to build an index.html file for a winner.
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

# firewall - must be bash with a version 4.2 or later
#
# We must declare arrays with -ag or -Ag
#
if [[ -z ${BASH_VERSINFO[0]} || ${BASH_VERSINFO[0]} -lt 4 || ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -lt 2 ]]; then
    echo "$0: ERROR: bash version must be >= 4.2: $BASH_VERSION" 1>&2
    exit 4
fi

# setup bash file matching
#
# Requires bash with a version 4.2 or later
#
shopt -s nullglob	# enable expanded to nothing rather than remaining unexpanded
shopt -u failglob	# disable error message if no matches are found
shopt -u dotglob	# disable matching files starting with .
shopt -s globskipdots	# enable never matching . nor ..
shopt -u nocaseglob	# disable strict case matching
shopt -u extglob	# enable extended globbing patterns
shopt -s globstar	# enable ** to match all files and zero or more directories and subdirectories

# set variables referenced in the usage message
#
export VERSION="1.0 2024-01-02"
NAME=$(basename "$0")
export NAME
export V_FLAG=0
GIT_TOOL=$(type -P git)
export GIT_TOOL
if [[ -z "$GIT_TOOL" ]]; then
    echo "$0: FATAL: git tool is not installed or not in PATH" 1>&2
    exit 200
fi
"$GIT_TOOL" rev-parse --is-inside-work-tree >/dev/null 2>&1
status="$?"
if [[ $status -eq 0 ]]; then
    TOPDIR=$("$GIT_TOOL" rev-parse --show-toplevel)
fi

# set usage message
#
export USAGE="usage: $0 [-h] [-v level] [-V] [-n] [-N]
			[-d topdir] [-p tool] [-P optstr]
			[-e string ..] [-E exitcode]
			yyyy/dir

	-h		print help message and exit
	-v level	set verbosity level (def level: 0)
	-V		print version string and exit

	-d topdir	set topdir (def: $TOPDIR)

	-n		go thru the actions, but do not update any files (def: do the action)
	-N		do not process file, just parse arguments and ignore the file (def: process the file)

	-e string	output string, followed by newline, to stderr (def: do not)
	-E exitcode	force exit with exitcode (def: exit based on success or failure of the action)

	yyyy/dir	path from topdir to winner directory: must contain the files: README.md, .path and .winner.json

Exit codes:
     0         all OK
     1	       pandoc exited non-zero
     2         -h and help string printed or -V and version string printed
     3         command line error
     4         bash version is < 4.2
     5	       yyyy/dir is not a winner directory
 >= 10 < 200   ((not used))
 >= 200	       internal error

$NAME version: $VERSION"

# setup
#
export NOOP=
export DO_NOT_PROCESS=
export DOCROOT_URL_SLASH="/"

# parse command line
#
while getopts :hv:Vd:nNe:E: flag; do
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
    e) echo "$OPTARG" 1>&2
	;;
    E) exit "$OPTARG"
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

# parse the command line arguments
#
if [[ $V_FLAG -ge 1 ]]; then
    echo "$0: debug[1]: debug level: $V_FLAG" 1>&2
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
export WINNER_PATH="$1"
if [[ $V_FLAG -ge 1 ]]; then
    echo "$0: debug[1]: WINNER_PATH=$WINNER_PATH" 1>&2
fi

# verify that we have an author subdirectory
#
export AUTHOR_PATH="$TOPDIR/author"
if [[ ! -d $AUTHOR_PATH ]]; then
    echo "$0: ERROR: author is not a directory under topdir: $AUTHOR_PATH" 1>&2
    exit 203
fi
export AUTHOR_DIR="author"

# cd to topdir
#
if [[ ! -e $TOPDIR ]]; then
    echo "$0: ERROR: cannot cd to non-existent path: $TOPDIR" 1>&2
    exit 204
fi
if [[ ! -d $TOPDIR ]]; then
    echo "$0: ERROR: cannot cd to a non-directory: $TOPDIR" 1>&2
    exit 205
fi
export CD_FAILED
if [[ $V_FLAG -ge 5 ]]; then
    echo "$0: debug[5]: about to: cd $TOPDIR" 1>&2
fi
cd "$TOPDIR" || CD_FAILED="true"
if [[ -n $CD_FAILED ]]; then
    echo "$0: ERROR: cd $TOPDIR failed" 1>&2
    exit 206
fi
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: now in directory: $(/bin/pwd)" 1>&2
fi

# verify that WINNER_PATH is a winner directory
#
# WINNER_PATH must be in yyyy/dir form
# yyyy must be a directory
# yyyy must be a writable directory
# yyyy/.year must be a non-empty file
# yyyy/dir must be a directory
# yyyy/dir/.path must be a non-empty file
# WINNER_PATH must match the contents of yyyy/dir/.path
# yyyy/dir/.winner.json must be a non-empty file
#
if [[ ! -d $WINNER_PATH ]]; then
    echo "$0: ERROR: arg is not a directory: $WINNER_PATH" 1>&2
    exit 5
fi
if [[ ! -w $WINNER_PATH ]]; then
    echo "$0: ERROR: arg is not a writable directory: $WINNER_PATH" 1>&2
    exit 5
fi
export YEAR_DIR=${WINNER_PATH%%/*}
if [[ -z $YEAR_DIR ]]; then
    echo "$0: ERROR: arg not in yyyy/dir form: $WINNER_PATH" 1>&2
    exit 5
fi
export WINNER_DIR=${WINNER_PATH#*/}
if [[ -z $WINNER_DIR ]]; then
    echo "$0: ERROR: arg: $WINNER_PATH not in $YEAR_DIR/dir form: $WINNER_PATH" 1>&2
    exit 5
fi
if [[ $WINNER_DIR = */* ]]; then
    echo "$0: ERROR: dir from arg: $WINNER_PATH contains a /: $WINNER_DIR" 1>&2
    exit 5
fi
if [[ ! -d $YEAR_DIR ]]; then
    echo "$0: ERROR: yyyy from arg: $WINNER_PATH is not a directory: $YEAR_DIR" 1>&2
    exit 5
fi
export WINNER_ID="${YEAR_DIR}_${WINNER_DIR}"
export DOT_YEAR="$YEAR_DIR/.year"
if [[ ! -s $DOT_YEAR ]]; then
    echo "$0: ERROR: not a non-empty file: $DOT_YEAR" 1>&2
    exit 5
fi
if [[ ! -d $YEAR_DIR/$WINNER_DIR ]]; then
    echo "$0: ERROR: yyyy/dir from arg: $WINNER_PATH is not a directory: $YEAR_DIR/$WINNER_DIR" 1>&2
    exit 5
fi
export DOT_PATH="$YEAR_DIR/$WINNER_DIR/.path"
if [[ ! -s $DOT_PATH ]]; then
    echo "$0: ERROR: not a non-empty file: $DOT_PATH" 1>&2
    exit 5
fi
DOT_PATH_CONTENT=$(< "$DOT_PATH")
if [[ $WINNER_PATH != "$DOT_PATH_CONTENT" ]]; then
    echo "$0: ERROR: arg: $WINNER_PATH does not match $DOT_PATH contents: $DOT_PATH_CONTENT" 1>&2
    exit 5
fi
export WINNER_JSON="$YEAR_DIR/$WINNER_DIR/.winner.json"
if [[ ! -e $WINNER_JSON ]]; then
    echo "$0: ERROR: .winner.json does not exist: $WINNER_JSON" 1>&2
    exit 5
fi
if [[ ! -f $WINNER_JSON ]]; then
    echo "$0: ERROR: .winner.json is not a file: $WINNER_JSON" 1>&2
    exit 5
fi
if [[ ! -r $WINNER_JSON ]]; then
    echo "$0: ERROR: .winner.json is not a readable file: $WINNER_JSON" 1>&2
    exit 5
fi

# parameter debugging
#
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: NAME=$NAME" 1>&2
    echo "$0: debug[3]: YEAR_DIR=$YEAR_DIR" 1>&2
    echo "$0: debug[3]: WINNER_DIR=$WINNER_DIR" 1>&2
    echo "$0: debug[3]: WINNER_ID=$WINNER_ID" 1>&2
    echo "$0: debug[3]: DOT_YEAR=$DOT_YEAR" 1>&2
    echo "$0: debug[3]: DOT_PATH=$DOT_PATH" 1>&2
    echo "$0: debug[3]: WINNER_JSON=$WINNER_JSON" 1>&2
    echo "$0: debug[3]: AUTHOR_PATH=$AUTHOR_PATH" 1>&2
    echo "$0: debug[3]: AUTHOR_DIR=$AUTHOR_DIR" 1>&2
    echo "$0: debug[3]: DO_NOT_PROCESS=$DO_NOT_PROCESS" 1>&2
    echo "$0: debug[3]: NOOP=$NOOP" 1>&2
fi

# If -N, time to exit
#
if [[ -n $DO_NOT_PROCESS ]]; then
    if [[ $V_FLAG -ge 1 ]]; then
	echo "$0: debug[1]: arguments parsed, -N given, exit 0" 1>&2
    fi
    exit 0
fi

# output TITLE substitution
#
echo "-s TITIE='$YEAR_DIR/$WINNER_DIR'"

# output DESCRIPTION substitution
#
echo "-s DESCRIPTION='$YEAR_DIR IOCCC winner $WINNER_DIR'"

# output KEYWORDS substitution
#
echo "-s KEYWORDS='IOCCC, $YEAR_DIR, IOCCC $YEAR_DIR, IOCCC winner, $WINNER_DIR'"

# output HEADER_2 substitution
#
echo "-s HEADER_2='$YEAR_DIR/$WINNER_DIR'"

# All Done!!! -- Jessica Noll, Age 2
#
exit 0
