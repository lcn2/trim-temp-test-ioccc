#!/usr/bin/env make
#
# IOCCC Makefile

################################################################################
#
# IOCCC winning entry code may not work on your system.  What was liked/allowed
# and worked in the past may no longer be liked/allowed or compile/run today.
#
# Bug fixes, corrections and typo fixes are VERY WELCOME.  If you see a problem,
# first check this URL for a list of known bugs and (mis)features of IOCCC entries:
#
#	https://www.ioccc.org/bugs.html
#
# GitHub pull requests are welcome!  Please see the above URL for details.
#
################################################################################
#
# This file is Copyright (c) 2023 by Landon Curt Noll.  All Rights Reserved.
# You are free to share and adapt this file under the terms this license:
#
#	Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
#
# For more information, see: https://creativecommons.org/licenses/by-sa/4.0/


#############################
# shell used by this Makefile
#############################
#
SHELL= bash

#######################
# common tool locations
#######################
#
include var.mk

#################################
# IOCCC web site maintenance tulz
#################################

# NOTE: The "tulz" (tools) in this section are intended to be used by those
#	who maintain the official IOCCC site.
#
# We file "tulz" paths should be relative to the top directory of the repo.
# We need only list those "tulz" that are invoked directly by the
# "IOCCC web site maintenance rulz" section below.

ALL_RUN= bin/all-run.sh
ALL_YEARS= bin/all-years.sh
GEN_AUTHORS= bin/gen-authors.sh
GEN_LOCATION= bin/gen-location.sh
GEN_YEARS= bin/gen-years.sh
GEN_YEAR_INDEX= bin/gen-year-index.sh
CHK_ENTRY= bin/chk-entry.sh
GEN_TOP_HTML= bin/gen-top-html.sh
GEN_STATUS= bin/gen-status.sh
GEN_OTHER_HTML= bin/gen-other-html.sh
README2INDEX= bin/readme2index.sh
QUICK_README2INDEX= bin/quick-readme2index.sh
GEN_SITEMAP= bin/gen-sitemap.sh
TAR_ENTRY= bin/tar-entry.sh
TAR_YEAR= bin/tar-year.sh
TAR_ALL= bin/tar-all.sh


#############
# IOCCC years
#############
#
YEARS=	1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 \
	1994 1995 1996 1998 2000 2001 2004 2005 2006 2011 \
	2012 2013 2014 2015 2018 2019 2020


###################
# build all entries
###################
#
all:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
	done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

.PHONY: all alt data everything diff_orig_prog diff_prog_orig \
	diff_alt_prog diff_prog_alt diff_orig_alt diff_alt_orig \
	clean clobber install genpath love haste waste maker \
	easter_egg sandwich supernova deep_magic magic charon pluto

# alternative executable
#
alt:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# data files
#
data:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# both all and alt
#
everything:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='


#####################
# make a difference #
#####################
#
# diff orig source and source
#
diff_orig_prog:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# diff source and orig source
#
diff_prog_orig:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# diff alt source and source
#
diff_alt_prog:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# diff source and alt source
#
diff_prog_alt:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# diff orig and alt
#
diff_orig_alt:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# diff alt and orig
diff_alt_orig:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='


###############
# utility rules
###############
#
clean:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

clobber:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

install:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

indent.c:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='


#################################
# IOCCC web site maintenance rulz
#################################

# NOTE: The rules in this section are intended to be used by those
#	who maintain the official IOCCC site.
#
# These rules make certain assumptions about critical tools that
# must be installed on your system in order to be effective.
# While code sometimes makes tests and issues errors if critical
# tools are not found, those tests are NOT exhaustive.
#
# Finally: The rules in this section are NOT needed if you
#	   simple want to examine, run / test winning IOCCC entries.

.PHONY: help genpath genfilelist verify_entry_files gen_authors gen_location gen_years \
	entry_index gen_top_html gen_status thanks gen_other_html quick_entry_index \
	gen_year_index quick_www www gen_sitemap sitemap \
	form_entry_tarball form_year_tarball form_all_tarball tar

# Suggest rules in this section
#
# This may not be much help to people who are not already familiar with
# the tools needed to build the web site, but it does print out a friendly
# reminder to those who understand it. For all else, there is "RTFS". :-)
#
help:
	@echo make genpath
	@echo make genfilelist
	@echo make verify_entry_files
	@echo make gen_authors
	@echo make gen_location
	@echo make gen_years
	@echo make entry_index
	@echo make gen_top_html
	@echo make gen_status
	@echo make gen_other_html
	@echo make gen_year_index
	@echo make quick_entry_index
	@echo make quick_www
	@echo make www
	@echo make gen_sitemap
	@echo make form_entry_tarball
	@echo make form_year_tarball
	@echo make form_all_tarball
	@echo make tar

# form the top level .top, YYYY level .year and winner level .path files
#
# IMPORTANT: This file assumes that make clobber was previously done.
#
genpath:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@${RM} -f .tmp.genpath
	@-for i in ${YEARS}; do \
	    echo "$$i" >> .tmp.genpath; \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@-if ${CMP} -s .tmp.genpath .top; then \
	    ${RM} -f .tmp.genpath; \
	    echo ".top already up to date"; \
	else \
	    ${MV} -f .tmp.genpath .top; \
	    ${CHMOD} 0444 .top; \
	    echo "updated .top"; \
	fi
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# generate YYYY level .filelist
#
# IMPORTANT: .filelist assumes that make clobber was previously done.
#
genfilelist:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    ${RM} -f "$$i/.genfilelist.tmp"; \
	    ${FIND} "$$i" -mindepth 1 -maxdepth 1 -type f ! -path "$$i/.genfilelist.tmp" ! -name .DS_Store | \
	      ${SORT} -f -d -u > "$$i/.genfilelist.tmp"; \
	    if ${CMP} -s "$$i/.genfilelist.tmp" "$$i/.filelist"; then \
		${RM} -f "$$i/.genfilelist.tmp"; \
		echo "$$i/.filelist already up to date"; \
	    else \
		${MV} -f "$$i/.genfilelist.tmp" "$$i/.filelist"; \
		${CHMOD} 0444 "$$i/.filelist"; \
		echo "updated $$i/.filelist"; \
	    fi; \
	done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# check to be sure all files in all entries exist
#
verify_entry_files: ${ALL_RUN} ${CHK_ENTRY}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${ALL_RUN} -v 3 ${CHK_ENTRY}
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# generate the top level authors.html page using the
# ${GEN_AUTHORS} tool (bin/gen-authors.sh).
#
gen_authors: ${GEN_AUTHORS} authors.html
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${GEN_AUTHORS} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# generate the top level location.html page using the
# ${GEN_LOCATION} tool (bin/gen-location.sh).
#
gen_location: ${GEN_LOCATION} location.html
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${GEN_LOCATION} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# generate the top level years.html page using the ${GEN_YEARS}
# tool (bin/gen-years.sh).
#
gen_years: ${GEN_YEARS} years.html
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${GEN_YEARS} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# force the build of ALL winner index.html files using
# the ${README2INDEX} tool (bin/readme2index.sh)
#
entry_index readme2index: ${ALL_RUN} ${README2INDEX}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${ALL_RUN} -v 3 ${README2INDEX} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# generate a number of the top level HTML files from top level markdown files
#
gen_top_html: ${GEN_TOP_HTML}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${GEN_TOP_HTML} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# generate a status.json and status.html
#
gen_status: ${GEN_STATUS}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${GEN_STATUS} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# a fishy rule :-)
#
thanks: ${GEN_TOP_HTML} thanks-for-help.md
	@echo "Thanks for all the help ..."
	@${GEN_TOP_HTML}
	@echo "... and thanks for all the fish :-)"

# generate build entry HTML files from markdown other than README.md to index.html HTML files
#
gen_other_html: ${GEN_OTHER_HTML}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${GEN_OTHER_HTML} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# generate year level index.html files using the
# ${GEN_YEAR_INDEX} tool (bin/gen-year-index.sh).
#
gen_year_index: ${ALL_YEARS} ${GEN_YEAR_INDEX}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${ALL_YEARS} -v 1 ${GEN_YEAR_INDEX} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# build winner index.html files that might be out of date
#
# This rule uses the ${QUICK_README2INDEX} tool
# (bin/quick-readme2index.sh), so some winner
# index.html files that seem to be up to date
# (but might not be up to date) won't be built.
#
quick_entry_index quick_readme2index: ${ALL_RUN} ${QUICK_README2INDEX}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${ALL_RUN} -v 3 ${QUICK_README2INDEX} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# generate the XML sitemap
#
gen_sitemap sitemap: ${GEN_SITEMAP}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${GEN_SITEMAP} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# do work to build HTML content for the web site
#
# This rule uses quick_entry_index, not slow_entry_index, so
# some winner index.html files that seem to be up to date
# (but might not be up to date) won't be built.
#
# Well, short of pushing changes to the GitHub repo, that is.  :-)
#
quick_www:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${MAKE} clobber
	${MAKE} genpath
	${MAKE} genfilelist
	${MAKE} verify_entry_files
	${MAKE} gen_authors
	${MAKE} gen_location
	${MAKE} gen_years
	${MAKE} gen_year_index
	${MAKE} gen_top_html
	${MAKE} gen_status
	${MAKE} gen_other_html
	${MAKE} quick_entry_index
	${MAKE} gen_sitemap
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# do everything needed to build HTML content for the web site
#
# Well, short of pushing changes to the GitHub repo, that is.  :-)
#
www:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${MAKE} clobber
	${MAKE} genpath
	${MAKE} genfilelist
	${MAKE} verify_entry_files
	${MAKE} gen_authors
	${MAKE} gen_location
	${MAKE} gen_years
	${MAKE} gen_year_index
	${MAKE} gen_top_html
	${MAKE} gen_status
	${MAKE} gen_other_html
	${MAKE} entry_index
	${MAKE} gen_sitemap
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# form all entry compressed tarballs
#
form_entry_tarball: ${ALL_RUN} ${TAR_ENTRY}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${ALL_RUN} -v 3 ${TAR_ENTRY} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# form all IOCCC year level compressed tarballs
#
form_year_tarball: ${ALL_YEARS} ${TAR_YEAR}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${ALL_YEARS} -v 3 ${TAR_YEAR} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# form compressed tarball for all of the IOCCC
#
form_all_tarball: ${TAR_ALL}
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${TAR_ALL} -v 1
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

# build all tarballs
#
tar:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	${MAKE} clobber
	${MAKE} genpath
	${MAKE} genfilelist
	${MAKE} verify_entry_files
	${MAKE} form_entry_tarball
	${MAKE} form_year_tarball
	${MAKE} form_all_tarball
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='


##################
# 133t hacker rulz
##################
#
love:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

haste:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

waste:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

maker:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

easter_egg:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

sandwich:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='


# The IOCCC resident astronomer states
#
supernova:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

deep_magic:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

magic:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

charon:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='

pluto:
	@echo '=-=-=-=-= IOCCC begin make $@ =-=-=-=-='
	@-for i in ${YEARS}; do \
	    echo "cd $$i; make $@"; \
	    (cd $$i; make $@); \
        done
	@echo '=-=-=-=-= IOCCC complete make $@ =-=-=-=-='
