# bin

The directory holds [bin](README.md) directory
holds tools that build files, such as HTML content, for the
[official IOCCC web site](https://www.ioccc.org).

For HTML content, the [bin](README.md) directory tools
makes use of HTML fragments from the [inc](../inc/README.md) directory
as well as various JSON files and other content from the
[IOCCC GitHub repo](https://github.com/ioccc-src/temp-test-ioccc).


## bin tools


### [all-run.sh](all-run.sh)

Run a command on all winning entries.

For example:

```sh
bin/all-run.sh -v 3 bin/quick-readme2index.sh -v 1
```

Or for example:

```sh
bin/all-run.sh -v 3 bin/readme2index.sh -v 1
```


### [gen-author.sh](gen-author.sh)

Output winning author(s) Related HTML.


### [gen-inventory.sh](gen-inventory.sh)

Output the inventory in HTML form for a winner index.html page.


### [ioccc-status.sh](ioccc-status)

Updates the [status.json](/status.json) file.


### [manifest.winner.json.awk](manifest.winner.json.awk)

Output manifest table from a winner .winner.json file.


### [pandoc-wrapper.sh](pandoc-wrapper.sh)

Wrapper tool to run pandoc.


### [quick-readme2index.sh](quick-readme2index.sh)

Runs [readme2index.sh](readme2index.sh) if the winner directory
does not have a non-empty `index.hmtl` file, or if either
`.winner.json` or `README.md` is newer than the `index.hmtl` file.

This is useful when only a few winners have been
modified (resulting in an updated `.winner.json` file)
or if the `README.md` of a few winners have been changed.

While the [readme2index.sh](readme2index.sh) take a few
seconds to run, when applied to 300+ winners,
the extra time can add up.

If only a few `index.hmtl` files need updating, then
this command will only briefly pause while the
slightly longer [readme2index.sh](readme2index.sh) is run:

```sh
bin/all-run.sh -v 3 bin/quick-readme2index.sh -v 1
```

**NOTE**: This command assumes that the relative
modification times for `index.hmtl`, .winner.json`,
and `README.md` are correct.  If in doubt, use:

```sh
bin/all-run.sh -v 3 bin/readme2index.sh -v 1
```


### [readme2index.sh](readme2index.sh)

Convert README.md into index.html.


### [subst.default.sh](subst.default.sh)

Print default substitutions.


### [subst.winner-index.sh](subst.winner-index.sh)

Print substitutions for a winner index.html.


### [subst.winner-navbar.awk](subst.winner-navbar.awk)

Output substitutions for navbar on behalf of a winner.


## How HTML content is built

Files under the [inc](../inc/README.md) directory contain HTML fragments that the
tools in the [bin](README.md) directory
tools use to form HTML content for the [official IOCCC web site](https://www.ioccc.org).

The canonical way that HTML content is built uses, by default, files of the form:

```
*.default.html
```


### HTML phases

The following HTML phase files are used to build HTML content:

0. inc/top.default.html
1. inc/head.default.html
2. inc/body.default.html
3. inc/header.default.html
4. inc/topnav.default.html
5. inc/begin-row.default.html
6. inc/begin-leftcolumn.default.html
7. inc/sidenav.default.html
8. inc/end-leftcolumn.default.html
9. inc/begin-rightcolumn.default.html
10. inc/before-content.default.html

Phases 11-19 are reserved for future use.

20. ((insert 'before tool' output))
21. ((insert 'pandoc wrapper tool' output))
22. ((insert 'after tool' output))

Phases 23-29 are reserved for future use.

30. inc/after-content.default.html
31. inc/end-rightcolumn.default.html
32. inc/end-row.default.html
33. inc/footer.default.html
34. inc/bottom.default.html

Phases 35-39 are reserved for future use.

In the above HTML phase numbers, except during HTML phase numbers 20-29, symbols of the form %%TOKEN%% are substituted.
Any %%TOKEN%% printed by the 'before tool' (-b tool), the 'pandoc wrapper tool' (-p tool), and the 'after tool' (-a tool)
are ignored (i.e., not substituted).

See the tool [readme2index.sh](readme2index.sh) for an example of
how HTML phases are implemented.


### Tool command line

The command line of tools in the [bin](README.md) directory,
and perhaps modified via [md2html config file](../inc/md2html.cfg) file may change
to using a different filename for a given phase.

For example when forming the HTML from `2020/ferguson2/chocolate-cake.md`,
a different "topnav" navigation bar is needed.  So instead of the
usual top navigation bar that normally directs people to the previous
entry for the year, or go up to the year page, or to the next entry
for the year, a top navigation bar to just go up to the entry's
main page is needed.   A line the [md2html config file](../inc/md2html.cfg) file
that refers to `2020/ferguson1/chocolate-cake.md` may specify use
of `topnav.up2index.html` instead of using the `topnav.default.html` default.

The HTML phase may be skipped resulting in no HTML output during a given phase.
Furthermore, forming HTML content from a given markdown file altogether.

See comments in the [md2html config file](../inc/md2html.cfg) file for details.
See also, the tool [readme2index.sh](readme2index.sh) for an example of
how such command lines are used.


## Use CAUTION when modifying inc files

Some of the files under this directory are used to form **MOST** of the HTML content
on the [official IOCCC web site](https://www.ioccc.org).

These files are used to form **MOST** of the HTML content
on the [experimental web site](https://ioccc-src.github.io/temp-test-ioccc/).

... and in particular files under [inc](../inc/README.md) that are of the form (called default HTML files) ...:

```
*.default.html
```

... contain default content used to form IOCCC HTML / IOCCC web pages.

Instead of editing the default HTML files in order to fix a special web page,
consider making a copy of the default file and modifying the [md2html config file](md2html.cfg) to refer to the copy instead.  That way your special case situation will
not impact **MOST** of the HTML content.


## Why do we do not use certain well know HTML technology

You may wonder why we need these files in the first place.
You may wonder why we even need the tools in the [bin](README.md) directory
when there other solutions available to form web pages.


### <a name="static-only"></a>Static web pages only

Here are some reasons why we are using these files and
special tools to create HTML content / IOCCC web pages:

We host [official IOCCC web site](https://www.ioccc.org) via [GitHub pages](https://pages.github.com).
As of the time this file written, **only static web pages are supported**.


### Cannot use server side include

We use [static web pages](#static-only), so use of "server side include" is not available to the IOCCC.

For example, Apache SSI "#include" does not work on [GitHub pages](https://pages.github.com).


### Cannot use a back-end database

We use [static web pages](#static-only), so use of "back-end database" is not available to the IOCCC.


### <a name="why-github"></a>Cannot use non-GitHub web servers

The [GitHub pages](https://pages.github.com) have the distributed server capacity needed to handle
the **huge download volume** or [Slashdot effect](https://en.wikipedia.org/wiki/Slashdot_effect)
that happens when a IOCCC winners are published.

Most so-called low cost web hosting sites have a somewhat hidden excessive bandwidth charge
and/or cap bandwidth when the volume gets too high, and/or do not have the infrastructure
that can handle the [Slashdot effect](https://en.wikipedia.org/wiki/Slashdot_effect).

The IOCCC had experience with people offering web mirrors and even free hosting
only to find that the generous benefactor moves on, or their service is purchased
by someone else who is not so generous.  While it is possible that GitHub might someday
suffer a similar fate, for the time being we are betting that GitHub will remain
willing to host the IOCCC.

The [official IOCCC web site](https://www.ioccc.org) is, after all, primarily C source code
with some supporting documentation.  As such it is a natural fit for GitHub and
[GitHub pages](https://pages.github.com).


### cannot use the HTML object tag

The _<_ object _>_ HTML tag does not work for our needs.

The browser context relationship between the HTML content holds the
HTML tag does not extend into the content that the tag includes.
For example, menu bars will not operate as specified by the [ioccc CSS](../ioccc.css).


### cannot use the HTML embed tag

The _<_ embed _>_ HTML tag does not work for our needs.

This tag wants one to specify the _width_ and _height_ in pixels.
Use of a percentage is not officially supported even if some browsers
might do so.  Our Responsive Web Design on the [ioccc CSS](../ioccc.css)
needs to be responsive to small-sized cell phone-like screens,
mid-sized table-like screens, as well as large-sized desktop-like screens.
Specifying a _width_ and _height_ in pixels will not work well in
all of those screen size contexts.


### cannot use the HTML iframe tag

The _<_ iframe _>_ HTML tag does not work for our needs.

This tag wants one to specify the _width_ and _height_ in pixels.
Use of a percentage is not officially supported even if some browsers
might do so.  Our Responsive Web Design on the [ioccc CSS](../ioccc.css)
needs to be responsive to small-sized cell phone-like screens,
mid-sized table-like screens, as well as large-sized desktop-like screens.
Specifying a _width_ and _height_ in pixels will not work well in
all of those screen size contexts.


### cannot use JavaScript to include content

We do not use JavaScript to include HTML content.

While the IOCCC may use JavaScript in the future to directly render things like C source code,
we will do so in such a way that someone will be able to view [official IOCCC web site](https://www.ioccc.org)
content with JavaScript disabled.

The IOCCC will **NOT MANDATE USE OF JavaScript** to view [official IOCCC web site](https://www.ioccc.org).

For this reason, we cannot use JavaScript include HTML content.


# terms

The following terms apply to tools, JSON files, and the directory structure
of this repo.


## `author`

An individual who was an `author` of at least one winning IOCCC entry.

Some authors have submitted more than one IOCCC entry that won.  Some winning
IOCCC entries have more than one author.


## `author_handle`

An `author_handle` is string that refers to a given author and is unique to the
IOCCC.  Each author has exactly one `author_handle`.

For each `author_handle`, there will be a JSON file of the form:

```
author/author_handle.json
```

Because the `author_handle` is used to form a JSON filename, the string must be
lower case POSIX safe string.  Furthermore, the `author_handle` must be an ASCII
string that matches this regexp:

```re
^[0-9a-z][0-9a-z_]*$
```

Default `author_handle`'s do not have multiple consecutive `_` (underscore)
characters.  Nevertheless, multiple consecutive `_` (underscore) characters are
allowed. Contest submitters who wish to override the `author_handle` may do so.

The `author_handle` is derived from the name of the author.  While there is a
algorithm that maps the name of the author (which can contain any UTF-8
characters) into a default `author_handle` string, those who submit an entry to
the IOCCC are free to choose a different `author_handle` string if they so
desire.

An `author` who has won a previous IOCCC is encouraged to reuse their
`author_handle` so that new winning entries can be associated with the same
author.

For an anonymous `author`, their handle is one of these forms:

```
Anonymous_year
```

or:

```
Anonymous_year.digits
```


The latter form is in case there are more than one anonymous author in a given
year.

NOTE: even if the directory name is not `anonymous` the above rules apply as in
in the case of [2005/anon](/2005/anon/anon.c).

Anonymous `author_handle`'s match this regexp:

```re
Anonymous_[0-9][0-9][0-9][0-9][.0-9]*$
```


## `winner`

An IOCCC entry that won an award for given IOCCC.

A `winner` has one more more `author`s.

Each `winner` is contained under its own directory.  The parent of the winner directory
is the year's directory.

While in most cases a `winner` consists of files under a `winner` directory,
there are a few cases where a `winner` directory contains subdirectories.

Use of subdirectories under a `winner` directory is discouraged and
may be limited to previous `winner`s that used them.


## `year`

A `year` is a 4 character string.  Most years are 4-digit strings that
represent the year.  Some special `year` strings are possible, such as _`mock`_.
Non-numeric `year` strings are lower case.

A `year` string matches this regexp:

```re
[0-9a-z][0-9a-z][0-9a-z][0-9a-z]
```

The `year` directories reside directly below the top level directory.


## `.year`

Each `year` will have a file directory under it named:

```
.year
```

The contents of the `.year` file is the year string of the directory. For
instance, [2020/.year](/2020/.year) has the string: `2020`.


## `dir`

A `dir` is a POSIX safe string that holds an winner.

A `dir` is a string that matches this regexp:

```re
^[a-z][0-9a-z.-]*$
```

Each `winner` is under its own individual directory.  This directory
is directly under a `year` directory.


### `winner_id`

A string that identifies the winning entry.  The string is of the form:

```
year_dir
```