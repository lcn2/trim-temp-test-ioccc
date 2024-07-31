# For more news, try mastodon

### Please follow the [IOCCC on Mastodon](https://fosstodon.org/@ioccc)

We use Mastodon to make minor announcements, in addition to announcing
major events such as the opening of a new IOCCC, or who won.

See the
FAQ on "[Mastodon](faq.html#try_mastodon)"
for more information on Mastodon.

<div id="news">
# News
</div>

## 2024-06-08

We continue to make good progress on the
[temp-test-ioccc website](https://ioccc-src.github.io/temp-test-ioccc/)
via the [temp-test-ioccc](https://github.com/ioccc-src/temp-test-ioccc) repo.

One of the [largest html
files](thanks-for-help.html) has
been checked for broken links which leaves two longer files to go. These two
files are the [bugs.html](bugs.html)
file and the "[IOCCC FAQ](faq.html)".

However, where it was thought that those two files would be looked at before the
other html files, it has been decided that they will be done after the other
files as it is very possible that some things in these two files will have to be
changed or added as the other files are reviewed for broken links.

As of today, 08 June 2024, the top level html files are being looked at, with at
least three done already ([judges.html](judges.html), [news.html](news.html) and
[status.html](status.html)). This should not take more than a few days if things
go as planned, as these files are small and should be relatively quick and easy
to check for broken links. Of course, some of these, like the
[news.html](news.html) and possibly [status.html](status.html) will likely have to be
checked again but as for [news.html](news.html) the dates up to and including _08
June 2024_ have been checked for invalid links so that only new news updates
will have to be checked.

Once those are done the html files of all the entries will be looked at. As
those are being reviewed it the [bugs.html](bugs.html) might very well be
updated and the "[IOCCC FAQ](faq.html)" might be as well.  This is why, as noted above,
we have decided to review these files last, in order to save time and effort in
not having to look at them more than once on a whole, other than possible
entries that have to be added at the end, like the example below.

Once the _submit server_ server is ready another FAQ will be added and that
entry can be looked at alone.


## 2024-05-30

A number of issues from minor fixes have been applied to the
[temp-test-ioccc website](https://ioccc-src.github.io/temp-test-ioccc/)
via the [temp-test-ioccc](https://github.com/ioccc-src/temp-test-ioccc) repo.

437 commits have been applied since 2024-04-20, bringing the total
number to 5260 commits to date.  The
[temp-test-ioccc](https://github.com/ioccc-src/temp-test-ioccc)
repo is now 5159 commits ahead of the [IOCCC
winner](https://github.com/ioccc-src/winner) repo.

Multiple **((top priority))** issues have been resolved or completed.
Only one **((top priority))** issue, [issue
2006](https://github.com/ioccc-src/temp-test-ioccc/issues/2006)
remains before we begin the final steps to perform the **Great Fork
Merge** when the [Official IOCCC web
site](https://www.ioccc.org/index.html) will be updated. And although there are
a lot of files to look at for this issue, most of them should go relatively
quickly, once these are started. One of the slower files is almost done and then
there are two more before we can look at the other files.

The [issue 2239](https://github.com/ioccc-src/temp-test-ioccc/issues/2239)
TODO list has 10 out of 51 sub-tasks completed.  That might not
seem like much progress, but keep in mind that some of those 10
tasks took many months and thousands of commits to complete.
Moreover, most of the remaining 41 TODO items are short "checkbox"
tasks.  The final 31 TODO items are planned to be completed in about
a single day.

The **IOCCC Submit server** is in active development.  We plan to
update the FAQ with screenshots from the IOCCC Submit server as
well as the **IOCCC registration process** prior to starting the
**Great Fork Merge**.

We have decided to **NOT** hold an **IOCCC mock** contest, but instead
ask for beta testing of the new **IOCCC registration process** and
**IOCCC Submit server** when they have left alpha testing phase.
This will speed up the start date of IOCCC28.

It is our plan that IOCCC28 will occur in 2024, the 40th anniversary of the
IOCCC.


## 2024-04-30

The website now is viewing by mobile devices such as cell phones
and tablets.  Devices with a screen resolution 1024 pixels and
narrower are given a _hamburger-style_ menu icon in place of
drop-down menus at the very top of the page (called the _topbar_).

Any mobile device with a screen wider than 1024 pixels will need
to _press and hold_ to force the  _topbar_ pull-down menu to activate.

We had to introduce the use of JavaScript to activate a _hamburger-style_
menu icon due to the way mobile device screen touching works.  Those
devices without JavaScript (or when JavaScript has been disabled)
will be given a link to a web page that presents the equivalent menu.

Fixed generated HTML files where a link to a local file was invalid.
Previous problems included malformed markdown, the local file was
missing, the local file is generated by make or the entry itself, etc.

The generated HTML files (via `bin` tools) and other HTML files are
now conform with HTML 5 standards.  The **Nu Html Checker** reports
**no error, warnings, nor info** messages.

The *Nu Html Checker** change from _2024-04-20_ is that the HTML
files that are static (not generated `bin` tools) report **no error,
warnings, nor info** messages, changes involving fixing invalid
links to local files have been corrected, and changes involving the
_topbar_ are now HTML 5 conforming.


## 2024-04-20

Nearly all of the [temp-test-ioccc website](https://ioccc-src.github.io/temp-test-ioccc/)
website has undergone editorial review.  Nearly all [IOCCC winning entries](years.html)
compile on modern systems and many have `try.sh` scripts to help you run them.
For those that cannot compile and/or do not work, we have made a
[Bugs and &lpar;Mis&rpar;features](bugs.html) page.

We have made nearly 4823 changes to date!

All generated HTML pages are now conform to HTML 5 with the
[Nu Html Checker](https://validator.w3.org/nu/) reporting **no error, warnings, nor info** messages.

The [IOCCC judges](judges.html) have contracted with a web designer
to improve the overall look of the website, while **maintaining
the utilitarian look and feel**, and without introducing any
glaring "_dancing bears_" and other frivolous web features.

We are working towards what we call the
**[Great Fork Merge](https://github.com/ioccc-src/temp-test-ioccc/issues/2239)**
where the contents of the [temp-test-ioccc website](https://ioccc-src.github.io/temp-test-ioccc/)
will be merged into the [Official IOCCC website](https://www.ioccc.org/index.html).

Stay tuned!


## 2024-02-29

We continue to make good progress on website.  In the [temp-test-ioccc GitHub repo](https://github.com/ioccc-src/temp-test-ioccc) we have made nearly 4600 changes to date!

All web pages, including this one, are now constructed from markdown files and/or JSON data files using tools found in the [bin](bin/index.html) directory.


## 2023-05-22

We have been busy preparing for an important / significant update to this website.  In the [temp-test-ioccc GitHub repo](https://github.com/ioccc-src/temp-test-ioccc) we have made nearly 2645 changes to date.

While you are free to look at the [temp-test-ioccc GitHub repo](https://github.com/ioccc-src/temp-test-ioccc),
please **do not link to it** as this repo and related website will disappear once the main
[IOCCC winner repo](https://github.com/ioccc-src/winner) has been updated.

Also be aware that the [temp-test-ioccc GitHub repo](https://github.com/ioccc-src/temp-test-ioccc)
is undergoing rapid changes.  There are broken links and other things in mid-change.

Once we are ready to update the [IOCCC winner repo](https://github.com/ioccc-src/winner)
and its associated website,
we will post a news article warning of the pending change that is about to arrive.

These 2645+ changes in the [temp-test-ioccc GitHub repo](https://github.com/ioccc-src/temp-test-ioccc)
include diverse things such as:

* Moving IOCCC entries into their own separate directories
* Fixing lots and lots of typos
* Fixing Makefiles and code to allow for nearly all winning IOCCC entries to be compiled on modern systems
* Reworking the Makefiles to use a consistent set of rules
* Reworking the Makefiles to compile under gcc and clang
* Replacing the various hint files with a index.html markdown that is more consistent across IOCCC years
* Setting up a system whereby authors of IOCCC entries may update their own contact information via a GitHub pull request
* Setting up to generate the top level [years.html](years.html) file via a tool
* Setting up to generate the top level [authors.html](authors.html) file via a tool
* etc.

We have lots more to do. Our work is not finished.  We just wanted to let you know that we are making good progress.

In regards to the next IOCCC.  We **do plan to hold a 28th IOCCC**.  However before we do that, we plan
to hold what will be called **IOCCCMOCK**, a beta-test IOCCC where we plan to test the new
[mkiocccentry tool](https://github.com/ioccc-src/mkiocccentry), a tool that will package
submissions to the IOCCC.

We are working on an improved **IOCCC submit server**
that will allow those who submit entries to be informed about the status of their submission.
This **IOCCC submit server** will be beta tested in the **IOCCCMOCK**.

We are working on a method to rapidly post the winning entries of an IOCCC.  No longer will entries
be subject to a long delay between announcing that they have won and their code being made available.
No longer will procrastination delay the public seeing the winning code.  Instead the
**announcement of the winning entries of an IOCCC will be done by posting the winning code via a GitHub commit.**
Any corrections, improvement, typo fixes and other fixes will be applied to the winning entries via GitHub pull requests:
by the authors and/or other interested 3rd parties.

All the above represent one of the most significant (and useful) changes to the IOCCC since it started back in 1984.
While we are doing lots of testing, we are sure that issues, mis-features and even bugs will be uncovered
when we **go live**.  For this reason, we plan to beta-test the process by holding an **IOCCCMOCK**.
The **IOCCCMOCK** will be like a regular IOCCC except that the judges **will not** judge the code.
Instead, people will be invited to submit a simple _"Hello, world!"_ style program.
Awards will be given to those who:

* submit the best pull requests that fix a bug
* submit the best pull requests that fix a typo
* make the best suggestions for improvements
* have the most fun / make us laugh
* etc.

The **IOCCCMOCK** will allow is to restart the beta-test contest should a major problem be discovered
that needs urgent fixing.
The **IOCCCMOCK** will us to beta-test the new IOCCC process without putting the hard work of those
who submit real IOCCC entries at risk.

Stay tuned!


## 2023-01-30

We added to the
[status.json](status.json) page,
a _"status_date"_ JSON member whose value is the date
of the most recent [status.json](status.json) modification,
in _date(1)_ format.

We also added to the
[status.json](status.json) page,
a _"latest_news"_ JSON member whose value is the date
of the most recent news item.

``` <!---json-->
    "status_date" : "Mon Jan 30 02:28:44 PST 2023",
    "latest_news" : "Mon Jan 30 02:28:44 PST 2023"
```


## 2022-12-18

As per the suggestion of [Toni Mikkola
&lpar;@Virtaava@home.social&rpar;](https://fosstodon.org/@Virtaava@home.social)
we now maintain a [status.json](status.json) page on this website.

In addition to the IOCCC-style _Easter egg_, you may count on
the JSON status page having a JSON member with name of **"contest"**
that will have a value of either **"closed"** or **"open"**.
When a future **IOCCC** is announced or the IOCCC is currently open,
the JSON member with name of **"contest"** will change from
**"closed"** to **"open"**.

Additional JSON members be added describing the contest such as
the IOCCC contest number, open date, close date, timezone, etc.
The details of such additional JSON members are _TBD_.

When an open IOCCC closes, we won't instantaneously update the
[status.json](status.json) page.
Instead you will have to rely on the additional JSON information
and/or read the [IOCCC news](#news),
and/or follow us on Mastodon via **@ioccc@fosstodon.org**.


## 2022-11-29

We are planning to abandon our
[IOCCC Twitter feed](https://twitter.com/ioccc)
in favor of our new [IOCCC Mastodon](https://fosstodon.org/@ioccc) feed.

Our Mastodon username is: **@ioccc@fosstodon.org**.

```
    Please note: As of the date of this posting, our account was just setup,
    so there isn't much to read there, yet.
```

In the future we plan to use Mastodon as our official announcement platform.
This will include announcing:

* IOCCC news updates
* Start of a new IOCCC
* Updates on the IOCCC judging process
* Who won the IOCCC
* et**C**. :-)

When registering for a new IOCCC, we will no longer ask for an optional twitter handle.
Instead, you will be asked if you wish to provide a Mastodon username when you submit your IOCCC entry.
Use of Mastodon is **NOT** required to enter the IOCCC, but nevertheless is encouraged.
Proving a Mastodon username will be entirely **optional**.

Non-mastodon users can follow the IOCCC postings via:
[fosstodon.org/@ioccc](https://fosstodon.org/@ioccc).

If you do not yet have a Mastodon account, you may obtain a **free mastodon account via**:
[joinmastodon.org](https://joinmastodon.org).

If you do have / obtain a Mastodon account, **please do us a favor and follow the IOCCC at**:

```
    @ioccc@fosstodon.org
```

The IOCCC wishes to thank the good folk running the
[fosstodon.org](https://hub.fosstodon.org/about/)
Mastodon hub.
Their technology focused
[Fosstodon Hub](https://hub.fosstodon.org)
is made possible by volunteers,
and those who voluntarily
[support](https://hub.fosstodon.org/support/) the cost of their server.

Stay tuned in Mastodon as we update you on our progress towards the next IOCCC!


## 2022-11-19

Source code has been released for version **0.8.1 2022-11-19** of the
[mkiocccentry repo](https://github.com/ioccc-src/mkiocccentry),
a GitHub repo that includes the official iocccsize tool,
and a tool will form a compressed tarball of their entry.

We are working on a submit server that will allow a registered IOCCC contestant
to upload the above mentioned compressed tarball: when the contest is open of course.

Once we reach version 1.0, we plan to invite the public to test and comment.

We plan to hold in 2023, what we will call **IOCCCMOCK**, a trial IOCCC contest where the
judges will go through the motions (without judging the content) of an IOCCC:
testing the above mentioned tools and testing the submit server.

We are working on complete rebuild of this website as well.


## 2022-01-15

Source code has been released for version **0.24 2022-01-15** of the
[mkiocccentry tool](https://github.com/ioccc-src/mkiocccentry),
a tool that is based on, and is containing, the official iocccsize tool,
will form a compressed tarball that a registered IOCCC contestant
will upload to the submit server (when the contest is open of course).

## 2021-12-27

[The Judges](judges.html)
are continuing to work on re-tooling how we run the IOCCC.
We are writing tools under various repositories our
[IOCCC GitHub organization site](https://github.com/ioccc-src).

**We plan to hold IOCCC28 in 2023.**
Sorry for the delay, but we think you will appreciate the re-tooling
when it is completed.
Stay tuned!


## 2021-10-21

[The Judges](judges.html)
are re-tooling how we run the IOCCC.
Our goal is to build a smoother, more rapid process centered around
[GitHub](https://github.com/ioccc-src/winner).

For example, when we announce the winning entries of the IOCCC,
we will do so by committing their code to the
[Winning entries](years.html)
of the IOCCC repo, so that people will be able immediately
view the winning source.

We plan to refactor and modernize the IOCCC website.
We also plan to build a new and improved way to submit entries the next IOCCC.
As a result of all this work we need to do,
**we plan to hold IOCCC28 in 2023 instead of 2021**.
Sorry for the delay, but we think you will appreciate the re-tooling
when it is completed.

**Stay tuned for how you may be able to help in the IOCCC redesign for IOCCC28!**


<hr style="width:10%;text-align:left;margin-left:0">

Jump to: [top](#)


<!--

    Copyright © 1984-2024 by Landon Curt Noll. All Rights Reserved.

    You are free to share and adapt this file under the terms of this license:

        Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

    For more information, see:

        https://creativecommons.org/licenses/by-sa/4.0/

-->
