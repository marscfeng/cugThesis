%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) F. Cheng <marscfeng@ou.edu> 
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\ProvidesClass{cugthesis}[2018/06/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\newif\ifcug@singlesided \cug@singlesidedfalse
\DeclareOption{singlesided}{% enable single-sided printing
    \cug@singlesidedtrue%
}
\newif\ifcug@doublesided \cug@doublesidedfalse
\DeclareOption{doublesided}{% enable double-sided printing
    \cug@doublesidedtrue%
}
\newif\ifcug@printcopy \cug@printcopyfalse
\DeclareOption{printcopy}{% enable print copy layout
    \cug@doublesidedtrue% auto enable double-sided style
    \cug@printcopytrue%
}
%-
%-> Draft version info
%-
\newif\ifcug@versioninfo \cug@versioninfofalse
\DeclareOption{draftversion}{%
    \cug@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\ifcug@doublesided% if double-sided printing enabled
    \LoadClass[UTF8,a4paper,twoside,14pt,zihao=-4]{ctexbook}
\else% if double-sided printing isn't enabled
    \LoadClass[UTF8,a4paper,oneside,14pt,zihao=-4]{ctexbook}
\fi
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\newcommand{\cugifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\cugifstrbk}{\expandafter\ifblank\expandafter}% expansion control
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/cugthesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{150.mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifcug@printcopy% if print copy layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
%% set margin for notes to zero
\setlength{\marginparwidth}{0pt}% width of margin notes
\setlength{\marginparsep}{0pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{237mm}% 246.2 set required text height first
\setlength{\voffset}{-15.mm}% set vertical offset
% \setlength{\topmargin}{20pt}% vertical margin above header
\setlength{\headheight}{15pt}% header height
\setlength{\headsep}{5.0mm}% 17.5pt vertical margin between header and body text
\setlength{\footskip}{10mm}%29.5pt vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
% \setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
\setlength{\parskip}{0pt}
%- line spacing
% \setlength{\baselineskip}{20pt}
% \setlength{\lineskip}{20pt}
% \linespread{1.5}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex% use underline from xeCJKfntef
    \renewcommand{\CJKunderlinecolor}{\color[rgb]{0,0,0}}% set underline color
    \renewcommand{\uline}[1]{\CJKunderline{#1}}% unified name
\else% use underline from ulem
    \RequirePackage{ulem}%
\fi
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \uline{#2}}
\newcommand{\ulhshift}{-4em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
\def\cug@value@confidential{}
\newcommand{\confidential}[1]{\def\cug@value@confidential{#1}}
\def\cug@value@schoollogo{}
\newcommand{\schoollogo}[2]{\def\cug@value@schoollogo{\includegraphics[#1]{#2}}}
\def\cug@value@title{}
\def\cug@value@titlemark{}
\renewcommand{\title}[2][\cug@value@title]{%
    \def\cug@value@title{#2}
    %\def\cug@value@titlemark{\MakeUppercase{#1}}}
    \def\cug@value@titlemark{#1}}
\renewcommand{\@title}{\cug@value@titlemark}
\def\cug@value@author{}
\renewcommand{\author}[1]{\def\cug@value@author{#1}}
\def\cug@value@advisor{}
\newcommand{\advisor}[1]{\def\cug@value@advisor{#1}}
\def\cug@value@advisorsec{}
\newcommand{\advisorsec}[1]{\def\cug@value@advisorsec{#1}}
\def\cug@value@degree{}
\newcommand{\degree}[1]{\def\cug@value@degree{#1}}
\def\cug@value@degreetype{}
\newcommand{\degreetype}[1]{\def\cug@value@degreetype{#1}}
\def\cug@value@major{}
\newcommand{\major}[1]{\def\cug@value@major{#1}}
\def\cug@value@institute{}
\newcommand{\institute}[1]{\def\cug@value@institute{#1}}
\def\cug@value@chinesedate{}
\newcommand{\chinesedate}[1]{\def\cug@value@chinesedate{#1}}
\def\cug@value@schoolcode{}
\newcommand{\schoolcode}[1]{\def\cug@value@schoolcode{#1}}
\def\cug@value@studentid{}
\newcommand{\studentid}[1]{\def\cug@value@studentid{#1}}
%-
%-> Redefine Chinese style
%-
\renewcommand{\maketitle}{%
    \cugifstreq{\cug@value@englishdegree}{Bachelor}{%
        \def\cug@label@thesis{\cug@label@bacthesis}%
        \def\cug@label@major{\cug@label@ungradmajor}%
        \def\cug@label@institute{\cug@label@ungradinstitute}%
    }{%
    \cugifstreq{\cug@value@englishdegree}{Master}{%
        \def\cug@label@thesis{\cug@label@masthesis}%
        \def\cug@label@major{\cug@label@gradmajor}%
        \def\cug@label@institute{\cug@label@gradinstitute}%
    }{%
        \def\cug@label@thesis{\cug@label@docthesis}%
        \def\cug@label@major{\cug@label@gradmajor}%
        \def\cug@label@institute{\cug@label@gradinstitute}%
    }}%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \vspace*{40pt}
        \zihao{3}

        {\cug@label@schoolcode \cug@value@schoolcode} \hfill{} {\cug@label@studentid \cug@value@studentid}

        \vspace*{20pt}

        {\zihao{1}\bfseries {\cug@label@school \\ \vspace*{18pt} \cug@label@thesis}}

        \vspace*{45pt}

        {\zihao{2}\bfseries\sffamily {\ \cug@value@title\ }}

        \vspace*{70pt}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.7}
        \begin{tabular}{ll}
            \cug@label@author & {\hspace{1\ccwd}{\cug@value@author}}\\
            \cug@label@major & {\hspace{1\ccwd}{\cug@value@major}}\\
            \cug@label@advisor & {\hspace{1\ccwd}{\cug@value@advisor}}\\
            \ifx\cug@value@advisorsec\@empty\else
                                & {\hspace{1\ccwd}{\cug@value@advisorsec}}\\\fi
            \cug@label@institute & {\hspace{1\ccwd}{\cug@value@institute}}\\
        \end{tabular}

        \vspace*{100pt}

        {\cug@value@chinesedate}

        % \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifcug@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifcug@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
}
%-
%-> English item commands
%-
\def\cug@value@englishtitle{}
\newcommand{\englishtitle}[1]{\def\cug@value@englishtitle{#1}}
\def\cug@value@englishauthor{}
\newcommand{\englishauthor}[1]{\def\cug@value@englishauthor{#1}}
\def\cug@value@englishadvisor{}
\newcommand{\englishadvisor}[1]{\def\cug@value@englishadvisor{#1}}
\def\cug@value@englishdegree{}
\newcommand{\englishdegree}[1]{\edef\cug@value@englishdegree{\zap@space#1 \@empty}}% expand and remove space
\def\cug@value@englishdegreetype{}
\newcommand{\englishdegreetype}[1]{\def\cug@value@englishdegreetype{#1}}
\def\cug@value@englishthesistype{}
\newcommand{\englishthesistype}[1]{\def\cug@value@englishthesistype{#1}}
% \def\cug@value@englishmajor{}
\newcommand{\englishmajor}[1]{\def\cug@value@englishmajor{#1}}
% \def\cug@value@englishinstitute{}
\newcommand{\englishinstitute}[1]{\def\cug@value@englishinstitute{#1}}
\def\cug@value@englishdate{}
\newcommand{\englishdate}[1]{\def\cug@value@englishdate{#1}}
%-
%-> Redefine English style
%-
\newcommand{\makeenglishtitle}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.5}
        \zihao{3}

        \vspace*{50pt}

        {\cug@label@englishstatement}

        \vspace*{\stretch{3}}

        {\zihao{2}\bfseries {\ \cug@value@englishtitle\ }}

        \vspace*{\stretch{1}}
        \def\tabcolsep{1pt}
        \def\arraystretch{1.2}
        \hskip -15pt
        \begin{tabular}{rl}
          \cug@label@englishauthor & {\hspace{1.5\ccwd}\cug@value@englishauthor} \\
          \cug@label@englishmajor & {\hspace{1.5\ccwd}\cug@value@englishmajor} \\
          \cug@label@englishadvisor & {\hspace{1.5\ccwd}\cug@value@englishadvisor}
        \end{tabular}

        \vspace*{\stretch{5.5}}

        {\cug@value@englishinstitute}

        \vspace*{\stretch{1.5}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> Author's declaration
%---------------------------------------------------------------------------%
\newcommand{\makedeclaration}{
    % author declaration
    \cleardoublepage
    \thispagestyle{empty}
    \linespread{2.0}
    \zihao{4}

    \vspace*{0.5ex}

    \begin{center}
        {\zihao{3}\bfseries\sffamily \cug@value@declare@create}
    \end{center}
    \vspace*{1.5ex}
    {\cug@value@declare@creativity}

    \vspace*{3ex}

    \linespread{1.0}
    \begin{flushright}
        \cug@value@declare@s \ulenhance[1.2pt]{\ulextend[100pt]}
        \vskip0.6cm
        \cug@value@declare@d {\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日}
    \end{flushright}

    \vspace*{3ex}

    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi

    % teacher declaration
    \cleardoublepage
    \thispagestyle{empty}
    \linespread{2.0}
    \zihao{4}

    \vspace*{0.5ex}

    \begin{center}
        {\zihao{3}\bfseries\sffamily \cug@value@declare@teachdeclar}
    \end{center}
    \vspace*{1.5ex}
    {\cug@value@declare@teachdeclaration}

    \vspace*{3ex}

    \linespread{1.0}
    \begin{flushright}
        \cug@value@declare@t \ulenhance[1.2pt]{\ulextend[105pt]}
        \vskip0.6cm
        \cug@value@declare@d {\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日}
    \end{flushright}

    \vspace*{3ex}

    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi

    % rights declaration
    \cleardoublepage
    \thispagestyle{empty}
    \linespread{2.0}
    \zihao{4}

    \vspace*{0.5ex}

    \begin{center}
        {\zihao{3}\bfseries\sffamily \cug@value@declare@right}
    \end{center}
    \vspace*{1.5ex}
    {\cug@value@declare@rights}


    \vspace*{3ex}

    \linespread{1.0}
    \begin{flushright}
        \cug@value@declare@s \ulenhance[1.2pt]{\ulextend[100pt]}
        \vskip0.6cm
        \cug@value@declare@d {\hspace{4\ccwd}年\hspace{2\ccwd}月\hspace{2\ccwd}日}
    \end{flushright}

    \vspace*{3ex}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> New environments
%---------------------------------------------------------------------------%
%- define CV sections
\newcommand{\cvsubsection}[1]{%
    \vspace{14pt}
    \noindent {\linespread{1.0} \zihao{4} \bfseries \sffamily #1}\\[14pt]
    % \vspace{14pt}
    }

%- define chinese keywords
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \cug@label@keywords} #1}
%- define engish keywords
\newcommand{\englishkeywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \cug@label@englishkeywords} #1}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- define spacing and length
\def\@dotsep{1.5mu}% spacing for dots
\def\@pnumwidth{2em}% spacing between titles and page numbers
\def\@tocrmarg{2em}% right margin indentation
\def\@chaptervspace{1ex}% spacing between chapter titles
%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
%---------------------------------------------------------------------------%
\def\hlinewd#1{%
  \noalign{\ifnum0=`}\fi\hrule \@height #1 \futurelet
   \reserved@a\@xhline}
%---------------------------------------------------------------------------%

\endinput

