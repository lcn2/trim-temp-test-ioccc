#!/usr/bin/env bash
#
# gen-location.sh - create the top level location.html page
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
export VERSION="1.1 2024-03-04"
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

# always add the '-U URL' for the top level location.html file
#
TOOL_OPTION+=("-U")
TOOL_OPTION+=("$SITE_URL/location.html")

# always add the '-D docroot/' for the top level location.html file
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

# note location.html file
#
export LOCATION_HTML="location.html"

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
    echo "$0: debug[3]: LOCATION_HTML=$LOCATION_HTML" 1>&2
fi

# -N stops early before any processing is performed
#
if [[ -n $DO_NOT_PROCESS ]]; then
    if [[ $V_FLAG -ge 3 ]]; then
	echo "$0: debug[3]: arguments parsed, -N given, exiting 0" 1>&2
    fi
    exit 0
fi

# create a temporary location markdown file
#
TMP_LOC_MD=".$NAME.$$.location.md"
if [[ $V_FLAG -ge 3 ]]; then
    echo  "$0: debug[3]: temporary location markdown file: $TMP_LOC_MD" 1>&2
fi
if [[ -z $NOOP ]]; then
    trap 'rm -f $TMP_LOC_MD; exit' 0 1 2 3 15
    rm -f "$TMP_LOC_MD"
    if [[ -e $TMP_LOC_MD ]]; then
	echo "$0: ERROR: cannot remove temporary location markdown file: $TMP_LOC_MD" 1>&2
	exit 10
    fi
    :> "$TMP_LOC_MD"
    if [[ ! -e $TMP_LOC_MD ]]; then
	echo "$0: ERROR: cannot create temporary location markdown file: $TMP_LOC_MD" 1>&2
	exit 11
    fi
elif [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: because of -n, temporary location markdown file is not used: $TMP_LOC_MD" 1>&2
fi

# generate the temporary location markdown file
#
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - until we have the jnamval command, we must FAKE PARSE the author/author_handle.json file - XXX
# XXX - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - GROSS HACK - XXX
# XXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX - XXX
#
{
    # process unique location_codes found in author_handle JSON files in dictionary order
    #
    find "$AUTHOR_DIR" -mindepth 1 -maxdepth 1 -type f -name '*.json' -print0 |
	  xargs -0 grep '"location_code".*:' |
	  sed -e 's/^.*: "//' -e 's/",*$//' |
	  sort -u |
	  while read -r LOCATION_CODE; do

	# use the location tool to obtain the location_name
	#
	LOCATION_NAME=$("$LOCATION_TOOL" "$LOCATION_CODE" 2>/dev/null)
	status="$?"
	if [[ $status -ne 0 ]]; then
	    echo "$0: ERROR: cannot determine location name for location ISO 3166 code: $LOCATION_CODE" 1>&2
	    exit 12
	fi

	# use the location tool to obtain the location common name
	#
	LOCATION_COMMON_NAME=$("$LOCATION_TOOL" -c "$LOCATION_CODE" 2>/dev/null)
	status="$?"
	if [[ $status -ne 0 ]]; then
	    echo "$0: ERROR: cannot determine location common name" \
		 "for location ISO 3166 code: $LOCATION_CODE" 1>&2
	    exit 13
	fi

	# found the number of authors at this location
	#
	AUTHOR_COUNT=$(find "$AUTHOR_DIR" -mindepth 1 -maxdepth 1 -type f -name '*.json' -print0 |
		       xargs -0 grep -l '"location_code".*:.*"'"$LOCATION_CODE"'"' |
		       wc -l |
		       sed -e 's/[[:space:]]*//')
	if [[ -z $AUTHOR_COUNT || $AUTHOR_COUNT -le 0 ]]; then
	    echo "$0: ERROR: author count was zero for location: $LOCATION_CODE" 1>&2
	    exit 14
	fi

	# output markdown entry for this location
	#
	if [[ $LOCATION_NAME == $LOCATION_COMMON_NAME ]]; then
	    echo "* <a name=$LOCATION_CODE></a>**$LOCATION_CODE** - _${LOCATION_NAME}_"
	else
	    echo "* <a name=$LOCATION_CODE></a>**$LOCATION_CODE** - _${LOCATION_NAME}_ (_${LOCATION_COMMON_NAME}_)"
	fi
	echo
	echo "  Author count: **$AUTHOR_COUNT**"
	echo

	# process each author_handle JSON files with this location in sort_word order
	#
	# For SC2034, we only need to sort on the sort_word.  We do not care about its value.
	#
	# SC2034 (warning): SORT_WORD appears unused. Verify use (or export if used externally).
	# https://www.shellcheck.net/wiki/SC2034
	# shellcheck disable=SC2034
	find "$AUTHOR_DIR" -mindepth 1 -maxdepth 1 -type f -name '*.json' -print0 |
	     xargs -0 grep -l '"location_code".*:.*"'"$LOCATION_CODE"'"' |
	     while read -r AUTHOR_JSON; do
		echo -n "$AUTHOR_JSON "
		grep '"sort_word".*:' "$AUTHOR_JSON" | sed -e 's/^.*: "//' -e 's/",*$//'
	done |
	sort -k 2d |
	while read -r AUTHOR_HANDLE_PATH SORT_WORD; do

	    # The author_handle foo_bin is found in author/foo_bar.json
	    #
	    AUTHOR_HANDLE=$(basename "$AUTHOR_HANDLE_PATH" .json)

	    # fetch full_name
	    #
	    FULL_NAME=$(grep '"full_name".*:' "$AUTHOR_HANDLE_PATH" | sed -e 's/^.*: "//' -e 's/",*$//')

	    # output the author from the location
	    #
	    echo "  * [$FULL_NAME](authors.html#$AUTHOR_HANDLE)"
	done
	echo
    done

} | if [[ -z $NOOP ]]; then
    cat >> "$TMP_LOC_MD"
else
    cat > /dev/null
    if [[ $V_FLAG -ge 3 ]]; then
        echo "$0: debug[3]: because of -n, temporary location markdown file is NOT written into: $TMP_LOC_MD" 1>&2
    fi
fi

# use the md2html.sh tool to form a location HTML file, unless -n
#
if [[ -z $NOOP ]]; then
    if [[ $V_FLAG -ge 1 ]]; then
	echo "$0: debug[1]: about to run: $MD2HTML_SH ${TOOL_OPTION[*]} -- location.md $TMP_LOC_MD $LOCATION_HTML" 1>&2
    fi
    "$MD2HTML_SH" "${TOOL_OPTION[@]}" -- location.md "$TMP_LOC_MD" "$LOCATION_HTML"
    status="$?"
    if [[ $status -ne 0 ]]; then
	echo "$0: Warning: md2html.sh: $MD2HTML_SH ${TOOL_OPTION[*]} -- location.md $TMP_LOC_MD $LOCATION_HTML" \
	     "failed, error: $status" 1>&2
	EXIT_CODE="1"  # exit 1
	echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
    elif [[ $V_FLAG -ge 3 ]]; then
	echo "$0: debug[3]: now up to date: $LOCATION_HTML" 1>&2
    fi

# report disabled by -n
#
elif [[ $V_FLAG -ge 5 ]]; then
    echo "$0: debug[5]: because of -n, did not run: $MD2HTML_SH ${TOOL_OPTION[*]} -- location.md $TMP_LOC_MD $LOCATION_HTML" 1>&2
fi

# file cleanup
#
if [[ -z $NOOP ]]; then
    rm -f -- "$TMP_LOC_MD"
elif [[ $V_FLAG -ge 3 ]]; then
    echo "$0: debug[3]: because of -n, disabled: rm -f -- $TMP_LOC_MD" 1>&2
fi

# All Done!!! -- Jessica Noll, Age 2
#
exit 0
