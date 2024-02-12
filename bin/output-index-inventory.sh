#!/usr/bin/env bash
#
# output-index-inventory.sh - output the inventory in HTML form for an entry's index.html page
#
# This tool is intended to be used as a "before tool" during HTML phase number 22.
#
# This tool is intended to be invoked by a tool such as "readme2index.sh".
# The final arg will be in YYYY/dir form, and will be called from
# the topdir directory under which the YYYY/dir entry directory must be found.
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
# We must declare arrays with -ag or -Ag, and we need loops to "export" modified variables.
#
if [[ -z ${BASH_VERSINFO[0]} || ${BASH_VERSINFO[0]} -lt 4 || ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -lt 2 ]]; then
    echo "$0: ERROR: bash version must be >= 4.2: $BASH_VERSION" 1>&2
    exit 4
fi

# setup bash file matching
#
# Requires bash with a version 4.2 or later
#
shopt -s nullglob	# enable expand to nothing rather than remaining unexpanded
shopt -u failglob	# disable error message if no matches are found
shopt -u dotglob	# disable matching files starting with '.'
shopt -s globskipdots	# enable never matching '.' or '..'
shopt -u nocaseglob	# disable strict case matching
shopt -u extglob	# enable extended globbing patterns
shopt -s globstar	# enable '**' to match all files and zero or more directories and subdirectories

# set variables referenced in the usage message
#
export VERSION="1.1 2024-02-11"
NAME=$(basename "$0")
export NAME
export V_FLAG=0
GIT_TOOL=$(type -P git)
export GIT_TOOL
if [[ -z "$GIT_TOOL" ]]; then
    echo "$0: FATAL: git tool is not installed or is not in PATH" 1>&2
    exit 210
fi
"$GIT_TOOL" rev-parse --is-inside-work-tree >/dev/null 2>&1
status="$?"
if [[ $status -eq 0 ]]; then
    TOPDIR=$("$GIT_TOOL" rev-parse --show-toplevel)
fi
export PANDOC_WRAPPER="bin/pandoc-wrapper.sh"
export DOCROOT_SLASH="../../"
export REPO_URL="https://github.com/ioccc-src/temp-test-ioccc"
export SITE_URL="https://ioccc-src.github.io/temp-test-ioccc"
export URL="#"

# set usage message
#
export USAGE="usage: $0 [-h] [-v level] [-V] [-d topdir] [-D docroot/] [-n] [-N]
			[-p tool] [-u repo_url] [-U url] [-w site_url] [-e string ..] [-E exitcode]
			YYYY/dir

	-h		print help message and exit
	-v level	set verbosity level (def level: 0)
	-V		print version string and exit

	-d topdir	set topdir (def: $TOPDIR)
	-D docroot/	set the document root path followed by slash (def: $DOCROOT_SLASH)
			NOTE: 'docroot' must end in a slash

	-n		go thru the actions, but do not update any files (def: do the action)
	-N		do not process file, just parse arguments and ignore the file (def: process the file)

	-p tool		run 'pandoc wrapper tool' (not pandoc path) during HTML phase number 21 (def: use $PANDOC_WRAPPER)

	-u repo_url	Base level URL of target git repo (def: $REPO_URL)
	-U url		URL of HTML file being formed (def: $URL)
	-w site_url	Base URL of the web site (def: $SITE_URL)

	-e string	output string, followed by newline, to stderr (def: do not)
	-E exitcode	force exit with exitcode (def: exit based on success or failure of the action)

	YYYY/dir	path from topdir to entry directory: must contain the files: README.md, .path and .entry.json

Exit codes:
     0         all OK
     1	       pandoc exited non-zero
     2         -h and help string printed or -V and version string printed
     3         command line error
     4         bash version is < 4.2
     5	       YYYY/dir is not a entry directory
     6         pandoc tool not found or not executable
 >= 10  < 210  ((not used))
 >= 210	       internal tool error

$NAME version: $VERSION"

# setup
#
export NOOP=
export DO_NOT_PROCESS=

# parse command line
#
while getopts :hv:Vd:D:nNp:u:U:w:e:E: flag; do
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
    D) # parse -D docroot/
	case "$OPTARG" in
	*/) ;;
	*) echo "$0: ERROR: in -D docroot/, the docroot must end in /" 1>&2
	   echo 1>&2
	   echo "$USAGE" 1>&2
	   exit 3
	   ;;
	esac
	DOCROOT_SLASH="$OPTARG"
	;;
    n) NOOP="-n"
	;;
    N) DO_NOT_PROCESS="-N"
	;;
    p) PANDOC_WRAPPER="$OPTARG"
	;;
    u) REPO_URL="$OPTARG"
	;;
    U) URL="$OPTARG"
	;;
    w) SITE_URL="$OPTARG"
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
export ENTRY_PATH="$1"
if [[ $V_FLAG -ge 1 ]]; then
    echo "$0: debug[1]: ENTRY_PATH=$ENTRY_PATH" 1>&2
fi

# verify that we have a topdir directory
#
REPO_NAME=$(basename "$REPO_URL")
export REPO_NAME
if [[ -z $TOPDIR ]]; then
    echo "$0: ERROR: cannot find top of git repo directory" 1>&2
    echo "$0: Notice: if needed: $GIT_TOOL clone $REPO_URL; cd $REPO_NAME" 1>&2
    exit 211
fi
if [[ ! -e $TOPDIR ]]; then
    echo "$0: ERROR: TOPDIR does not exist: $TOPDIR" 1>&2
    echo "$0: Notice: if needed: $GIT_TOOL clone $REPO_URL; cd $REPO_NAME" 1>&2
    exit 212
fi
if [[ ! -d $TOPDIR ]]; then
    echo "$0: ERROR: TOPDIR is not a directory: $TOPDIR" 1>&2
    echo "$0: Notice: if needed: $GIT_TOOL clone $REPO_URL; cd $REPO_NAME" 1>&2
    exit 213
fi

# verify that we have an author subdirectory
#
export AUTHOR_PATH="$TOPDIR/author"
if [[ ! -d $AUTHOR_PATH ]]; then
    echo "$0: ERROR: author is not a directory under topdir: $AUTHOR_PATH" 1>&2
    exit 214
fi
export AUTHOR_DIR="author"

# verify that we have an inc subdirectory
#
export INC_PATH="$TOPDIR/inc"
if [[ ! -d $INC_PATH ]]; then
    echo "$0: ERROR: inc is not a directory under topdir: $INC_PATH" 1>&2
    exit 215
fi
export INC_DIR="inc"

# verify that we have a bin subdirectory
#
export BIN_PATH="$TOPDIR/bin"
if [[ ! -d $BIN_PATH ]]; then
    echo "$0: ERROR: bin is not a directory under topdir: $BIN_PATH" 1>&2
    exit 216
fi
export BIN_DIR="bin"

# cd to topdir
#
if [[ ! -e $TOPDIR ]]; then
    echo "$0: ERROR: cannot cd to non-existent path: $TOPDIR" 1>&2
    exit 217
fi
if [[ ! -d $TOPDIR ]]; then
    echo "$0: ERROR: cannot cd to a non-directory: $TOPDIR" 1>&2
    exit 218
fi
export CD_FAILED
if [[ $V_FLAG -ge 5 ]]; then
    echo "$0: debug[5]: about to: cd $TOPDIR" 1>&2
fi
cd "$TOPDIR" || CD_FAILED="true"
if [[ -n $CD_FAILED ]]; then
    echo "$0: ERROR: cd $TOPDIR failed" 1>&2
    exit 219
fi
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: now in directory: $(/bin/pwd)" 1>&2
fi

# verify that ENTRY_PATH is a entry directory
#
# ENTRY_PATH must be in YYYY/dir form
# YYYY must be a directory
# YYYY must be a writable directory
# YYYY/.year must be a non-empty file
# YYYY/dir must be a directory
# YYYY/dir/.path must be a non-empty file
# ENTRY_PATH must match the contents of YYYY/dir/.path
# YYYY/dir/.entry.json must be a non-empty file
#
if [[ ! -d $ENTRY_PATH ]]; then
    echo "$0: ERROR: arg is not a directory: $ENTRY_PATH" 1>&2
    exit 5
fi
if [[ ! -w $ENTRY_PATH ]]; then
    echo "$0: ERROR: arg is not a writable directory: $ENTRY_PATH" 1>&2
    exit 5
fi
export YEAR_DIR=${ENTRY_PATH%%/*}
if [[ -z $YEAR_DIR ]]; then
    echo "$0: ERROR: arg not in YYYY/dir form: $ENTRY_PATH" 1>&2
    exit 5
fi
export ENTRY_DIR=${ENTRY_PATH#*/}
if [[ -z $ENTRY_DIR ]]; then
    echo "$0: ERROR: arg: $ENTRY_PATH not in $YEAR_DIR/dir form: $ENTRY_PATH" 1>&2
    exit 5
fi
if [[ $ENTRY_DIR = */* ]]; then
    echo "$0: ERROR: dir from arg: $ENTRY_PATH contains a /: $ENTRY_DIR" 1>&2
    exit 5
fi
if [[ ! -d $YEAR_DIR ]]; then
    echo "$0: ERROR: YYYY from arg: $ENTRY_PATH is not a directory: $YEAR_DIR" 1>&2
    exit 5
fi
export ENTRY_ID="${YEAR_DIR}_${ENTRY_DIR}"
export DOT_YEAR="$YEAR_DIR/.year"
if [[ ! -s $DOT_YEAR ]]; then
    echo "$0: ERROR: not a non-empty file: $DOT_YEAR" 1>&2
    exit 5
fi
# Now that we have moved to topdir, form and verify YYYY_DIR is a writable directory
export YYYY_DIR="$YEAR_DIR/$ENTRY_DIR"
if [[ ! -e $YYYY_DIR ]]; then
    echo "$0: ERROR: YYYY/dir from arg: $ENTRY_PATH does not exist: $YYYY_DIR" 1>&2
    exit 5
fi
if [[ ! -d $YYYY_DIR ]]; then
    echo "$0: ERROR: YYYY/dir from arg: $ENTRY_PATH is not a directory: $YYYY_DIR" 1>&2
    exit 5
fi
if [[ ! -w $YYYY_DIR ]]; then
    echo "$0: ERROR: YYYY/dir from arg: $ENTRY_PATH is not a writable directory: $YYYY_DIR" 1>&2
    exit 5
fi
if [[ ! -d $YYYY_DIR ]]; then
    echo "$0: ERROR: YYYY/dir from arg: $ENTRY_PATH is not a directory: $YYYY_DIR" 1>&2
    exit 5
fi
export DOT_PATH="$YYYY_DIR/.path"
if [[ ! -s $DOT_PATH ]]; then
    echo "$0: ERROR: not a non-empty file: $DOT_PATH" 1>&2
    exit 5
fi
DOT_PATH_CONTENT=$(< "$DOT_PATH")
if [[ $ENTRY_PATH != "$DOT_PATH_CONTENT" ]]; then
    echo "$0: ERROR: arg: $ENTRY_PATH does not match $DOT_PATH contents: $DOT_PATH_CONTENT" 1>&2
    exit 5
fi
export ENTRY_JSON="$YYYY_DIR/.entry.json"
if [[ ! -e $ENTRY_JSON ]]; then
    echo "$0: ERROR: .entry.json does not exist: $ENTRY_JSON" 1>&2
    exit 5
fi
if [[ ! -f $ENTRY_JSON ]]; then
    echo "$0: ERROR: .entry.json is not a regular file: $ENTRY_JSON" 1>&2
    exit 5
fi
if [[ ! -r $ENTRY_JSON ]]; then
    echo "$0: ERROR: .entry.json is not a readable file: $ENTRY_JSON" 1>&2
    exit 5
fi
if [[ ! -e $PANDOC_WRAPPER ]]; then
    echo "$0: ERROR: pandoc wrapper tool does not exist: $PANDOC_WRAPPER" 1>&2
    exit 6
fi
if [[ ! -f $PANDOC_WRAPPER ]]; then
    echo "$0: ERROR: pandoc wrapper tool is not a regular file: $PANDOC_WRAPPER" 1>&2
    exit 6
fi
if [[ ! -x $PANDOC_WRAPPER ]]; then
    echo "$0: ERROR: pandoc wrapper tool is not an executable file: $PANDOC_WRAPPER" 1>&2
    exit 6
fi

# verify we have our awk script
#
export MANIFEST_ENTRY_JSON_AWK="$BIN_DIR/manifest.entry.json.awk"
if [[ ! -e $MANIFEST_ENTRY_JSON_AWK ]]; then
    echo "$0: ERROR: bin/manifest.entry.json.awk does not exist: $MANIFEST_ENTRY_JSON_AWK" 1>&2
    exit 6
fi
if [[ ! -f $MANIFEST_ENTRY_JSON_AWK ]]; then
    echo "$0: ERROR: bin/manifest.entry.json.awk is not a regular file: $MANIFEST_ENTRY_JSON_AWK" 1>&2
    exit 6
fi
if [[ ! -r $MANIFEST_ENTRY_JSON_AWK ]]; then
    echo "$0: ERROR: bin/manifest.entry.json.awk is not a readable file: $MANIFEST_ENTRY_JSON_AWK" 1>&2
    exit 6
fi

# parameter debugging
#
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: NAME=$NAME" 1>&2
    echo "$0: debug[3]: YEAR_DIR=$YEAR_DIR" 1>&2
    echo "$0: debug[3]: ENTRY_DIR=$ENTRY_DIR" 1>&2
    echo "$0: debug[3]: ENTRY_ID=$ENTRY_ID" 1>&2
    echo "$0: debug[3]: DOT_YEAR=$DOT_YEAR" 1>&2
    echo "$0: debug[3]: DOT_PATH=$DOT_PATH" 1>&2
    echo "$0: debug[3]: ENTRY_JSON=$ENTRY_JSON" 1>&2
    echo "$0: debug[3]: DOCROOT_SLASH=$DOCROOT_SLASH" 1>&2
    echo "$0: debug[3]: REPO_URL=$REPO_URL" 1>&2
    echo "$0: debug[3]: REPO_NAME=$REPO_NAME" 1>&2
    echo "$0: debug[3]: URL=$URL" 1>&2
    echo "$0: debug[3]: SITE_URL=$SITE_URL" 1>&2
    echo "$0: debug[3]: AUTHOR_PATH=$AUTHOR_PATH" 1>&2
    echo "$0: debug[3]: AUTHOR_DIR=$AUTHOR_DIR" 1>&2
    echo "$0: debug[3]: INC_PATH=$INC_PATH" 1>&2
    echo "$0: debug[3]: INC_DIR=$INC_DIR" 1>&2
    echo "$0: debug[3]: BIN_PATH=$BIN_PATH" 1>&2
    echo "$0: debug[3]: BIN_DIR=$BIN_DIR" 1>&2
    echo "$0: debug[3]: PANDOC_WRAPPER=$PANDOC_WRAPPER" 1>&2
    echo "$0: debug[3]: MANIFEST_ENTRY_JSON_AWK=$MANIFEST_ENTRY_JSON_AWK" 1>&2
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

# create a temporary markdown for pandoc to process
#
TMP_FILE=".$NAME.$$.md"
if [[ $V_FLAG -ge 3 ]]; then
    echo  "$0: debug[3]: temporary markdown file: $TMP_FILE" 1>&2
fi
if [[ -z $NOOP ]]; then
    trap 'rm -f $TMP_FILE; exit' 0 1 2 3 15
    rm -f "$TMP_FILE"
    if [[ -e $TMP_FILE ]]; then
	echo "$0: ERROR: cannot remove temporary markdown file: $TMP_FILE" 1>&2
	exit 220
    fi
    :> "$TMP_FILE"
    if [[ ! -e $TMP_FILE ]]; then
	echo "$0: ERROR: cannot create temporary markdown file: $TMP_FILE" 1>&2
	exit 221
    fi
elif [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: because of -n, temporary markdown file is not used: $TMP_FILE" 1>&2
fi

# create a temporary manifest file
#
TMP_MANIFEST=".$NAME.$$.manifest"
if [[ $V_FLAG -ge 3 ]]; then
    echo  "$0: debug[3]: temporary manifest file: $TMP_MANIFEST" 1>&2
fi
if [[ -z $NOOP ]]; then
    trap 'rm -f $TMP_FILE $TMP_MANIFEST; exit' 0 1 2 3 15
    rm -f "$TMP_MANIFEST"
    if [[ -e $TMP_MANIFEST ]]; then
	echo "$0: ERROR: cannot remove temporary manifest file: $TMP_MANIFEST" 1>&2
	exit 222
    fi
    :> "$TMP_MANIFEST"
    if [[ ! -e $TMP_MANIFEST ]]; then
	echo "$0: ERROR: cannot create temporary manifest file: $TMP_MANIFEST" 1>&2
	exit 223
    fi
elif [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: because of -n, temporary manifest file is not used: $TMP_MANIFEST" 1>&2
fi

# generate the temporary manifest file
#
if [[ -z $NOOP ]]; then
    awk -v github="$REPO_URL" -f "$MANIFEST_ENTRY_JSON_AWK" "$ENTRY_JSON" > "$TMP_MANIFEST"
    status="$?"
    if [[ $status -ne 0 ]]; then
	echo "$0: ERROR: manifest.entry.json.awk failed, error: $status" 1>&2
	exit 224
    fi
    {
	# load numerically sorted inventory_order lines into the temporary markdown file
	#
	# Any inventory_order that is 1 to 9 decimal digits is considered a primary file.
	# Any inventory_order that is 10 or more decimal digits is considered a secondary file.
	#
	echo '# <a name="inventory"></a>Inventory for' "$YYYY_DIR"
	echo
	echo '## Primary files'
	echo
	grep -E '^[0-9][0-9]{0,8} ' "$TMP_MANIFEST" | sort -n | sed -e 's/^[0-9][0-9]* //'
	echo
	echo '## Secondary files'
	echo
	grep -E '^[1-9][0-9]{9,} ' "$TMP_MANIFEST" | sort -n | sed -e 's/^[0-9][0-9]* //'

    } >> "$TMP_FILE"
elif [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: because of -n, temporary manifest markdown is NOT written into: $TMP_FILE" 1>&2
fi

# convert temporary markdown file into HTML
#
if [[ -z $NOOP ]]; then
    echo "<!-- START: this line starts content generated by: bin/$NAME -->"
    echo
    if [[ $V_FLAG -ge 1 ]]; then
	echo  "$0: debug[1]: about to execute: $PANDOC_WRAPPER $TMP_FILE -" 1>&2
    fi
    "$PANDOC_WRAPPER" "$TMP_FILE" -
    status="$?"
    if [[ $status -ne 0 ]]; then
	echo "$0: ERROR: pandoc failed, error: $status" 1>&2
	exit 225
    fi
    echo
    echo "<!-- END: next line ends content generated by: bin/$NAME -->"
elif [[ $V_FLAG -ge 1 ]]; then
    echo  "$0: debug[1]: -n disabled execution of: $PANDOC_WRAPPER $TMP_FILE -" 1>&2
fi

# All Done!!! -- Jessica Noll, Age 2
#
if [[ -z $NOOP ]]; then
    rm -f "$TMP_FILE" "$TMP_MANIFEST"
elif [[ $V_FLAG -ge 1 ]]; then
    echo  "$0: debug[1]: -n disabled execution of: rm -f $TMP_FILE $TMP_MANIFEST" 1>&2
fi
exit 0
