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
\newif\ifgsb@bcorset
\newif\ifgsb@indexbypage

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
  authorindex=true,
  indexsongsas/.is choice,
  indexsongsas/page/.code=\gsb@indexbypagetrue,
  indexsongsas/number/.code=\gsb@indexbypagefalse,
  indexsongsas=number,
  @bcor/.initial=0.5mm, % necessary to separate value and code
  bcor/.code={\gsb@bcorsettrue\pgfkeyssetvalue{/gsb/options/@bcor}{#1}}
}

\ProcessPgfOptions{/gsb/options}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PACKAGES AND SETTINGS

\ifgsb@isafour%
  \ifgsb@isprint% % sceen-A4: intended for desktop reading
    \typeout{printa4}
    \LoadClass[a4paper, twoside, 10pt]{memoir}
    \RequirePackage[chorded]{songs}
    \RequirePackage[hidelinks]{hyperref}

    \setbinding{\pgfkeysvalueof{/gsb/options/@bcor}}
    \setlrmarginsandblock{21mm}{*}{2}
    \setulmarginsandblock{20mm}{*}{1}

    % customize look of chord symbols
    \renewcommand{\printchord}[1]{\sffamily\scshape\bfseries#1}
  \else% % sceen-A4
    \typeout{screena4}
    \LoadClass[a4paper, oneside, 10pt]{memoir}
    \RequirePackage[chorded]{songs}
    \RequirePackage{hyperref}

    % in screen mode, we can _override_ the bcor, but will not set it by default
    \ifgsb@bcorset\setbinding{\pgfkeysvalueof{/gsb/options/@bcor}}\fi
    \setlrmarginsandblock{*}{21mm}{1}
    \setulmarginsandblock{*}{29.7mm}{1}

    \renewcommand{\printchord}[1]{\sffamily\scshape\bfseries#1}
  \fi%
\else%
  \ifgsb@isprint% % print-A5
    \typeout{printa5}
    \LoadClass[a5paper, twoside, 11pt]{memoir}
    \RequirePackage[chorded, onesongcolumn]{songs}
    \RequirePackage[hidelinks]{hyperref}

    \setbinding{\pgfkeysvalueof{/gsb/options/@bcor}}
    \setheadfoot{0mm}{0cm}
    \setlrmarginsandblock{15mm}{*}{2}
    \setulmarginsandblock{10mm}{*}{1.3}

    % adapt size of chord symbols
    \renewcommand{\printchord}[1]{\small\sffamily\scshape\bfseries#1}

    % decrease size of text/musicnotes
    \renewcommand{\notefont}{\footnotesize}
  \else% % screen-A5: intended for mobile reading
    \typeout{screena5}
    %\PackageError{guitarsongbook}{screen-a5 is not yet implemented!}{Nothing you can do...}
    \LoadClass[a5paper, oneside, 11pt]{memoir}
    \RequirePackage[chorded, onesongcolumn]{songs}
    \RequirePackage{hyperref}

    %\setbinding{\pgfkeysvalueof{/gsb/options/@bcor}}
    \setheadfoot{0mm}{0cm}
    \setlrmarginsandblock{15mm}{*}{1}
    \setulmarginsandblock{10mm}{*}{1}

    % adapt size of chord symbols
    \renewcommand{\printchord}[1]{\small\sffamily\scshape\bfseries#1}

    % decrease size of text/musicnotes
    \renewcommand{\notefont}{\footnotesize}
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
\ifgsb@indexbypage
  \indexsongsas{titleidx}{\thepage} % reference songs by page, not number
\fi

\newcommand{\maketitleindex}{%
  \showindex{%
    \texorpdfstring{%
      \protect\hypertarget{gsb@titleindex}{\pgfkeysvalueof{/gsb/titleindextitle}}%
    }{%
      \pgfkeysvalueof{/gsb/titleindextitle}%
    }}{titleidx}
}

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

% reverse link to index from each song number
\let\gsb@oldprintsongnum\printsongnum
\renewcommand{\printsongnum}[1]{\hyperlink{gsb@titleindex}{\gsb@oldprintsongnum{#1}}}


% add ability to add setup code to each song
\def\gsb@songsetup{\@empty}
\def\gsb@addtosongsetup#1{
  \let\oldsongsetup=\gsb@songsetup
  \gdef\gsb@songsetup{\oldsongsetup #1}
}

\let\oldSB@@@beginsong=\SB@@@beginsong
\renewcommand{\SB@@@beginsong}{%
  \oldSB@@@beginsong
  \gsb@songsetup
}


% helper commands, easier definitions
\newcommand{\morespace}{\vspace{0.5\baselineskip}}
\newcommand{\verseskip}{\par\morespace}
\newcommand{\lessspace}{\vspace{-0.5\baselineskip}}
\newcommand{\chordcorrection}{\lessspace\brk}
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

\newif\ifgsb@firstchorus
\gsb@firstchorustrue
\newif\ifgsb@firstverse
\gsb@firstversetrue

\gsb@addtosongsetup{
  \global\gsb@firstchorustrue
  \global\gsb@firstversetrue
}



% The chorus environment gets an optional "header", and automatic
% replay of the chords of the first chorus
% automatically give default header to chorus, and memorize separately
\pgfkeys{/gsb/chorusheading/.initial={Refrain}}

\newcommand{\gsb@beginchorus}{%
  \@beginchorus%
  \ifgsb@firstchorus%
    \memorize[chorus]%
    \musicnote{\pgfkeysvalueof{/gsb/chorusheading}:}%
  \else%
    \replay[chorus]%
  \fi%
  \global\gsb@firstchorusfalse%
}
\long\def\gsb@namedchorus[#1]{%
  \@beginchorus%
  \ifgsb@firstchorus%
    \memorize[chorus]%
  \else%
    \replay[chorus]%
  \fi%
  \global\gsb@firstchorusfalse%
  \def\param{#1}
  \ifx\param\@empty\else\musicnote{#1}\fi%
}
% \renewcommand{\beginchorus}{%
%   \@ifnextchar[{%
%     \gsb@namedchorus%
%   }{%
%     \gsb@beginchorus%
%   }
% }
\renewenvironment{chorus}[1][]{%
  \def\param{#1}%
  \ifx\param\@empty%
    \gsb@beginchorus%
  \else%
    \gsb@namedchorus[#1]%
  \fi%
}{%
  \SB@endchorus
}


% Automatic memoization in verse environments:
% \renewcommand{\beginverse}{%
%   \begingroup%
%     \SB@loadactives%
%     \@ifstar{%
%       \endgroup\vnumberedfalse\SB@beginverse%
%     }{%
%       \endgroup\vnumberedtrue\SB@beginverse%
%     }%
% }
\renewenvironment{verse}[1][]{%
  \def\param{#1}%
  \vnumberedtrue\SB@beginverse%
  \ifgsb@firstverse%
    \memorize[verse]%
  \else%
    \replay[verse]%
  \fi%
  \global\gsb@firstversefalse%
  \ifx\param\@empty\else%
    \musicnote{#1}%
  \fi%
}{%
  \SB@endverse
}

\renewenvironment{verse*}[1][]{%
  \def\param{#1}%
  \vnumberedfalse\SB@beginverse%
  \ifx\param\@empty\else%
    \musicnote{#1}%
  \fi%
}{
  \SB@endverse
}


% Some convenience commands for common use cases:

% unnumbered verse, suited for putting tabs into it
\pgfkeys{/gsb/tabsheading/.initial={Verwendete Akkorde:}}
\newenvironment{tabs}{%
  \@beginverse*%
  \musicnote{\pgfkeysvalueof{/gsb/tabsheading}}%
  %\vspace{-0.3\baselineskip}
}{%
  \vspace{-0.3\baselineskip}
  \@endverse
}

% unnumbered verse, suited for putting only chords into it
\newenvironment{instrumental}[1]{%
  \def\param{#1}
  \@beginverse*
  \ifx\param\@empty\else\musicnote{#1}\fi
  \vspace{-0.1\baselineskip}
  \nolyrics
  \singlespacing
}{%
  \vspace{-0.3\baselineskip}
  \@endverse
}

% repeats with default chorus header
\newcommand{\repeatchorus}[1][]{
  \def\param{#1}
  \ifx\param\@empty
    \musicnote{(\pgfkeysvalueof{/gsb/chorusheading})}
  \else
    \musicnote{(\pgfkeysvalueof{/gsb/chorusheading} \rep{#1})}
  \fi
  \lessspace
  %\@endverse
}

\endinput