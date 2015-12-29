% guitarsongbook.sty
% Songbooks with guitar chords, based on the songs package
% Philipp Gabler, 2015
\ProvidesClass{guitarsongbook}[2015/12/27 v1.0 Songbooks with guitar chords]
\NeedsTeXFormat{LaTeX2e}

\RequirePackage{pgfkeys}
\RequirePackage{pgfopts}

\RequirePackage{ifthen}
\newcommand{\@initboolean}[2]{\newboolean{#1}\setboolean{#1}{#2}}

\@initboolean{gsb@a4paper}{true}
\@initboolean{gsb@print}{false}
\@initboolean{gsb@authorindex}{true}

\newif\ifgsb@authorindex

\pgfkeys{
  /gsb/options/.cd,
  size/.is choice,
  size/a4/.code=\setboolean{gsb@a4paper}{true},
  size/a5/.code=\setboolean{gsb@a4paper}{false},
  size=a4,
  type/.is choice,
  type/print/.code=\setboolean{gsb@print}{true},
  type/screen/.code=\setboolean{gsb@print}{false},
  type=screen,
  printa4/.style={size=a4, type=print},
  printa5/.style={size=a5, type=print},
  screena4/.style={size=a4, type=screen},
  screena5/.style={size=a5, type=screen},
  %% /secret/.code={%
  %%   \RequirePackage{draftwatermark}
  %%   \SetWatermarkFontSize{3cm}
  %%   \SetWatermarkAngle{55}
  %%   \SetWatermarkText{NICHT WEITERGEBEN!}},
  authorindex/.is if=gsb@authorindex
  %/authorindex=true
}


\ProcessPgfOptions{/gsb/options}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PACKAGES AND SETTINGS

% print-A4
\ifthenelse{\boolean{gsb@a4paper} \AND \boolean{gsb@print}}{
  \LoadClass[a4paper, twoside, 10pt]{memoir}
  \RequirePackage[chorded]{songs}
  \RequirePackage[bookmarks, hidelinks]{hyperref}

  \setbinding{0.5cm}
  \setlrmarginsandblock{21mm}{*}{2}
  \setulmarginsandblock{20mm}{*}{1}

  % customize look of chord symbols
  \renewcommand{\printchord}[1]{\sffamily\scshape\bfseries#1}
}{}

% sceen-A4
\ifthenelse{\boolean{gsb@a4paper} \AND \(\NOT \boolean{gsb@print}\)}{
  \LoadClass[a4paper, oneside, 10pt]{memoir}
  \RequirePackage[chorded]{songs}
  \RequirePackage{hyperref}

  \setlrmarginsandblock{*}{21mm}{1}
  \setulmarginsandblock{*}{29.7mm}{1}

  \renewcommand{\printchord}[1]{\sffamily\scshape\bfseries#1}
}{}

% print-A5
\ifthenelse{\(\NOT \boolean{gsb@a4paper}\) \AND \boolean{gsb@print}}{
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
}{}

% screen-A5
\ifthenelse{\(\NOT \boolean{gsb@a4paper}\) \AND \(\NOT \boolean{gsb@print}\)}{
  \PackageError{guitarsongbook}{Option `printa5' not yet implemented}{}
}{}


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

% always provide default memoization registers
\newchords{verse}
\newchords{chorus}

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
  \typeout{FALSE}
  \gdef\makeauthorindex{}
  \let\@oldbeginsongs\songs
  \let\@oldendsongs\endsongs
  \renewenvironment{songs}{\@oldbeginsongs{titleidx}}{\@oldendsongs}
\fi


%% % helper commands
%% \newcommand{\verseskip}{\par\vspace{0.5\baselineskip}}
%% \newcommand{\chordcorrection}{\vspace{-0.5\baselineskip}\brk}
%% \newcommand{\chord}[1]{\textsc{\textbf{#1}}}

%\endinput
