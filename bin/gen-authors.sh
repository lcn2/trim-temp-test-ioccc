#!/usr/bin/env bash
#
# gen-authors.sh - create the top level authors.html page
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
shopt -s nullglob	# enable expanded to nothing rather than remaining unexpanded
shopt -u failglob	# disable error message if no matches are found
shopt -u dotglob	# disable matching files starting with .
shopt -s globskipdots	# enable never matching . nor ..
shopt -u nocaseglob	# disable strict case matching
shopt -u extglob	# enable extended globbing patterns
shopt -s globstar	# enable ** to match all files and zero or more directories and subdirectories

# set variables referenced in the usage message
#
export VERSION="1.3 2024-03-04"
NAME=$(basename "$0")
export NAME
export V_FLAG=0
GIT_TOOL=$(type -P git)
export GIT_TOOL
if [[ -z "$GIT_TOOL" ]]; then
    echo "$0: FATAL: git tool is not installed or not in \$PATH" 1>&2
    exit 5
fi
"$GIT_TOOL" rev-parse --is-inside-work-tree >/dev/null 2>&1
status="$?"
if [[ $status -eq 0 ]]; then
    TOPDIR=$("$GIT_TOOL" rev-parse --show-toplevel)
fi
export TOPDIR
export DOCROOT_SLASH="./"
export TAGLINE="bin/$NAME"
export MD2HTML_SH="bin/md2html.sh"
export PANDOC_WRAPPER="bin/pandoc-wrapper.sh"
export REPO_URL="https://github.com/ioccc-src/temp-test-ioccc"
export SITE_URL="https://ioccc-src.github.io/temp-test-ioccc"
#
export NOOP=
export DO_NOT_PROCESS=
export EXIT_CODE="0"

# Letter "is for" text
#
unset IS_FOR
declare -Ag IS_FOR
IS_FOR[A]="A is for atoi"
IS_FOR[B]="B is for break"
IS_FOR[C]="C is for const"
IS_FOR[D]="D is for do"
IS_FOR[E]="E is for else"
IS_FOR[F]="F is for float"
IS_FOR[G]="G is for getc"
IS_FOR[H]="H is for hypot"
IS_FOR[I]="I is for int"
IS_FOR[J]="J is for jmp_buf"
IS_FOR[K]="K is for killchar"
IS_FOR[L]="L is for long"
IS_FOR[M]="M is for malloc"
IS_FOR[N]="N is for nullptr"
IS_FOR[O]="O is for open"
IS_FOR[P]="P is for printf"
IS_FOR[Q]="Q is for qsort"
IS_FOR[R]="R is for return"
IS_FOR[S]="S is for switch"
IS_FOR[T]="T is for true"
IS_FOR[U]="U is for union"
IS_FOR[V]="V is for volatile"
IS_FOR[W]="W is for while"
IS_FOR[X]="X is for xor"
IS_FOR[Y]="Y is for y0"
IS_FOR[Z]="Z is for zlib"

# clear options we will add to tools
#
unset TOOL_OPTION
declare -ag TOOL_OPTION

# usage
#
export USAGE="usage: $0 [-h] [-v level] [-V] [-d topdir] [-D docroot/] [-n] [-N]
			[-t tagline] [-T md2html.sh] [-p tool] [-u repo_url]

	-h		print help message and exit
	-v level	set verbosity level (def level: 0)
	-V		print version string and exit

	-d topdir	set topdir (def: $TOPDIR)
			NOTE: The '-d topdir' is passed as leading options on tool command lines.
	-D docroot/	set the document root path followed by slash (def: $DOCROOT_SLASH)
			NOTE: The '-D docroot/' is passed as leading options on tool command lines.
			NOTE: 'docroot' must end in a slash

	-n		go thru the actions, but do not update any files (def: do the action)
			NOTE: -n is passed to tool
	-N		do not process anything, just parse arguments (def: process something)

	-t tagline	string to write about the tool that formed the markdown content (def: $TAGLINE)
			NOTE: 'tagline' may be enclosed within, but may NOT contain an internal single-quote, or double-quote.
	-T md2html.sh	run 'markdown to html tool' to convert markdown into HTML (def: $MD2HTML_SH)

	-p tool		run 'pandoc wrapper tool' (not pandoc path) during HTML phase number 21 (def: use $PANDOC_WRAPPER)
			NOTE: The '-p tool' is passed as leading options on tool command lines.

	-u repo_url	Base level URL of target git repo (def: $REPO_URL)
			NOTE: The '-u repo_url' is passed as leading options on tool command lines.
	-w site_url	Base URL of the web site (def: $SITE_URL)
			NOTE: The '-w site_url' is passed as leading options on tool command lines.

NOTE: The '-v level' is passed as initial command line options to the 'markdown to html tool' (md2html.sh).
      The 'tagline' is passed as '-t tagline' to the 'markdown to html tool' (md2html.sh), after the '-v level'.
      Any '-T md2html.sh', '-p tool', '-P pandoc_opts', '-u repo_url', '-U top_url'
      are passed to the 'markdown to html tool' (md2html.sh), and will be before any command line arguments.

Exit codes:
     0         all OK
     1	       some internal tool exited non-zero
     2         -h and help string printed or -V and version string printed
     3         command line error
     4         bash version is < 4.2
     5	       some internal tool is not found or not an executable file
     6	       problems found with or in the topdir or topdir/YYYY directory
     7	       problems found with or in the entry topdir/YYYY/dir directory
 >= 10         internal error

$NAME version: $VERSION"

# output_entry_ids
#
# Write the entry ids from an author/author_handle.json file to standard output (stdout)
#
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - until we have the jnamval command, we must FAKE PARSE the author/author_handle.json file - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
#
# usage:
#	output_entry_ids author/author_handle.json
#
# returns:
#	0 ==> no errors detected, but output may be empty
#     > 0 ==> function error number
#
function output_entry_ids
{
    local AUTHOR_HANDLE_JSON_PATH;	# the .entry.json path
    local entry_id;			# a found entry id

    # parse args
    #
    if [[ $# -ne 1 ]]; then
	echo "$0: ERROR: in output_entry_ids: expected 1 arg, found $#" 1>&2
	return 1
    fi
    AUTHOR_HANDLE_JSON_PATH="$1"
    if [[ ! -e $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_entry_ids: author_handle.json does not exist: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 2
    fi
    if [[ ! -f $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_entry_ids: author_handle.json is not a file: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 3
    fi
    if [[ ! -r $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_entry_ids: author_handle.json is not a readable file: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 4
    fi

    # extract entry ids from the author/author_handle.json file
    #
    grep -F entry_id "$AUTHOR_HANDLE_JSON_PATH" | awk 'NF == 5 { print $4; }' | tr -d '"'
    return 0
}

# output_author_handle
#
# Write the author handles from an author/author_handle.json file to standard output (stdout)
#
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - until we have the jnamval command, we must FAKE PARSE the author/author_handle.json file - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
#
# usage:
#	output_author_handle author/author_handle.json
#
# returns:
#	0 ==> no errors detected, but output may be empty
#     > 0 ==> function error number
#
function output_author_handle
{
    local AUTHOR_HANDLE_JSON_PATH;	# the .entry.json path

    # parse args
    #
    if [[ $# -ne 1 ]]; then
	echo "$0: ERROR: in output_author_handle: expected 1 arg, found $#" 1>&2
	return 1
    fi
    AUTHOR_HANDLE_JSON_PATH="$1"
    if [[ ! -e $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_author_handle: author_handle.json does not exist: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 2
    fi
    if [[ ! -f $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_author_handle: author_handle.json is not a file: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 3
    fi
    if [[ ! -r $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_author_handle: author_handle.json is not a readable file: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 4
    fi

    # extract entry ids from the author/author_handle.json file
    #
    grep -F author_handle "$AUTHOR_HANDLE_JSON_PATH" | sed -e 's/.*"author_handle" : "//' -e 's/",.*//'
    return 0
}

# output_full_name
#
# Write the Full Name from an author/author_handle.json file to standard output (stdout)
#
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - until we have the jnamval command, we must FAKE PARSE the author/author_handle.json file - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
#
# usage:
#	output_full_name author/author_handle.json
#
# returns:
#	0 ==> no errors detected, but output may be empty
#     > 0 ==> function error number
#
function output_full_name
{
    local AUTHOR_HANDLE_JSON_PATH;	# the .entry.json path

    # parse args
    #
    if [[ $# -ne 1 ]]; then
	echo "$0: ERROR: in output_full_name: expected 1 arg, found $#" 1>&2
	return 1
    fi
    AUTHOR_HANDLE_JSON_PATH="$1"
    if [[ ! -e $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_full_name: author_handle.json does not exist: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 2
    fi
    if [[ ! -f $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_full_name: author_handle.json is not a file: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 3
    fi
    if [[ ! -r $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_full_name: author_handle.json is not a readable file: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 4
    fi

    # extract Full Name from the author/author_handle.json file
    #
    grep -F full_name "$AUTHOR_HANDLE_JSON_PATH" | sed -e 's/.*"full_name" : "//' -e 's/",.*//'
    return 0
}

# output_location_code
#
# Write the Location Code from an author/author_handle.json file to standard output (stdout)
#
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - until we have the jnamval command, we must FAKE PARSE the author/author_handle.json file - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
#
# usage:
#	output_location_code author/author_handle.json
#
# returns:
#	0 ==> no errors detected, but output may be empty
#     > 0 ==> function error number
#
function output_location_code
{
    local AUTHOR_HANDLE_JSON_PATH;	# the .entry.json path

    # parse args
    #
    if [[ $# -ne 1 ]]; then
	echo "$0: ERROR: in output_location_code: expected 1 arg, found $#" 1>&2
	return 1
    fi
    AUTHOR_HANDLE_JSON_PATH="$1"
    if [[ ! -e $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_location_code: author_handle.json does not exist: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 2
    fi
    if [[ ! -f $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_location_code: author_handle.json is not a file: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 3
    fi
    if [[ ! -r $AUTHOR_HANDLE_JSON_PATH ]]; then
	echo "$0: ERROR: in output_location_code: author_handle.json is not a readable file: $AUTHOR_HANDLE_JSON_PATH" 1>&2
	return 4
    fi

    # extract Location Code from the author/author_handle.json file
    #
    grep -F location_code "$AUTHOR_HANDLE_JSON_PATH" | sed -e 's/.*"location_code" : "*//' -e 's/"*,.*//'
    return 0
}

# output_award
#
# Write the award name to standard output (stdout)
#
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - until we have the jnamval command, we must FAKE PARSE the .entry.json file  - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
#
# usage:
#       output_award YYYY/dir/.entry.json
#
# returns:
#       0 ==> no errors detected, but output may be empty
#     > 0 ==> function error number
#
function output_award
{
    local ENTRY_JSON_PATH;     # the .entry.json path

    # parse args
    #
    if [[ $# -ne 1 ]]; then
        echo "$0: ERROR: in output_award: expected 1 arg, found $#" 1>&2
        return 1
    fi
    ENTRY_JSON_PATH="$1"
    if [[ ! -e $ENTRY_JSON_PATH ]]; then
        echo "$0: ERROR: in output_award: .entry.json does not exist: $ENTRY_JSON_PATH" 1>&2
        return 2
    fi
    if [[ ! -f $ENTRY_JSON_PATH ]]; then
        echo "$0: ERROR: in output_award: .entry.json is not a file: $ENTRY_JSON_PATH" 1>&2
        return 3
    fi
    if [[ ! -r $ENTRY_JSON_PATH ]]; then
        echo "$0: ERROR: in output_award: .entry.json is not a readable file: $ENTRY_JSON_PATH" 1>&2
        return 4
    fi

    # obtain the award string
    #
    AWARD=$(grep -F '"award" : "'  "$ENTRY_JSON_PATH" | sed -e 's/^.*"award" : "//' -e 's/",//')
    if [[ -z $AWARD ]]; then
	echo "$0: ERROR: in output_award: no award found in .entry.json file: $ENTRY_JSON_PATH" 1>&2
	return 5
    fi
    echo "$AWARD"
    return 0
}

# parse command line
#
while getopts :hv:Vd:D:nNt:T:p:u:w: flag; do
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
	TOOL_OPTION+=("-d")
	TOOL_OPTION+=("$TOPDIR")
	;;
    D) # parse -D docroot/
	case "$OPTARG" in
	*/) ;;
	*) echo "$0: ERROR: in -D docroot/, the docroot must end in /" 1>&2
	   echo 1>&2
	   print_usage 1>&2
	   exit 3
	   ;;
	esac
	DOCROOT_SLASH="$OPTARG"
	# -D docroot/ always added after arg parsing
	;;
    n) NOOP="-n"
	;;
    N) DO_NOT_PROCESS="-N"
	;;
    t) # parse -t tagline
	case "$OPTARG" in
	*"'"*)
	    echo "$0: ERROR: in -t tagline, the tagline may not contain a single-quote character: $OPTARG" 1>&2
	    echo 1>&2
	    print_usage 1>&2
	    exit 3
	    ;;
	*'"'*)
	    echo "$0: ERROR: in -t tagline, the tagline may not contain a double-quote character: $OPTARG" 1>&2
	    echo 1>&2
	    print_usage 1>&2
	    exit 3
	    ;;
	*) ;;
	esac
	TAGLINE="$OPTARG"
	# -t tagline always added after arg parsing
	;;
    T) MD2HTML_SH="$OPTARG"
	TOOL_OPTION+=("-T")
	TOOL_OPTION+=("$MD2HTML_SH")
	;;
    p) PANDOC_WRAPPER="$OPTARG"
	TOOL_OPTION+=("-p")
	TOOL_OPTION+=("$PANDOC_WRAPPER")
	;;
    u) REPO_URL="$OPTARG"
	TOOL_OPTION+=("-u")
	TOOL_OPTION+=("$REPO_URL")
	;;
    w) SITE_URL="$OPTARG"
	TOOL_OPTION+=("-w")
	TOOL_OPTION+=("$SITE_URL")
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

# remove the options
#
shift $(( OPTIND - 1 ));
#
# verify arg count and parse args
#
if [[ $V_FLAG -ge 5 ]]; then
    echo "$0: debug[5]: file argument count: $#" 1>&2
fi
#
if [[ $# -ne 0 ]]; then
    echo "$0: ERROR: expected 0 args, found: $#" 1>&2
    exit 3
fi

# always add the '-v level' option, unless level is empty, to the set of options passed to the md2html.sh tool
#
if [[ -n $V_FLAG ]]; then
    TOOL_OPTION+=("-v")
    TOOL_OPTION+=("$V_FLAG")
fi

# always add the '-t tagline' option, unless tagline is empty, to the set of options passed to the md2html.sh tool
#
if [[ -n $TAGLINE ]]; then
    TOOL_OPTION+=("-t")
    TOOL_OPTION+=("$TAGLINE")
fi

# always add the '-U URL' for the top level authors.html file
#
TOOL_OPTION+=("-U")
TOOL_OPTION+=("$SITE_URL/authors.html")

# always add the '-D docroot/' for the top level authors.html file
#
TOOL_OPTION+=("-D")
TOOL_OPTION+=("$DOCROOT_SLASH")

# verify that we have a topdir directory
#
REPO_NAME=$(basename "$REPO_URL")
export REPO_NAME
if [[ -z $TOPDIR ]]; then
    echo "$0: ERROR: cannot find top of git repo directory" 1>&2
    echo "$0: Notice: if needed: $GIT_TOOL clone $REPO_URL; cd $REPO_NAME" 1>&2
    exit 6
fi
if [[ ! -e $TOPDIR ]]; then
    echo "$0: ERROR: TOPDIR does not exist: $TOPDIR" 1>&2
    echo "$0: Notice: if needed: $GIT_TOOL clone $REPO_URL; cd $REPO_NAME" 1>&2
    exit 6
fi
if [[ ! -d $TOPDIR ]]; then
    echo "$0: ERROR: TOPDIR is not a directory: $TOPDIR" 1>&2
    echo "$0: Notice: if needed: $GIT_TOOL clone $REPO_URL; cd $REPO_NAME" 1>&2
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

# verify that the md2html tool is executable
#
if [[ ! -e $MD2HTML_SH ]]; then
    echo  "$0: ERROR: md2html.sh does not exist: $MD2HTML_SH" 1>&2
    exit 5
fi
if [[ ! -f $MD2HTML_SH ]]; then
    echo  "$0: ERROR: md2html.sh is not a regular file: $MD2HTML_SH" 1>&2
    exit 5
fi
if [[ ! -x $MD2HTML_SH ]]; then
    echo  "$0: ERROR: md2html.sh is not an executable file: $MD2HTML_SH" 1>&2
    exit 5
fi

# verify that we have an author subdirectory
#
export AUTHOR_PATH="$TOPDIR/author"
if [[ ! -d $AUTHOR_PATH ]]; then
    echo "$0: ERROR: author is not a directory under topdir: $AUTHOR_PATH" 1>&2
    exit 6
fi
export AUTHOR_DIR="author"

# verify that we have an bin subdirectory
#
export BIN_PATH="$TOPDIR/bin"
if [[ ! -d $BIN_PATH ]]; then
    echo "$0: ERROR: bin is not a directory under topdir: $BIN_PATH" 1>&2
    exit 6
fi
export BIN_DIR="bin"

# find the location tool
#
LOCATION_TOOL=$(type -P location)
if [[ -z $LOCATION_TOOL ]]; then
    # guess we have a location tool in bin
    #
    LOCATION_TOOL="$BIN_DIR/location"
fi
if [[ ! -x $LOCATION_TOOL ]]; then
    echo "$0: ERROR: cannot find the location executable" 1>&2
    echo "$0: notice: location tool comes from this repo: https://github.com/ioccc-src/mkiocccentry" 1>&2
    exit 5
fi

# note authors.html file
#
export AUTHORS_HTML="authors.html"

# print running info if verbose
#
# If -v 3 or higher, print exported variables in order that they were exported.
#
if [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: VERSION=$VERSION" 1>&2
    echo "$0: debug[3]: NAME=$NAME" 1>&2
    echo "$0: debug[3]: V_FLAG=$V_FLAG" 1>&2
    echo "$0: debug[3]: GIT_TOOL=$GIT_TOOL" 1>&2
    echo "$0: debug[3]: TOPDIR=$TOPDIR" 1>&2
    echo "$0: debug[3]: DOCROOT_SLASH=$DOCROOT_SLASH" 1>&2
    echo "$0: debug[3]: TAGLINE=$TAGLINE" 1>&2
    echo "$0: debug[3]: MD2HTML_SH=$MD2HTML_SH" 1>&2
    echo "$0: debug[3]: PANDOC_WRAPPER=$PANDOC_WRAPPER" 1>&2
    echo "$0: debug[3]: REPO_URL=$REPO_URL" 1>&2
    echo "$0: debug[3]: SITE_URL=$SITE_URL" 1>&2
    echo "$0: debug[3]: NOOP=$NOOP" 1>&2
    echo "$0: debug[3]: DOCROOT_SLASH=$DOCROOT_SLASH" 1>&2
    echo "$0: debug[3]: EXIT_CODE=$EXIT_CODE" 1>&2
    echo "$0: debug[3]: REPO_NAME=$REPO_NAME" 1>&2
    for index in "${!TOOL_OPTION[@]}"; do
	echo "$0: debug[3]: TOOL_OPTION[$index]=${TOOL_OPTION[$index]}" 1>&2
    done
    echo "$0: debug[3]: AUTHOR_PATH=$AUTHOR_PATH" 1>&2
    echo "$0: debug[3]: AUTHOR_DIR=$AUTHOR_DIR" 1>&2
    echo "$0: debug[3]: BIN_PATH=$BIN_PATH" 1>&2
fi

# -N stops early before any processing is performed
#
if [[ -n $DO_NOT_PROCESS ]]; then
    if [[ $V_FLAG -ge 3 ]]; then
	echo "$0: debug[3]: arguments parsed, -N given, exiting 0" 1>&2
    fi
    exit 0
fi

# create a temporary entry markdown file
#
TMP_AUTHORS_MD=".$NAME.$$.entry.md"
if [[ $V_FLAG -ge 3 ]]; then
    echo  "$0: debug[3]: temporary entry markdown file: $TMP_AUTHORS_MD" 1>&2
fi
if [[ -z $NOOP ]]; then
    trap 'rm -f $TMP_AUTHORS_MD; exit' 0 1 2 3 15
    rm -f "$TMP_AUTHORS_MD"
    if [[ -e $TMP_AUTHORS_MD ]]; then
	echo "$0: ERROR: cannot remove temporary entry markdown file: $TMP_AUTHORS_MD" 1>&2
	exit 10
    fi
    :> "$TMP_AUTHORS_MD"
    if [[ ! -e $TMP_AUTHORS_MD ]]; then
	echo "$0: ERROR: cannot create temporary entry markdown file: $TMP_AUTHORS_MD" 1>&2
	exit 11
    fi
elif [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: because of -n, temporary entry markdown file is not used: $TMP_AUTHORS_MD" 1>&2
fi

# create a temporary sort word list file
#
TMP_SORT_WORD=".$NAME.$$.sort.word"
if [[ $V_FLAG -ge 3 ]]; then
    echo  "$0: debug[3]: temporary sort word list file: $TMP_SORT_WORD" 1>&2
fi
if [[ -z $NOOP ]]; then
    trap 'rm -f $TMP_AUTHORS_MD $TMP_SORT_WORD; exit' 0 1 2 3 15
    rm -f "$TMP_SORT_WORD"
    if [[ -e $TMP_SORT_WORD ]]; then
	echo "$0: ERROR: cannot remove temporary sort word list file: $TMP_SORT_WORD" 1>&2
	exit 12
    fi
    :> "$TMP_SORT_WORD"
    if [[ ! -e $TMP_SORT_WORD ]]; then
	echo "$0: ERROR: cannot create temporary sort word list file: $TMP_SORT_WORD" 1>&2
	exit 13
    fi
elif [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: because of -n, temporary sort word list file is not used: $TMP_SORT_WORD" 1>&2
fi

# load initial letter . lines into the temporary sort word list file
#
for letter in "${!IS_FOR[@]}"; do
    echo "$letter ."
done > "$TMP_SORT_WORD"

# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - until we have the jnamval command, we must FAKE PARSE the author/author_handle.json file - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX

# add author sort_word filename to the temporary sort word list file
#
find "$AUTHOR_DIR" -mindepth 1 -maxdepth 1 -type f -name '*.json' 2>/dev/null | while read -r json_file; do
    SORT_WORD=$(grep -F '"sort_word" : "' "$json_file" 2>/dev/null | sed -e 's/",//' -e 's/^.*"//')
    echo "$SORT_WORD $json_file"
done >> "$TMP_SORT_WORD"

# sort the temporary sort word list file
#
sort -f -d "$TMP_SORT_WORD" -o "$TMP_SORT_WORD"
status="$?"
if [[ $status -ne 0 ]]; then
    echo "$0: ERROR: sort -f -d $TMP_SORT_WORD -o $TMP_SORT_WORD failed, error: $status" 1>&2
    exit 14
fi

# generate the temporary entry markdown file
#
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - until we have the jnamval command, we must FAKE PARSE the author/author_handle.json file - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
#
{
    # output top of content
    #
    cat << EOF
<center><p>Jump to authors starting with: [
<a href="#A">A</a>&nbsp;&nbsp;
<a href="#B">B</a>&nbsp;&nbsp;
<a href="#C">C</a>&nbsp;&nbsp;
<a href="#D">D</a>&nbsp;&nbsp;
<a href="#E">E</a>&nbsp;&nbsp;
<a href="#F">F</a>&nbsp;&nbsp;
<a href="#G">G</a>&nbsp;&nbsp;
<a href="#H">H</a>&nbsp;&nbsp;
<a href="#I">I</a>&nbsp;&nbsp;
<a href="#J">J</a>&nbsp;&nbsp;
<a href="#K">K</a>&nbsp;&nbsp;
<a href="#L">L</a>&nbsp;&nbsp;
<a href="#M">M</a>&nbsp;&nbsp;
<a href="#N">N</a>&nbsp;&nbsp;
<a href="#O">O</a>&nbsp;&nbsp;
<a href="#P">P</a>&nbsp;&nbsp;
<a href="#Q">Q</a>&nbsp;&nbsp;
<a href="#R">R</a>&nbsp;&nbsp;
<a href="#S">S</a>&nbsp;&nbsp;
<a href="#T">T</a>&nbsp;&nbsp;
<a href="#U">U</a>&nbsp;&nbsp;
<a href="#V">V</a>&nbsp;&nbsp;
<a href="#W">W</a>&nbsp;&nbsp;
<a href="#X">X</a>&nbsp;&nbsp;
<a href="#Y">Y</a>&nbsp;&nbsp;
<a href="#Z">Z</a>
]</p></center>
<p>
<hr>

EOF

    # process each line in the temporary sort word list file
    #
    while read -r sort_word filename; do

	# case: we have a "letter ." line
	#
	if [[ $filename == "." ]]; then

	    # output the letter header
	    #
	    l="$sort_word"
	    echo "<!-- $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l -->"
	    echo "## <a name=\"$l\"></a>${IS_FOR[$l]}"
	    echo "<!-- $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l  $l -->"
	    echo

	# case: we have a "sort_word file" line
	#
	else

	    # collect scalar information from the author/author_handle.json file
	    #
	    if [[ -z $sort_word ]]; then
		echo "$0: ERROR: sort_word is empty" 1>&2
		exit 15
	    fi
	    FULL_NAME=$(output_full_name "$filename")
	    if [[ -z $FULL_NAME ]]; then
		echo "$0: ERROR: full name is empty in: $filename" 1>&2
		exit 16
	    fi
	    LOCATION_CODE=$(output_location_code "$filename")
	    if [[ -z $LOCATION_CODE ]]; then
		echo "$0: ERROR: location code is empty in: $filename" 1>&2
		exit 17
	    fi
	    LOCATION_NAME=$("$LOCATION_TOOL" "$LOCATION_CODE" 2>/dev/null)
	    status="$?"
	    if [[ $status -ne 0 ]]; then
		echo "$0: ERROR: cannot determine location name" \
		     "for location ISO 3166 code: $LOCATION_CODE" 1>&2
		exit 18
	    fi
	    if [[ -z $LOCATION_NAME ]]; then
		echo "$0: ERROR: location name" \
		     "for location ISO 3166 code: $LOCATION_CODE is empty: $LOCATION_NAME" 1>&2
		exit 19
	    fi
	    LOCATION_COMMON_NAME=$("$LOCATION_TOOL" -c "$LOCATION_CODE" 2>/dev/null)
	    status="$?"
	    if [[ $status -ne 0 ]]; then
		echo "$0: ERROR: cannot determine location common name" \
		     "for location ISO 3166 code: $LOCATION_CODE" 1>&2
		exit 20
	    fi
	    if [[ -z $LOCATION_COMMON_NAME ]]; then
		echo "$0: ERROR: location common name" \
		     "for location ISO 3166 code: $LOCATION_CODE is empty: $LOCATION_COMMON_NAME" 1>&2
		exit 21
	    fi
	    AUTHOR_HANDLE=$(output_author_handle "$filename")
	    if [[ -z $AUTHOR_HANDLE ]]; then
		echo "$0: ERROR: author handle is empty in: $filename" 1>&2
		exit 22
	    fi

	    # output author information
	    #
	    echo "<p><a name=\"$AUTHOR_HANDLE\"></a>**$FULL_NAME**</br>"
	    echo "author_handle: $AUTHOR_HANDLE</br>"
	    if [[ $LOCATION_NAME == $LOCATION_COMMON_NAME ]]; then
		echo "Location: [$LOCATION_CODE](location.html#$LOCATION_CODE) -" \
		     "_${LOCATION_NAME}_</p>"
	    else
		echo "Location: [$LOCATION_CODE](location.html#$LOCATION_CODE) -" \
		     "_${LOCATION_NAME}_ (_${LOCATION_COMMON_NAME}_)</p>"
	    fi

	    # output YYYY/dir set made bu this author
	    #
	    output_entry_ids "$filename" | while read -r ENTRY_ID; do

		# verify the entry id
		#
		if [[ $ENTRY_ID =~ ^[^_][^_]*_[^_][^_]*$ ]]; then
		    if [[ $V_FLAG -ge 7 ]]; then
			echo "$0: debug[7]: entry_id: $entry_id" 1>&2
		    fi
		else
		    echo "$0: ERROR: entry_id is not in YYYY_dir formmat: $entry_id" 1>&2
		    exit 23
		fi
		YYYY_DIR=$(echo "$ENTRY_ID" | tr _ /)
		if [[ ! -d $YYYY_DIR ]]; then
		    echo "$0: ERROR: YYYY/dir is not a directory" 1>&2
		    exit 24
		fi

		# verify that the .entry.json file is a non-empty readable file
		#
		ENTRY_JSON="$YYYY_DIR/.entry.json"
		if [[ ! -e $ENTRY_JSON ]]; then
		    echo "$0: ERROR: .entry.json does not exist: $ENTRY_JSON" 1>&2
		    exit 25
		fi
		if [[ ! -f $ENTRY_JSON ]]; then
		    echo "$0: ERROR: .entry.json is not a file: $ENTRY_JSON" 1>&2
		    exit 26
		fi
		if [[ ! -r $ENTRY_JSON ]]; then
		    echo "$0: ERROR: .entry.json is not a readable file: $ENTRY_JSON" 1>&2
		    exit 27
		fi
		if [[ ! -s $ENTRY_JSON ]]; then
		    echo "$0: ERROR: .entry.json is not a non-empty readable file: $ENTRY_JSON" 1>&2
		    exit 28
		fi
		if [[ $V_FLAG -ge 7 ]]; then
		    echo "$0: debug[7]: .entry.json: $ENTRY_JSON" 1>&2
		fi

		# collect the award for this entry id
		#
		AWARD=$(output_award "$ENTRY_JSON")
		if [[ -z $AWARD ]]; then
		    echo "$0: ERROR: award not found in .entry.json: $ENTRY_JSON" 1>&2
		    exit 29
		fi

		# output the YYYY/dir entry for this author
		#
		echo "* <a href=\"$YYYY_DIR/index.html\">$YYYY_DIR</a> - $AWARD"
	    done
	    echo
	fi
    done < "$TMP_SORT_WORD"
} | if [[ -z $NOOP ]]; then
    cat >> "$TMP_AUTHORS_MD"
else
    cat > /dev/null
    if [[ $V_FLAG -ge 3 ]]; then
        echo "$0: debug[3]: because of -n, temporary entry markdown file is NOT written into: $TMP_AUTHORS_MD" 1>&2
    fi
fi

# use the md2html.sh tool to form a location HTML file, unless -n
#
if [[ -z $NOOP ]]; then
    if [[ $V_FLAG -ge 1 ]]; then
	echo "$0: debug[1]: about to run: $MD2HTML_SH ${TOOL_OPTION[*]} -- authors.md $TMP_AUTHORS_MD $AUTHORS_HTML" 1>&2
    fi
    "$MD2HTML_SH" "${TOOL_OPTION[@]}" -- authors.md "$TMP_AUTHORS_MD" "$AUTHORS_HTML"
    status="$?"
    if [[ $status -ne 0 ]]; then
	echo "$0: Warning: md2html.sh: $MD2HTML_SH ${TOOL_OPTION[*]} -- authors.md $TMP_AUTHORS_MD $AUTHORS_HTML" \
	     "failed, error: $status" 1>&2
	EXIT_CODE="1"  # exit 1
	echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
    elif [[ $V_FLAG -ge 3 ]]; then
	echo "$0: debug[3]: now up to date: $AUTHORS_HTML" 1>&2
    fi

# report disabled by -n
#
elif [[ $V_FLAG -ge 5 ]]; then
    echo "$0: debug[5]: because of -n, did not run: $MD2HTML_SH ${TOOL_OPTION[*]} -- authors.md $TMP_AUTHORS_MD $AUTHORS_HTML" 1>&2
fi

# file cleanup
#
if [[ -z $NOOP ]]; then
    rm -f -- "$TMP_AUTHORS_MD"
elif [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: because of -n, disabled: rm -f -- $TMP_AUTHORS_MD" 1>&2
fi

# All Done!!! -- Jessica Noll, Age 2
#
exit 0
