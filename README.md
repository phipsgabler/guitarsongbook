# Guitarsongbook #

This document class is a wrapper above the [`songs` package](http://songs.sourceforge.net/) for setting song books.  It basically extends some existing commands from there and provides some "combinators" for setting things I often use, like instrumental solos, and mainly intended to be used to set songs with chords for guitar.

Furthermore, it uses memoir to do some typographic improvements and relieves you from loading all packages "by hand".

For specific information, have a look at the [examples directory](./examples), or better yet, [the source](./guitarsongbook.cls).


## Usage ##

As familiar as possible, if you're already used to the `songs` package:

```latex
\documentclass{guitarsongbook}

\begin{document}

\begin{songs}
\begin{song}{Knocking on heaven's door}

\begin{chorus}
\[G] Knock knock \[D]knockin' on heavens \[Am]door
\[G] Knock knock \[D]knockin' on heavens \[C]door\ldots
\end{chorus}

\end{song}
\end{songs}

\end{document}
```

It's just that everything should be easier ;)  For more detailed examples, see [examples](./examples).


## Installation ##

This is not a package really requiring installation or so; it's not on CTAN.  Just put it besides your actual document, or [somewhere where TeX can find it](http://tex.stackexchange.com/questions/1137/where-do-i-place-my-own-sty-or-cls-files-to-make-them-available-to-all-my-te).  Obviously, it is required that you have the `songs` package installed or lying around; additionally, you might want to get a binary of the `songidx` program to compile index files (usually, this should be bundled with the `songs` installation).


# License #

Since I use and modify the songs package with this, which is licenced under the GPL, this software is also covered under version 2.0 of the GNU General Public License.  A copy of the license is provided online at the [Free Software Foundation website](http://www.gnu.org/licenses/old-licenses/gpl-2.0.html).
