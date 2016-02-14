% guitarsongbook.sty
% Songbooks with guitar chords, based on the songs package
% Philipp Gabler, 2015

\ProvidesClass{guitarsongbook}[2015/12/27 v1.0 Songbooks with guitar chords]
\NeedsTeXFormat{LaTeX2e}

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\newif\ifgsb@authorindex
\newif\ifgsb@isafour
\newif\ifgsb@isprint

\pgfkeys{
  /gsb/options/.cd,
  size/.is choice,
  size/a4/.code=\gsb@isafourtrue,
  size/a5/.code=\gsb@isafourfalse,
  size=a4,
  type/.is choice,
  type/print/.code=\gsb@isprinttrue,
  type/screen/.code=\gsb@isprintfalse,
  type=screen,
  printa4/.style={size=a4, type=print},
  printa5/.style={size=a5, type=print},
  screena4/.style={size=a4, type=screen},
  screena5/.style={size=a5, type=screen},
  authorindex/.is if=gsb@authorindex,
  authorindex=true
}

\ProcessPgfOptions{/gsb/options}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PACKAGES AND SETTINGS

\ifgsb@isafour%
  \ifgsb@isprint% % sceen-A4
    \typeout{printa4}
    \LoadClass[a4paper, twoside, 10pt]{memoir}
    \RequirePackage[chorded]{songs}
    \RequirePackage[bookmarks, hidelinks]{hyperref}

    \setbinding{0.5cm}
    \setlrmarginsandblock{21mm}{*}{2}
    \setulmarginsandblock{20mm}{*}{1}

    % customize look of chord symbols
    \renewcommand{\printchord}[1]{\sffamily\scshape\bfseries#1}
  \else% % sceen-A4
    \typeout{screena4}
    \LoadClass[a4paper, oneside, 10pt]{memoir}
    \RequirePackage[chorded]{songs}
    \RequirePackage{hyperref}

    \setlrmarginsandblock{*}{21mm}{1}
    \setulmarginsandblock{*}{29.7mm}{1}

    \renewcommand{\printchord}[1]{\sffamily\scshape\bfseries#1}
  \fi%
\else%
  \ifgsb@isprint% % print-A5
    \typeout{printa5}
    \LoadClass[a5paper, twoside, 11pt]{memoir}
    \RequirePackage[chorded, onesongcolumn]{songs}
    \RequirePackage[bookmarks, hidelinks]{hyperref}

    \setbinding{5mm}
    \setheadfoot{0mm}{0cm}
    \setlrmarginsandblock{15mm}{*}{2}
    \setulmarginsandblock{10mm}{*}{1.3}

    % adapt size of chord symbols
    \renewcommand{\printchord}[1]{\small\sffamily\scshape\bfseries#1}

    % decrease size of text/musicnotes
    \renewcommand{\notefont}{\footnotesize}
  \else% % screen-A5
    \typeout{screena5}
    \PackageError{guitarsongbook}{Option `screena5' not yet implemented}{}
  \fi%
\fi%


% other packages
\RequirePackage[type1,sflf]{libertine} % change to a nicer font
\RequirePackage{amsmath}               % some special symbols are needed


% global style changes
\renewcommand{\idxauthfont}{\idxtitlefont}
\renewcommand{\idxrefsfont}{\idxtitlefont}

\settowidth{\versenumwidth}{1.\ }
\pagestyle{plain}


\checkandfixthelayout % make memoir actually set layout

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMMANDS

% indexing
\pgfkeys{/gsb/titleindextitle/.initial=Songs}
\newindex{titleidx}{songindex}
\indexsongsas{titleidx}{\thepage} % reference songs by page, not number
\newcommand{\maketitleindex}{\showindex{\pgfkeysvalueof{/gsb/titleindextitle}}{titleidx}}

\ifgsb@authorindex%
  \pgfkeys{/gsb/authorindextitle/.initial=Interpreten}
  \newauthorindex{authidx}{authorindex} % create indexing by authors
  \indexsongsas{authidx}{\thepage} % same here...
  \gdef\makeauthorindex{\showindex{\pgfkeysvalueof{/gsb/authorindextitle}}{authidx}}
  \let\@oldbeginsongs\songs
  \let\@oldendsongs\endsongs
  \renewenvironment{songs}{\@oldbeginsongs{titleidx,authidx}}{\@oldendsongs}
\else%
  \gdef\makeauthorindex{}
  \let\@oldbeginsongs\songs
  \let\@oldendsongs\endsongs
  \renewenvironment{songs}{\@oldbeginsongs{titleidx}}{\@oldendsongs}
\fi


% helper commands, easier definitions
\newcommand{\verseskip}{\par\vspace{0.5\baselineskip}}
\newcommand{\chordcorrection}{\vspace{-0.5\baselineskip}\brk}
\newcommand{\singlespacing}{%
  \let\@oldbaselineskip\baselineskip
  \setlength{\baselineskip}{0.6\@oldbaselineskip}
}

\newcommand{\chord}[1]{\textsc{\textbf{#1}}}
\newcommand{\chords}[1]{\nolyrics #1}


\newcommand{\lrepeat}{\ensuremath{\lVert:}}
\newcommand{\rrepeat}{\ensuremath{:\rVert}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modifications and extensions of verse and chord commands

% original top level (non-internal) definitions:
\let\@beginchorus\beginchorus
\let\@endchorus\endchorus
\let\@beginverse\beginverse
\let\@endverse\endverse

% we always provide default memoization registers
\newchords{verse}
\newchords{chorus}

% The chorus environment gets an optional "header", and automatic
% replay of the chords of the first chorus
\newcommand{\gsb@beginchorus}{\@beginchorus\replay[chorus]}
\long\def\gsb@namedchorus[#1]{%
  \gsb@beginchorus
  \musicnote{#1}
  \replay[chorus]
}
\renewcommand{\beginchorus}{%
  \@ifnextchar[{\gsb@namedchorus}{\gsb@beginchorus}
}
\renewenvironment{chorus}[1][]{%
  \def\param{#1}
  \ifx\param\@empty
    \gsb@beginchorus
  \else
    \gsb@namedchorus[#1]
  \fi
}{%
  \SB@endchorus
}

% Numbered verses are automatically memorized
\renewcommand{\beginverse}{%
  \begingroup%
    \SB@loadactives%
    \@ifstar{\endgroup\vnumberedfalse\SB@beginverse}%
            {\endgroup\vnumberedtrue\SB@beginverse\memorize}%
}
\renewenvironment{verse}[1][]{
  \def\param{#1}
  \vnumberedtrue\SB@beginverse\memorize
  \ifx\param\@empty\else
    \musicnote{#1}
  \fi
}{%
  \SB@endverse
}

\renewenvironment{verse*}[1][]{%
  \def\param{#1}
  \vnumberedfalse\SB@beginverse
  \ifx\param\@empty\else
    \musicnote{#1}
  \fi
}{
  \SB@endverse
}


% Some convenience commands for common use cases:

% automatically give default header to chorus, and memorize separately
\pgfkeys{/gsb/chorusheading/.initial={Refrain}}
\newcommand{\beginfirstchorus}{
  \gsb@beginchorus\memorize[chorus]
  \musicnote{\pgfkeysvalueof{/gsb/chorusheading}:}
}
\newenvironment{firstchorus}{\beginfirstchorus}{\@endchorus}

% unnumbered verse, suited for putting tabs into it
\pgfkeys{/gsb/tabsheading/.initial={Verwendete Akkorde:}}
\newenvironment{tabs}{%
  \@beginverse*
  \musicnote{\pgfkeysvalueof{/gsb/tabsheading}}
  %\vspace{-0.3\baselineskip}
}{%
  \vspace{-0.3\baselineskip}
  \@endverse
}

% unnumbered verse, suited for putting only chords into it
\newenvironment{instrumental}[1]{%
  \@beginverse*
  \musicnote{#1}
  \vspace{-0.1\baselineskip}
  \nolyrics
  \singlespacing
}{%
  \vspace{-0.3\baselineskip}
  \@endverse
}

% repeats with default chorus header
\newcommand{\repeatchorus}{
  \@beginverse*
  \musicnote{(\pgfkeysvalueof{/gsb/chorusheading})}
  \vspace{-0.4\baselineskip}
  \@endverse
}

\endinput
