#!/usr/bin/env bash
#
# all-run.sh - run a command for all entries
#
# We cd to topdir, than then walk the entry directory tree.
# We obtain the set of IOCCC years (YYYY) via the .top file.
# For each year (YYYY), we obtain the set of entry directories (dir).
# For all entry directories (YYYY/dir) we run the tool.
#
# The tool argument, if not an absolute path, must be relative to topdir.
# The tool argument is the first argument command line.  Any additional
# arguments beyond the first tool argument are treated as more tool options.
#
# NOTE: A command line option is a dashed letter (e.g., -n or --) followed by an optional string (e.g., -v 3).
#	Command line arguments follow any command line options (including any final -- option).
#	While the 1st command line cannot start with a dash, optional line arguments that follow by start with a dash.
#
# Each tool run with command line of the form:
#
#	tool [any -D, -t tagline, -T md2html.sh, -p tool, -u repo_url, -w site_url] [more_options] YYYY/dir
#
# For example:
#
#	all-run.sh -v 3 -t readme2html -U https://www.ioccc.org bin/quick-readme2html.sh -v 1
#
# will run the tool bin/quick-readme2html.sh for each entry YYYY/dir as follows:
#
#	bin/quick-readme2html.sh -t readme2html -U https://www.ioccc.org YYYY/dir -v 1
#
# Only the "-D -t, -T, -p, -u, -w" option set are passed to the tool command line.
# For all other special tool options, pass them as additional tool options (i.e., command line arguments
# that follow the 1st command line argument) OR consider simply running the tool directly.
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
shopt -s globskipdots	# enable never matching . or ..
shopt -u nocaseglob	# disable strict case matching
shopt -u extglob	# enable extended globbing patterns
shopt -s globstar	# enable ** to match all files and zero or more directories and subdirectories

# set variables referenced in the usage message
#
export VERSION="1.3 2024-02-11"
NAME=$(basename "$0")
export NAME
export V_FLAG=0
GIT_TOOL=$(type -P git)
export GIT_TOOL
if [[ -z "$GIT_TOOL" ]]; then
    echo "$0: FATAL: git tool is not installed or not in \$PATH" 1>&2
    exit 10
fi
"$GIT_TOOL" rev-parse --is-inside-work-tree >/dev/null 2>&1
status="$?"
if [[ $status -eq 0 ]]; then
    TOPDIR=$("$GIT_TOOL" rev-parse --show-toplevel)
fi
export DOCROOT_SLASH="../../"
export TAGLINE="unspecified"
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
			[-t tagline] [-T md2html.sh] [-p tool] [-u repo_url] [-w site_url]
			tool [more_options]

	-h		print help message and exit
	-v level	set verbosity level (def level: 0)
	-V		print version string and exit

	-d topdir	set topdir (def: $TOPDIR)
	-D docroot/	set the document root path followed by slash (def: $DOCROOT_SLASH)
			NOTE: The '-D docroot/' is passed as leading options on tool command lines.
			NOTE: 'docroot' must end in a slash

	-n		go thru the actions, but do not update any files (def: do the action)
	-N		do not process anything, just parse arguments (def: process something)

	-t tagline	string to write about the tool that formed the markdown content (def: $TAGLINE)
			NOTE: 'pandoc_opts' may be enclosed within, but may NOT contain an internal single-quote or double-quote.
	-T md2html.sh	run 'markdown to html tool' to convert markdown into HTML (def: $MD2HTML_SH)

	-p tool		run 'pandoc wrapper tool' (not pandoc path) during HTML phase number 21 (def: use $PANDOC_WRAPPER)

	-u repo_url	Base level URL of target git repo (def: $REPO_URL)
			NOTE: The '-u repo_url' is passed as leading options on tool command lines.

	-w site_url	Base URL of the web site (def: $SITE_URL)
			NOTE: The '-w site_url' is passed as leading options on tool command lines.

	tool		the tool to run over all entries
	[more_options]	additional tool command line options to use before the YYYY/dir argument

NOTE: Any '-t tagline', '-T md2html.sh', '-p tool', '-P pandoc_opts', '-u repo_url', '-U top_url'
      are passed to the 'tool' at the beginning of the command line, and
      before any optional 'more_options' and before the final YYYY/dir argument.

Exit codes:
     0         all OK
     1	       some tool exited non-zero
     2         -h and help string printed or -V and version string printed
     3         command line error
     4         bash version is < 4.2
     5	       tool and/or md2html.sh is not an executable file
     6	       problems found with or in the topdir directory
     7	       problems found with or in the topdir/YYYY directory
     8	       problems found with or in the topdir/YYYY/dir directory
 >= 10 < 200   internal error
 >= 200	       ((not used))

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
	TOOL_OPTION+=("-D")
	TOOL_OPTION+=("$DOCROOT_SLASH")
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
	TOOL_OPTION+=("-t")
	TOOL_OPTION+=("$TAGLINE")
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
if [[ $V_FLAG -ge 5 ]]; then
    echo "$0: debug[5]: file argument count: $#" 1>&2
fi
#
# verify arg count and parse args
#
export TOOL
case "$#" in
0) echo "$0: ERROR: expected 1 or more args, found: $#" 1>&2
   echo "$USAGE" 1>&2
   exit 3
   ;;
1) TOOL="$1"
   ;;
*) TOOL="$1"
   shift
   while [[ $# -gt 0 ]]; do
	TOOL_OPTION+=("$1")
	shift
   done
   ;;
esac

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

# verify we have a non-empty readable .top file
#
export TOP_FILE=".top"
if [[ ! -e $TOP_FILE ]]; then
    echo  "$0: ERROR: .top does not exist: $TOP_FILE" 1>&2
    exit 6
fi
if [[ ! -f $TOP_FILE ]]; then
    echo  "$0: ERROR: .top is not a regular file: $TOP_FILE" 1>&2
    exit 6
fi
if [[ ! -r $TOP_FILE ]]; then
    echo  "$0: ERROR: .top is not an readable file: $TOP_FILE" 1>&2
    exit 6
fi
if [[ ! -s $TOP_FILE ]]; then
    echo  "$0: ERROR: .top is not a non-empty readable file: $TOP_FILE" 1>&2
    exit 6
fi

# verify tool is executable
#
if [[ ! -e $TOOL ]]; then
    echo  "$0: ERROR: TOOL does not exist: $TOOL" 1>&2
    exit 5
fi
if [[ ! -f $TOOL ]]; then
    echo  "$0: ERROR: TOOL is not a regular file: $TOOL" 1>&2
    exit 5
fi
if [[ ! -x $TOOL ]]; then
    echo  "$0: ERROR: TOOL is not an executable file: $TOOL" 1>&2
    exit 5
fi

# verify that the md2html.sh is executable
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
    echo "$0: debug[3]: TOP_FILE=$TOP_FILE" 1>&2
    echo "$0: debug[3]: DOCROOT_SLASH=$DOCROOT_SLASH" 1>&2
    echo "$0: debug[3]: TAGLINE=$TAGLINE" 1>&2
    echo "$0: debug[3]: MD2HTML_SH=$MD2HTML_SH" 1>&2
    echo "$0: debug[3]: PANDOC_WRAPPER=$PANDOC_WRAPPER" 1>&2
    echo "$0: debug[3]: REPO_URL=$REPO_URL" 1>&2
    echo "$0: debug[3]: SITE_URL=$SITE_URL" 1>&2
    echo "$0: debug[3]: NOOP=$NOOP" 1>&2
    echo "$0: debug[3]: DO_NOT_PROCESS=$DO_NOT_PROCESS" 1>&2
    echo "$0: debug[3]: EXIT_CODE=$EXIT_CODE" 1>&2
    echo "$0: debug[3]: TOOL=$TOOL" 1>&2
    for index in "${!TOOL_OPTION[@]}"; do
	echo "$0: debug[3]: TOOL_OPTION[$index]=${TOOL_OPTION[$index]}" 1>&2
    done
    echo "$0: debug[3]: REPO_NAME=$REPO_NAME" 1>&2
fi

# -N stops early before any processing is performed
#
if [[ -n $DO_NOT_PROCESS ]]; then
    if [[ $V_FLAG -ge 3 ]]; then
	echo "$0: debug[3]: arguments parsed, -N given, exiting 0" 1>&2
    fi
    exit 0
fi

# process each year
#
export YYYY
for YYYY in $(< "$TOP_FILE"); do

    # debug YYYY
    #
    if [[ $V_FLAG -ge 1 ]]; then
	echo "$0: debug[1]: starting to process year: $YYYY" 1>&2
    fi

    # verify that YYYY is a readable directory
    #
    if [[ ! -e $YYYY ]]; then
	echo  "$0: ERROR: YYYY does not exist: $YYYY" 1>&2
	EXIT_CODE="7"  # exit 7
	echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	continue
    fi
    if [[ ! -d $YYYY ]]; then
	echo  "$0: ERROR: YYYY is not a directory: $YYYY" 1>&2
	EXIT_CODE="7"  # exit 7
	echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	continue
    fi
    if [[ ! -r $YYYY ]]; then
	echo  "$0: ERROR: YYYY is not an readable directory: $YYYY" 1>&2
	EXIT_CODE="7"  # exit 7
	echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	continue
    fi

    # verify that YYYY has a non-empty readable .year file
    #
    export YEAR_FILE="$YYYY/.year"
    if [[ ! -e $YEAR_FILE ]]; then
	echo  "$0: ERROR: YYYY/.year does not exist: $YEAR_FILE" 1>&2
	EXIT_CODE="7"  # exit 7
	echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	continue
    fi
    if [[ ! -f $YEAR_FILE ]]; then
	echo  "$0: ERROR: YYYY/.year is not a regular file: $YEAR_FILE" 1>&2
	EXIT_CODE="7"  # exit 7
	echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	continue
    fi
    if [[ ! -r $YEAR_FILE ]]; then
	echo  "$0: ERROR: YYYY/.year is not an readable file: $YEAR_FILE" 1>&2
	EXIT_CODE="7"  # exit 7
	echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	continue
    fi
    if [[ ! -s $YEAR_FILE ]]; then
	echo  "$0: ERROR: YYYY/.year is not a non-empty readable file: $YEAR_FILE" 1>&2
	EXIT_CODE="7"  # exit 7
	echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	continue
    fi

    # process each entry directroy under YYYY
    #
    export YYYY_DIR
    for YYYY_DIR in $(< "$YEAR_FILE"); do

	# debug YYYY
	#
	if [[ $V_FLAG -ge 3 ]]; then
	    echo "$0: debug[3]: starting to process year/dir: $YYYY_DIR" 1>&2
	fi

	# parse YYYY_DIR
	#
	if [[ ! -d $YYYY_DIR ]]; then
	    echo "$0: ERROR: YYYY_DIR is not a directory: $YYYY_DIR" 1>&2
	    EXIT_CODE="7"  # exit 7
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	if [[ ! -w $YYYY_DIR ]]; then
	    echo "$0: ERROR: YYYY_DIR is not a writable directory: $YYYY_DIR" 1>&2
	    EXIT_CODE="7"  # exit 7
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	export YEAR_DIR=${YYYY_DIR%%/*}
	if [[ -z $YEAR_DIR ]]; then
	    echo "$0: ERROR: YYYY_DIR not in YYYY/dir form: $YYYY_DIR" 1>&2
	    EXIT_CODE="7"  # exit 7
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	export ENTRY_DIR=${YYYY_DIR#*/}
	if [[ -z $ENTRY_DIR ]]; then
	    echo "$0: ERROR: YYYY_DIR not in $YEAR_DIR/dir form: $YYYY_DIR" 1>&2
	    EXIT_CODE="7"  # exit 7
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	if [[ $ENTRY_DIR = */* ]]; then
	    echo "$0: ERROR: YYYY_DIR: $YYYY_DIR dir contains a /: $ENTRY_DIR" 1>&2
	    EXIT_CODE="7"  # exit 7
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi

	# verify that YYYY_DIR is a writable directory
	#
	if [[ ! -e $YYYY_DIR ]]; then
	    echo  "$0: ERROR: YYYY_DIR does not exist: $YYYY_DIR" 1>&2
	    EXIT_CODE="8"  # exit 8
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	if [[ ! -d $YYYY_DIR ]]; then
	    echo  "$0: ERROR: YYYY_DIR is not a directory: $YYYY_DIR" 1>&2
	    EXIT_CODE="8"  # exit 8
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	if [[ ! -w $YYYY_DIR ]]; then
	    echo  "$0: ERROR: YYYY_DIR is not an writable directory: $YYYY_DIR" 1>&2
	    EXIT_CODE="8"  # exit 8
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi

	# verify YYYY/dir/.path
	#
	export DOT_PATH="$YYYY_DIR/.path"
	if [[ ! -s $DOT_PATH ]]; then
	    echo "$0: ERROR: not a non-empty file: $DOT_PATH" 1>&2
	    EXIT_CODE="8"  # exit 8
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	DOT_PATH_CONTENT=$(< "$DOT_PATH")
	if [[ $YYYY_DIR != "$DOT_PATH_CONTENT" ]]; then
	    echo "$0: ERROR: arg: $YYYY_DIR does not match $DOT_PATH contents: $DOT_PATH_CONTENT" 1>&2
	    EXIT_CODE="8"  # exit 8
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	export ENTRY_JSON="$YYYY_DIR/.entry.json"
	if [[ ! -e $ENTRY_JSON ]]; then
	    echo "$0: ERROR: .entry.json does not exist: $ENTRY_JSON" 1>&2
	    EXIT_CODE="8"  # exit 8
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	if [[ ! -f $ENTRY_JSON ]]; then
	    echo "$0: ERROR: .entry.json is not a file: $ENTRY_JSON" 1>&2
	    EXIT_CODE="8"  # exit 8
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi
	if [[ ! -r $ENTRY_JSON ]]; then
	    echo "$0: ERROR: .entry.json is not a readable file: $ENTRY_JSON" 1>&2
	    EXIT_CODE="8"  # exit 8
	    echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
	    continue
	fi

	# run the tool unless -n
	#
	if [[ -z $NOOP ]]; then
	    if [[ $V_FLAG -ge 5 ]]; then
		echo "$0: debug[5]: about to run: $TOOL ${TOOL_OPTION[*]} -- $YYYY_DIR" 1>&2
	    fi
	    "$TOOL" "${TOOL_OPTION[@]}" -- "$YYYY_DIR"
	    status="$?"
	    if [[ $status -ne 0 ]]; then
		echo "$0: ERROR: tool: $TOOL ${TOOL_OPTION[*]} -- $YYYY_DIR failed, error: $status" 1>&2
		EXIT_CODE="1"  # exit 1
		echo "$0: Warning: EXIT_CODE set to: $EXIT_CODE" 1>&2
		continue
	    fi

	# report disabled by -n
	#
	elif [[ $V_FLAG -ge 5 ]]; then
	    echo "$0: debug[5]: because of -n, did not run: $TOOL ${TOOL_OPTION[*]} -- $YYYY_DIR" 1>&2
	fi
    done
done

# All Done!!! -- Jessica Noll, Age 2
#
if [[ $EXIT_CODE -ne 0 ]]; then
    echo "$0: Warning: about to exit non-zero: $EXIT_CODE" 1>&2
elif [[ $V_FLAG -ge 1 ]]; then
    echo "$0: debug[1]: about to exit $EXIT_CODE" 1>&2
fi
exit "$EXIT_CODE"
