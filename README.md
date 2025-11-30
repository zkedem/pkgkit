# pkgkit
A set of useful tools for building packages.

# Installation
Just use `make` followed by `make install`. To uninstall, use `make uninstall`. You may also reinstall or upgrade to a new version using `make reinstall`.

# What's included

## dpkgarch
Translates GNU CPU architecture names to those used by Debian and dpkg. Requires dpkg to be installed.

### Usage
```
dpkgarch [-h] [-r] [archname]
```
If no architecture name is given, `dpkgarch` will use the architecture name of the machine it is running on.

### Options

#### -h
Show the help message.

#### -r
Reverse translation; Debian names are translated to GNU names. An architecture name must be given to use this option.

## gitchangelog
Tool to generate a package changelog from your Git log.

### Format
For each commit message, the subject line must be the version of that commit (e.g. 1.0.0), and the body should be structured as follows:
```
- change-details
- more-change-details
[- *distributions*: distrib1 [distrib2...]]
[- *urgency*: low|medium|high|emergency|critical]
```
The body is structured as a Markdown bulleted list, using "\+" or "\-" as bullets, and generally following the guidelines set out in GitHub's [Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#lists) guidelines for unordered lists. Nested lists are supported. The change details are mandatory. Two additional optional (but recommended) items define package metadata, currently only for Debian-type packages:
- **distributions**: A space-separated list of distributions (i.e. `testing`, `stable`, `unstable`) for which the package can be installed. If this item is not present, the value of the `-d` option is used instead (see below).
- **urgency**: The level of importance of upgrading to this version of the package from a previous version. Can be one of `low`, `medium`, `high`, `emergency`, or `critical`. Defaults to `medium` if this item is not present.

Refer to the [Debian Policy Manual](https://www.debian.org/doc/debian-policy/ch-source.html#s-dpkgchangelog) for more information.

Each metadata item follows this form:
```
- *name*: value
```
where the asterisks (\*) may be substituted with underscores (\_), and `name` contains neither asterisks nor underscores.

### Usage
Currently, supported package types are `deb` and `rpm`.
```
gitchangelog [options] [deb|rpm]
```
By default, if no package type is given, or if the package type is unknown, the output is the same as `git log`.

### Options

#### -D format
Output version date in a given format, then exit. The formats are the same as for the `date` command, but without the leading "\+". Requires `-v` option.

#### -b
Output commit message body for a specific version, then exit. Requires `-v` option.

#### -d distrib
For Debian-type packages, a distribution value to use if none is defined by the commit log; may be given as a space-separated list. Defaults to `UNRELEASED`.

#### -h
Show the help message.

#### -n name
The name of the package; currently only needed for Debian-type packages.

#### -o file
Output changelog to file instead of standard output.

#### -r repo
Retrieve log from remote repository instead of current local repository; may also be used in directories that are not Git repositories.

#### -s
Skip changelog generation for an unknown or unspecified package type.

#### -t
Try local repository, then fall back to remote repository if it fails. Requires `-r` option.

#### -v version
Version of package; if this is not given, the latest version is assumed by default.

## preprocess
A simple preprocessor for shell scripts, man pages, or any file that needs to be generated from a template. Input may be standard input or a file.

### Directives
preprocess supports a number of directives in its input.

#### %MACRO%
Replace `MACRO` with a value given on the command line.

#### @MACRO@
Same as `%MACRO%`, but escapes characters from a set given on the command line, if that set is given.

#### \#FILE\#
Insert the contents of `FILE` at this point; may have an optional prefix before the "\#". This directive must be placed at the beginning of a line.

### Usage
```
preprocess [options] [MACRO=value...]
```

### Options

#### -c prefix
Defines a prefix that precedes the initial "\#" of the `#FILE#` directive. Usually, this will be whatever sequence of characters is used to indicate a comment in the language of the input. This is necessary for languages that don't use "\#" to indicate comments.\
\
Example: for JavaScript files, use `-c "//"`. Then, you can use the `#FILE#` directive like this:
```
//#somefile.js#
```

#### -d dest
Destination file. By default, preprocess edits source files in place. This option allows the output to be sent to a separate file.

#### -e chars
Escape these characters (by preceding them with a "\\") when expanding the `@MACRO@` directive (with "@" signs). This does not affect the `%MACRO%` directive (with "%" signs).\
\
Example: with `-e ".-"`, if `VERSION=1.0.0-beta` is given on the command line, `@VERSION@` expands to:
```
1\.0\.0\-beta
```
while `%VERSION%` expands to:
```
1.0.0-beta
```

#### -h
Show the help message.

#### -s source
Source file used as input. If `-d` is not given, this file is also used as the output (edited in place). If neither `-s` nor `-d` are given, preprocess reads from standard input and writes to standard output.

# License
pkgkit is licensed under the GNU General Public License v3.0.
