# IOCCC markdown best practices

The IOCCC makes extensive use of [markdown](https://daringfireball.net/projects/markdown/).
For example, we [submitting to the IOCCC](faq.html#submit), we have people
to submit remarks about entry in markdown format.  Every
[winning IOCCC entry](years.html) uses a `README.md` markdown file
as the basis for forming the `index.html` web page for that entry.
All generated HTML pages on the [Official IOCCC web site](https://www.ioccc.org/index.html)
start with some markdown content.

See the [markdown syntax](https://www.markdownguide.org/basic-syntax) guide.
See also [CommonMark Spec](https://spec.commonmark.org/current/).

Nevertheless, the IOCCC does have certain practices that we ask authors to follow.

In particular there are things we ask people to please do **NOT** use markdown files:


## Do not use name attributes in HTML a tags

Please do not use the HTML construct:

```
    <a name="string">\</a>
```

as those are **NOT** part of the HTML 5 standard.

Instead use:

```
    <div id="string">...\</div>
```

where the "..." is the HTML you want to "name". The **div**
encapsulates the HTML you want to name: I.e., the target of some
"**\<a href="#string">**" or some other "**\<a href="URL#string">**"
for the given page URL.

There are certain HTML Elements that cannot have internal "**\<div
id="string">...\</div>**".  For example you cannot do this:

```
    # <div id="string">This will not work</div>
```

For things like headings, you have to surround them as in:

```
    <div id="string">
    # This will work
    </div>
```

While some browsers will still recognize the HTML construct "**\<a
name="string">\</a>**", they may not in the future.


## Do not use trailing backslash outside of a code block

Unless the line is inside a markdown code block, please do **NOT**
end a markdown line with a trailing backslash ("\\").  Instead use
a trailing "**\<br>**".

Instead of:

```
    In markdown,\
    do not use trailing\
    backslashes outside of\
    a code block
```

use:

```
    In markdown,<br>
    use trailing<br>
    br's outside of<br>
    a code block
```

Again, use of a trailing backslash ("\\") inside a markdown code block is fine:

````
```
    This is OK\
    inside a\
    markdown code\
    block
```
````

This will avoid `pandoc(1)` generating deprecated HTML elements such as:

"**\<br />**"


## Do not use markdown image elements

Please do not use the markdown embedded image element.

Instead of using this markdown element to embed an image:

```
    ![alt text](filename.png "Title")
```

Use a "img" HTML element with "alt", "alt", "width" and "length"
attributes:

```
    <img src="filename.png"
     alt="describe the filename.png image for someone who cannot view it"
     width=PIXEL_WIDTH height=PIXEL_HEIGHT>
```

For example, instead of:

```
    ![1984-anonymous-tattoo.jpg](1984-anonymous-tattoo.jpg)
```

use this HTML:

```
    <img src="1984-anonymous-tattoo.jpg"
     alt="image of a tattoo of the 1984 anonymous C code"
     width=600 height=401>
```

The problem goes beyond the fact that `pandoc(1)` generates problematic
HTML from the markdown image construct, the resulting HTML does not
have "width" and "height" information so browsers have to slow down
on rendering text around the image until it can internally determine
the image size.


## Do not use markdown style horizontal lines

Please do not use "**---**"-style lines in markdown to create horizontal
lines, nor to separate sections.

Unless something is inside a markdown code block, do not start a
line with 3 or more dashes ("-").

Such causes `pandoc(1)` to generate "**\<hr />**".  The  "**\<hr
/>**" has no effect in standard HTML 5 and interacts badly with
unquoted attribute values.

If a horizontal line is really needed, use:

```
    <hr>
```

If a short line is needed, use:

```
    <hr style="width:10%;text-align:left;margin-left:0">
```


## Do not use the strike HTML element

Please not use the HTML element:

```
    <strike>...</strike>
```

Use instead:

```
    <del>...</del>
```


## Do not use tt HTML elements

Please do not use the tt HTML elements:

```html
    <tt>The HTML 5 obsolete tt element is obsolete</tt>
```

Instead use either a monospaced span:

```html
    <span style="font-family: monospace;">Use of monospaced font is one option</span>
```

Or better and easier still, use an inline markdown code block:

```
    `inline markdown code block is easier and much better`
```
