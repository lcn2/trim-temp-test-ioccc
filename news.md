# Try mastodon

We plan to update our [IOCCC on Mastodon](https://fosstodon.org/@ioccc) feed
a bit more open than this web page.  We recommend you check that feed
for possibly newer news than what is posted here.

We tend to only post major news updates to this web page.

There is [help with Mastodon](https://mastodon.help) available for
those who might wish to [get started with Mastodon](https://fosstodon.org/deck/getting-started).

While there are many fine Mastodon server instances out there, the [IOCCC judges](../judges.html)
use [fosstodon.org](https://fosstodon.org/about) where lots of fun folk hang out,
and topics like science, technology, [free and open source](https://en.wikipedia.org/wiki/Free_and_open-source_software)
have a good home.  The [fosstodon.oeg](https://fosstodon.org/@fosstodon) folk made the IOCCC feel welcome.
And while using Mastodon is free, the [IOCCC judges](../judges.html) are pleased to
[support the Fosstodon Hub](https://hub.fosstodon.org/support/).


# 2024-02-29

We continue to make good progress on web site.  In the [temp-test-ioccc GitHub repo](https://github.com/ioccc-src/temp-test-ioccc) we have made nearly 4600 changes to date!

All web pages, including this one, are now constructed from markdown files and/or JSON data files using tools found in the [bin](bin/index.html) directory.


# 2023-05-22

We have been busy preparing for an important / significant update to this web site.  In the [temp-test-ioccc GitHub repo](https://github.com/ioccc-src/temp-test-ioccc) we have made nearly 2645 changes to date.

```
While you are free to look at the [temp-test-ioccc GitHub repo](https://github.com/ioccc-src/temp-test-ioccc),
please **do not link to it** as this repo and related web site will disappear once the main
[IOCCC winner repo](https://github.com/ioccc-src/winner) has been updated.

Also be aware that the [temp-test-ioccc GitHub repo](https://github.com/ioccc-src/temp-test-ioccc)
is undergoing rapid changes.  There are broken links and other things in mid-change.

Once we are ready to update the [IOCCC winner repo](https://github.com/ioccc-src/winner)
and its associated web site,
we will post a news article warning of the pending change that is about to arrive.
```

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
that will allow those who submit entires to be informed about the status of their submission.
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


# 2023-01-30

We added to the
[status.json](status.json) page,
a _"status_date"_ JSON member whose value is the date
of the most recent [status.json](status.json) modification,
in _date(1)_ format.

We also added to the
[status.json](status.json) page,
a _"latest_news"_ JSON member whose value is the date
of the most recent news item.

```json
"status_date" : "Mon Jan 30 02:28:44 PST 2023",
"latest_news" : "Mon Jan 30 02:28:44 PST 2023"
```


# 2022-12-18

As per the suggestion of [Toni Mikkola](https://fosstodon.org/@Virtaava@home.social)
(_@Virtaava@home.social_) we now maintain a
[status.json](status.json) page on this web site.

In addition to the IOCCC-style _easter egg_, you may count on
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


# 2022-11-29

We are plan to abandon our
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
**@ioccc@fosstodon.org**
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


# 2022-11-19

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

We are working on complete rebuild of this web site as well.


# 2022-01-15

Source code has been released for version **0.24 2022-01-15** of the
[mkiocccentry tool](https://github.com/ioccc-src/mkiocccentry),
a tool that is based on, and is containing, the official iocccsize tool,
will form a compressed tarball that a registered IOCCC contestant
will upload to the submit server (when the contest is open of course).

# 2021-12-27

[The Judges](judges.html)
are continuing to work on re-tooling how we run the IOCCC.
We are writing tools under various repositories our
[IOCCC GitHub organization site](https://github.com/ioccc-src).

**We plan to hold IOCCC28 in 2023.**
Sorry for the delay, but we think you will appreciate the re-tooling
when it is completed.
Stay tuned!


# 2021-10-21

[The Judges](judges.html)
are re-tooling how we run the IOCCC.
Our goal is to build a smoother, more rapid process centered around
[GitHub](https://github.com/ioccc-src/winner).

For example, when we announce the winning entries of the IOCCC,
we will do so by committing their code to the
[Winning entries](years.html)
of the IOCCC repo, so that people will be able immediately
view the winning source.

We plan to refactor and modernize the IOCCC web site.
We also plan to build a new and improved way to submit entries the next IOCCC.
As a result of all this work we need to do,
**we plan to hold IOCCC28 in 2023 instead of 2021**.
Sorry for the delay, but we think you will appreciate the re-tooling
when it is completed.

**Stay tuned for how you may be able to help in the IOCCC redesign for IOCCC28!**


<!--

    Copyright © 1984-2024 by Landon Curt Noll. All Rights Reserved.

    You are free to share and adapt this file under the terms of this license:

	Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

    For more information, see:

	https://creativecommons.org/licenses/by-sa/4.0/

-->
