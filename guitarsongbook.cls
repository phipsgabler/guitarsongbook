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
\newif\ifgsb@thumbindex
\newif\ifgsb@showframe

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
  bcor/.code={\pgfkeyssetvalue{/gsb/options/bcor}{#1}},
  fontsize/.code={\pgfkeyssetvalue{/gsb/options/fontsize}{#1}},
  thumbindex/.is if=gsb@thumbindex,
  thumbindex=false,
  showframe/.is if=gsb@showframe,
  showframe=false
}

\ProcessPgfOptions{/gsb/options}

\newcommand{\pgf@getordefault}[2]{\pgfkeysifdefined{#1}{\pgfkeysvalueof{#1}}{#2}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PACKAGES AND SETTINGS

\ifgsb@isafour%
  \ifgsb@isprint% % print-A4
    \typeout{printa4}

    \PassOptionsToClass{\pgf@getordefault{/gsb/options/fontsize}{10pt}}{memoir}
    \LoadClass[a4paper, twoside]{memoir}

    \RequirePackage[pdftex]{xcolor}
    \RequirePackage[chorded]{songs}
    \RequirePackage[hidelinks]{hyperref}

    \pgfkeysifdefined{/gsb/options/bcor}{%
      \setbinding{\pgfkeysvalueof{/gsb/options/bcor}}
    }{}

    % this is an adaption of the ISO layout from Bringhurst, p. 175
    \setlrmarginsandblock{19.1mm}{*}{2}
    \setulmarginsandblock{19.1mm}{*}{2}
    \setmarginnotes{1em}{19.1mm}{1em}
    
    % customize look of chord symbols
    \renewcommand{\printchord}[1]{\sffamily\scshape\bfseries#1}
  \else% % sceen-A4: intended for desktop reading
    \typeout{screena4}

    \PassOptionsToClass{\pgf@getordefault{/gsb/options/fontsize}{10pt}}{memoir}
    \LoadClass[a4paper, oneside]{memoir}

    \RequirePackage[pdftex]{xcolor}
    \RequirePackage[chorded]{songs}
    \RequirePackage{hyperref}
    
    \pgfkeysifdefined{/gsb/options/bcor}{%
      \setbinding{\pgfkeysvalueof{/gsb/options/bcor}}
    }{}

    % this is an adaption of the ISO layout from Bringhurst, p. 175
    \setlrmarginsandblock{28.5mm}{*}{1}
    \setulmarginsandblock{19.1mm}{*}{2}
    \setmarginnotes{1em}{19.1mm}{1em}

    \renewcommand{\printchord}[1]{\sffamily\scshape\bfseries#1}
  \fi%
\else%
  \ifgsb@isprint% % print-A5
    \typeout{printa5}

    \PassOptionsToClass{\pgf@getordefault{/gsb/options/fontsize}{10pt}}{memoir}
    \LoadClass[a5paper, twoside]{memoir}

    \RequirePackage[pdftex]{xcolor}
    \RequirePackage[chorded, onesongcolumn]{songs}
    \RequirePackage[hidelinks]{hyperref}

    \pgfkeysifdefined{/gsb/options/bcor}{%
      \setbinding{\pgfkeysvalueof{/gsb/options/bcor}}
    }{}
    \setlrmarginsandblock{15mm}{*}{2}
    \setulmarginsandblock{15mm}{*}{1.3}

    % adapt size of chord symbols
    \renewcommand{\printchord}[1]{\small\sffamily\scshape\bfseries#1}

    % decrease size of text/musicnotes
    \renewcommand{\notefont}{\footnotesize}
  \else% % screen-A5: intended for mobile reading
    \typeout{screena5}

    \PassOptionsToClass{\pgf@getordefault{/gsb/options/fontsize}{12pt}}{memoir}
    \LoadClass[a5paper, oneside]{memoir}

    \RequirePackage[pdftex]{xcolor}
    \RequirePackage[chorded, onesongcolumn]{songs}
    \RequirePackage{hyperref}

    \pgfkeysifdefined{/gsb/options/bcor}{%
      \setbinding{\pgfkeysvalueof{/gsb/options/bcor}}
    }{}
    \setlrmarginsandblock{*}{15mm}{1}
    \setulmarginsandblock{*}{15mm}{1}

    % adapt size of chord symbols
    \renewcommand{\printchord}[1]{\small\sffamily\scshape\bfseries#1}

    % decrease size of text/musicnotes
    \renewcommand{\notefont}{\footnotesize}
  \fi%
\fi%



% other packages
\RequirePackage[type1,sflf]{libertine} % change to a nicer font
\RequirePackage{amsmath}               % some special symbols are needed
\RequirePackage{everypage}             % needed to separate thumb indices from page styles
\RequirePackage{tikz}                  % well, tikz...

\ifgsb@showframe
  \RequirePackage{showframe}
\fi

% global style changes
\renewcommand{\idxauthfont}{\idxtitlefont}
\renewcommand{\idxrefsfont}{\idxtitlefont}

\settowidth{\versenumwidth}{1.\ }
\pagestyle{plain}


\checkandfixthelayout % make memoir actually set layout

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMMANDS

% indexing
\pgfkeys{/gsb/titleindextitle/.initial=Liederverzeichnis}
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
  \pgfkeys{/gsb/authorindextitle/.initial=Interpretenverzeichnis}
  \newauthorindex{authidx}{authorindex} % create indexing by authors
  \indexsongsas{authidx}{\thepage} % same here...
  \gdef\makeauthorindex{\showindex{\pgfkeysvalueof{/gsb/authorindextitle}}{authidx}}
  \let\@oldbeginsongs\songs
  \let\@oldendsongs\endsongs
  \renewenvironment{songs}{%
    % here, we also enable thumb indexes
    \global\gsb@enablethumbstrue
    \@oldbeginsongs{titleidx,authidx}
  }{%
    \@oldendsongs
    \global\gsb@enablethumbsfalse
  }
\else%
  \gdef\makeauthorindex{}
  \let\@oldbeginsongs\songs
  \let\@oldendsongs\endsongs
  \renewenvironment{songs}{%
    \global\gsb@enablethumbstrue
    \@oldbeginsongs{titleidx}
  }{%
    \@oldendsongs
    \global\gsb@enablethumbsfalse
  }
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
% thumb index

% a shameless clone of fancytabs' command (http://www.ctan.org/pkg/fancytabs),
% with some customizations made
\ifgsb@isafour
  \newcommand{\gsb@tab@style}{\Large}
  \newlength{\gsb@tab@height}
  \settowidth{\gsb@tab@height}{\Large{100--100}}
  \addtolength{\gsb@tab@height}{1mm}
  \newlength{\gsb@tab@top}
  \setlength{\gsb@tab@top}{1.5\uppermargin}
\else
  \newcommand{\gsb@tab@style}{\normalsize}
  \newlength{\gsb@tab@height}
  \settowidth{\gsb@tab@height}{100--100}
  \addtolength{\gsb@tab@height}{1mm}
  \newlength{\gsb@tab@top}
  \setlength{\gsb@tab@top}{\uppermargin}
\fi
\newlength{\gsb@tab@width}
\setlength{\gsb@tab@width}{2em}
\newcommand{\gsb@tab@count}{15}
\newcommand{\gsb@tab@leftcolor}{white}
\newcommand{\gsb@tab@rightcolor}{gray!50}

% argument #1: text (displayed vertically)
% argument #2: position (offset from top)
\newcommand{\gsb@indextab}[2]{%
  \begin{tikzpicture}[remember picture,overlay]%
    \node[yshift={-1*(\the\gsb@tab@top
                     +\the\gsb@tab@height/2
                     +mod(#2-1,\gsb@tab@count)*\the\gsb@tab@height
                     )},
          xshift=-0.5*\the\gsb@tab@width]
      at (current page.north east) {
      \tikz\shade[shading=axis,bottom color=\gsb@tab@leftcolor,
                  top color=\gsb@tab@rightcolor,shading angle=-90]
        (0,0) rectangle (\the\gsb@tab@width,\the\gsb@tab@height)
          node[rotate=0]
            at (0.5*\the\gsb@tab@width,0.5*\the\gsb@tab@height)
            {\rotatebox{90}{\gsb@tab@style#1}};%
    };%
  \end{tikzpicture}%
}

\newif\ifgsb@enablethumbs
\gsb@enablethumbsfalse

% set up printing the index tab on every recto page, if required by the class argument.
% this is set up so that groups of the form (11-20) etc. are used.
\ifgsb@thumbindex
  \AddEverypageHook{
    \ifgsb@enablethumbs
      \checkoddpage
      \ifoddpage
        \pgfmathtruncatemacro{\@actualsongnum}{\thesongnum-1}
        \pgfmathtruncatemacro{\@currentsongrangebegin}{floor((\@actualsongnum-1)/10)*10+1}
        \pgfmathtruncatemacro{\@currentsongrangeend}{\@currentsongrangebegin+9}
        \gsb@indextab{\@currentsongrangebegin--\@currentsongrangeend}{floor(\@actualsongnum/10)}
      \fi
    \fi
  }
\fi
  

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
}

% repeat other stuff (eg. intros, solos)
\newcommand{\repeatstuff}[2][]{
  \def\param{#1}
  \ifx\param\@empty
    \musicnote{(#2)}
  \else
    \musicnote{(#2 \rep{#1})}
  \fi
  \lessspace
}

\endinput