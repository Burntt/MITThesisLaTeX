% MIT thesis class

% !TEX encoding = UTF-8 Unicode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  This file provides the mitthesis LaTeX class for formatting theses according to 
%%  MIT Libraries' requirements as of 2023.
%%
%%  This file's version and date:
	\def\versionno{1.05}
	\def\versiondate{2023/07/21\space}
%%
%%  Author: John H. Lienhard, V
%%          Department of Mechanical Engineering
%%          Massachusetts Institute of Technology
%%          Cambridge, MA 02139-4307 USA
%%
%%  This class is compatible with either pdfLaTeX or LuaTeX. 
%%
%%	Use an up-to-date LaTeX distribution: TeX Live 2023 or later is strongly recommended!
%%	All packages required by the class are in TeX Live and available on CTAN (https://ctan.org/). 
%%
%%
% =========================================================
%%
%% LICENSE:
%%
%% Copyright (c) 2023 John H. Lienhard
%%
%% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
%% associated documentation files (the "Software"), to deal in the Software without restriction, 
%% including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
%% and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
%% subject to the following conditions:
%%
%% The above copyright notice and this permission notice shall be included in all copies or 
%% substantial portions of the Software.
%%
%% The software is provided "as is", without warranty of any kind, express or implied, including but 
%% not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. 
%% In no event shall the authors or copyright holders be liable for any claim, damages or other liability, 
%% whether in an action of contract, tort or otherwise, arising from, out of or in connection with the 
%% software or the use or other dealings in the software.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mitthesis}[\versiondate MIT Thesis Template (JHL)]

\LoadClass[12pt]{report}% [twoside] option can be issued in the .tex file; point size must be set here.

\RequirePackage{etoolbox}% provides \ifblank, \patchcmd, \apptocmd, etc.
\RequirePackage{ifthen}  % provides \whiledo, etc.

\def\ClassName{mitthesis}

%%%%%%%%%%%%%  Some compatibility for older latex distributions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\providecommand\IfFormatAtLeastTF{\@ifl@t@r\fmtversion}% compare version to date
\providecommand\IfPackageAtLeastTF{\@ifpackagelater}%    compare version to date

\ifdefined\NewDocumentCommand\else
  \RequirePackage{xparse}% enable pre-10/2020 formats to access essential macros later moved into LaTeX kernel
\fi

\IfFormatAtLeastTF{2020/02/25}{%
	\typeout{^^JYour LaTeX format is dated \fmtversion. LaTeX distributions from 2022/11/01 or later are strongly recommended for best results^^J}
	}{%
	\ClassError{\ClassName}{Your LaTeX format is dated \fmtversion.  Formats dated 2022/11/01 or later are recommended for this class. Older formats may generate errors}{Please UPDATE your LaTeX distribution to obtain best results. TeX Live is available for download at no charge: \string https://www.tug.org/texlive/.  You can try to click past the errors for now...}%
}

\IfFileExists{iftex.sty}{%
	\RequirePackage{iftex}% check whether pdftex or another engine is used
	}{%
        \ClassWarning{\ClassName}{This class requires the missing package iftex.sty---trying a work-around.}
    	% Code copied from iftex package written by the LaTeX3 Project (used under LPPL).
        % \csname and \let construct useful for hiding \ifzzz tokens from outer level \if tests.
        \def\IFTEX@let#1#2{%
          \expandafter\let\csname if#1\expandafter\endcsname
          \csname if#2\endcsname}
        % pdftex (including in dvi mode)
        \begingroup\expandafter\expandafter\expandafter\endgroup
        \expandafter\ifx\csname pdftexversion\endcsname\relax
          \IFTEX@let{pdftex}{false}
        \else
          \IFTEX@let{pdftex}{true}
        \fi
        \IFTEX@let{PDFTeX}{pdftex}
	}

% check whether pdfmanagement (\DocumentMetadata) has been loaded (to fallback on hyperxmp)
\newif\ifmit@pdfmanagement
% As of 2021/07/23 we could instead do:\IfPDFManagementActiveTF{\mit@pdfmanagementtrue}{\mit@pdfmanagementfalse}
\ExplSyntaxOn
    \IfFormatAtLeastTF{2020/02/25}{%
        \bool_if:nTF
          {
            \bool_lazy_and_p:nn
              {\cs_if_exist_p:N \pdfmanagement_if_active_p:}
              { \pdfmanagement_if_active_p: }
          }
          {
            \mit@pdfmanagementtrue
          }
          {
            \mit@pdfmanagementfalse
          }
     }{\mit@pdfmanagementfalse}
\ExplSyntaxOff

%% Old installations may want textcomp load, but we only require copyright character:
\ifdefined\textcopyright\else %\def\textcopyright{©}\fi. % 2023/06/26
    \ifpdftex
    	\DeclareTextSymbol{\textcopyright}{TS1}{'251}
    	\DeclareTextSymbolDefault{\textcopyright}{TS1}
    \else
    	\newcommand*\textcopyright{\Uchar"00A9}
    \fi
\fi

%%%%%%%%%%%%%% Options for the class %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\IfFormatAtLeastTF{2022/11/01}{%
%	\typeout{^^JUsing native keyvalue support^^J}% diagnostic info
    \DeclareKeys{
    	fontset .store 	= \mit@fontset ,
    	fontset .usage 	= load ,
		lineno  .if		= mit@lineno ,
		lineno 	.usage	= load ,
		mydesign .if	= mit@mydesign,
		mydesign .usage	= load ,
    } 
    \SetKeys[\ClassName]{fontset=defaultfonts}%
	\DeclareUnknownKeyHandler[\ClassName]{\relax}% suppress warning about unused keys
	\ProcessKeyOptions
}{%        
    \RequirePackage{kvoptions}
    \SetupKeyvalOptions{
      family=\ClassName,
      prefix=mit@,
      setkeys=\kvsetkeys,
    }
    % set key [fontset] for font selection
    \DeclareStringOption[defaultfonts]{fontset}[]% fixed 2023/06/26
    %
    \ProcessKeyvalOptions{\ClassName}
    %
    %% Turn off these keys now that we're done with them
    \def\@KeyFamily{\ClassName}
    \NewDocumentCommand\mit@DisableOption{m}{%
      \DisableKeyvalOption[%
        action=ignore,%
        class=\ClassName%
      ]{#1}{\@KeyFamily}%
    }
    \NewDocumentCommand\@DisableKeys{>{\SplitList{;}}m}{\ProcessList{#1}{\mit@DisableOption}}
    %
    \@DisableKeys{fontset;}%


    %%%%%%%%  more options  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% option to obtain line numbers [lineno] 
    \newif\ifmit@lineno\mit@linenofalse
    \DeclareOption{lineno}{\mit@linenotrue}
    
    %%% option for to load packages that customize the design [mydesign]  (caption, subcaption, titlesec, itemenum)
    \newif\ifmit@mydesign\mit@mydesignfalse
    \DeclareOption{mydesign}{\mit@mydesigntrue}
    
    %% Suppress warnings about unused global options
    \DeclareOption*{}
    
    \ProcessOptions \relax
}

%%%%%%%%%%%%%  Line numbering (class option)  %%%%%%%%%%%%%%%%%%%%%%%%%

%%% Adjustments when lineno option is used
\ifmit@lineno
    \RequirePackage[mathlines]{lineno}    
    \renewcommand{\linenumberfont}{\normalfont\footnotesize\color{red}} 
    \AtBeginDocument{\linenumbers}
\fi

%%% Enable dropping lineno option without trashing .aux file
\providecommand{\@LN@col}[1]{\relax}
\providecommand{\@LN}[2]{\relax}

%%%%%%%%%%%%%  Patch table of contents, list of figures, and list of tables  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We'd like these to have pdf bookmarks and to have the lists appear in the table of contents

\pretocmd{\tableofcontents}{\pdfbookmark[0]{Table of Contents}{toc}}{}{}
\apptocmd{\tableofcontents}{\cleardoublepage}{}{}
\pretocmd{\listoffigures}{\phantomsection}{}{}
\patchcmd{\listoffigures}{\chapter*{\listfigurename}}{\chapter*{\listfigurename}\addcontentsline{toc}{chapter}{\protect\textbf{\listfigurename}}}{}{}
\apptocmd{\listoffigures}{\cleardoublepage}{}{}
\pretocmd{\listoftables}{\phantomsection}{}{}
\patchcmd{\listoftables}{\chapter*{\listtablename}}{\chapter*{\listtablename}\addcontentsline{toc}{chapter}{\protect\textbf{\listtablename}}}{}{}
\apptocmd{\listoftables}{\cleardoublepage}{}{}


%%%%%%%%%%%%%  Geometry, mathtools, design, graphics, bibliography, hyperrefs, bookmarks %%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[letterpaper,top=1in,bottom=1in,left=1in,right=1in,marginparwidth=50pt,headsep=12pt,footskip=0.5in]{geometry}

\RequirePackage{mathtools}% loads and extends amsmath; must load before hyperref and unicode-math
%
% To free \eqref from the normal font (i.e., for use section headings)
\renewcommand{\eqref}[1]{\textup{\hbox{\m@th{(\ignorespaces\ref{#1}\unskip\@@italiccorr)}}}}
%
% amsmath def:  \newcommand{\eqref}[1]{\textup{\tagform@{\ref{#1}}}}
%				\def\tagform@#1{\maketag@@@{(\ignorespaces#1\unskip\@@italiccorr)}}
%				\def\maketag@@@#1{\hbox{\m@th\normalfont#1}}

% the packages in mydesign should come before babel (which may be loaded by fontset) and before hyperref
\ifmit@mydesign
	\IfFileExists{mydesign.tex}{\input{mydesign.tex}}{%
	\ClassError{\ClassName}{Missing file mydesign.tex. This file is necessary when using the class option [mydesign] }{%
			You have called the class option mydesign, but the file mydesign.tex is not found.  You can download a copy of that file from
			https://ctan.org/tex-archive/macros/latex/contrib/mitthesis/MIT-thesis-template.}%  
	}%
\else
	% options for xcolor
	\ifpdftex
		\def\MyColorOption{fixpdftex}\else
		\ifluatex\def\MyColorOption{luatex}\else
			\ifxetex\def\MyColorOption{xetex}\else
				\def\MyColorOption{}
			\fi
		\fi
	\fi
	\RequirePackage[hyperref,\MyColorOption,dvipsnames,svgnames,x11names]{xcolor}
%
	\RequirePackage{caption,subcaption}
%
    \RequirePackage{titlesec}    
    % these titlesec commands just automate the bold math in some headings (rest follows default styles)
    \titleformat{\section}{\mathversion{bold}\normalfont\Large\bfseries}{\thesection }{1em}{}
    \titleformat{\subsection}{\mathversion{bold}\normalfont\large\bfseries}{\thesubsection}{1em}{}
    \titleformat{\subsubsection}{\mathversion{bold}\normalfont\normalsize\bfseries}{\thesubsubsection}{1em}{}    
    % ==> NOT every font includes a bold math version, so you may need to use other math macros in the headings to get bold math <==   	
\fi

%% Font loading
\typeout{^^JFontset key is \mit@fontset.^^J}
\IfFileExists{fontsets/\ClassName-\mit@fontset.tex}{% 2023/07/03
	\input{fontsets/\ClassName-\mit@fontset.tex}
}{%
	\ClassWarning{\ClassName}{^^JFontset file \ClassName-\mit@fontset.tex not found, using default fonts.}
	\ifpdftex
    	\typeout{^^JLoading Computer Modern text and math fonts (default for pdftex).^^J}
    	\RequirePackage[T1]{fontenc}
    	\RequirePackage{bm}
    \else
    	\typeout{^^JLoading Latin Modern text and math fonts (default for unicode engines).^^J}
        \RequirePackage[warnings-off={mathtools-colon,mathtools-overbracket}]{unicode-math}
        % suppress tiresome warnings about lack of integration between mathtools and unicode-math.
        % Unicode-math loads fontspec package, but default fonts are not selected by fontspec in this case.
    \fi
}

\RequirePackage{graphicx} 

\ifmit@pdfmanagement
	\ClassInfo{\ClassName}{pdfmanagement is defined. Will not load hyperxmp}%
\else
    \ClassInfo{\ClassName}{pdfmanagement is not defined. Will load hyperxmp}%
    \RequirePackage{hyperxmp}
\fi

\RequirePackage[psdextra]{hyperref}
% the new pdf-management scheme loads the bookmarks package internally.
% authors should use hypersetup to set details, in root .tex file

\urlstyle{same} 		% this changes font for \url to the current text font
\providecommand\hrefurl[2]{\href{#1}{#2}}% in case new pdf management has not been loaded
\RequirePackage{doi} 	% create macro for hyperlinking doi numbers

% Directly add the xmp property that shows work is copyrighted. See l3pdfmeta.pdf. 
% This is not automatic with \DocumentMetadata. "True" must be capitalized. 
\ExplSyntaxOn
	  \cs_if_exist:NTF \pdfmeta_xmp_add:n {\pdfmeta_xmp_add:n{<xmpRights:Marked>True</xmpRights:Marked>}}{}
\ExplSyntaxOff

		
%%%%%%%%%%%%% Stuff related to PDF bookmarks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Since \bm may be useful in headings, this fix will reduce frequency with which
%%%    alternate pdfstrings must be given in revised section command as \section[pdfstring]{texstring}
\pdfstringdefDisableCommands{%
    \def\bm#1#{\relax}%
}
%
%%% Let's disable \( and \) in pdf bookmarks
\pdfstringdefDisableCommands{%
    \def\({\relax}%
    \def\){\relax}%
}
%
%%% Let's also make sure \NoCaseChange in section headings won't break pdf bookmarks
\pdfstringdefDisableCommands{%
      \let\NoCaseChange\relax%
}
%
%%% Let's just remove citations from pdf bookmarks
\pdfstringdefDisableCommands{%
    \def\cite{\@gobble}%
}
%
%%% Let's fix \eqref in pdf bookmarks
\pdfstringdefDisableCommands{%
    \def\eqref#1{(\ref{#1})}%
%
%%% Let's make sure footnotes in section headings don't break pdf bookmarks.
\robustify{\footnote}
% \patchcmd{\section}{\sectionmark}{\let\footnote\@gobble\sectionmark}{}{}% <== not needed unless you implement running heads
\pdfstringdefDisableCommands{%
  \def\footnote#1{}%
}
}

%%% Let's have commas separate successive footnotes
\let\oldfootnote\footnote
\renewcommand\footnote[1]{%
    \oldfootnote{#1}\futurelet\nextToken\isOtherfnote}
    
\newcommand\isOtherfnote{%
    \ifx\footnote\nextToken\textsuperscript{\mdseries,}%
    \fi%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%  MACROS FOR HANDLING TITLE AND ABSTRACT PAGES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%  Dates  %%%%%%%%%%%%%%%

\ExplSyntaxOn
\NewExpandableDocumentCommand\MonthCheck{mm}{%
	\str_case_e:nnF {#1}{ {May}{} {June}{} {September}{} {February}{}
	 {\space May}{} {\space June}{} {\space September}{} {\space February}{}
	 {May\space}{} {June\space}{} {September\space}{} { February\space}{}
	 {\space May\space}{} {\space June\space}{} {\space September\space}{} {\space February\space}{}
	 }{#2} 
}
\ExplSyntaxOff

\NewDocumentCommand\DegreeDate{mm}{%
	\def\@DegreeMonth{\ignorespaces#1}%
	\def\@@DegreeMonth{#1}%	
	\def\@DegreeYear{\ignorespaces#2}%
	\def\DegreeYear{\ignorespaces#2}%
}

\NewDocumentCommand\ThesisDate{m}{%
	\def\@ThesisDate{\ignorespaces#1}%
}

%%%%%%%%%%%%%%  Author, supervisor, acceptor, titles, and departments  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{authorcnt}
\setcounter{authorcnt}{0}% this counter's final value is used repeatedly.
  
\NewDocumentCommand\Author{m m oooo}{%
	\ifblank{#1}{%
		\ClassError{\ClassName}{Missing author name, check for blank in Author command}{%
			You MUST provide an author name using the \Author{name}{department} command.}%
		}{%
		\addtocounter{authorcnt}{1}%			
		\expandafter\xdef\csname aut@\theauthorcnt\endcsname{\ignorespaces#1}%
		\expandafter\xdef\csname autdep@\theauthorcnt\endcsname{\ignorespaces#2}%
		\IfNoValueF{#3}{\expandafter\xdef\csname prevdegree@\theauthorcnt\endcsname{\ignorespaces#3}}%
		\IfNoValueF{#4}{\expandafter\xdef\csname secondprevdegree@\theauthorcnt\endcsname{\ignorespaces#4}}%
		\IfNoValueF{#5}{\expandafter\xdef\csname thirdprevdegree@\theauthorcnt\endcsname{\ignorespaces#5}}%
		\IfNoValueF{#6}{\expandafter\xdef\csname fourthprevdegree@\theauthorcnt\endcsname{\ignorespaces#6}}% 
	}%
	\ifblank{#2}{\ClassWarning{\ClassName}{Missing author department, check for blank in Author command}}{}%
}% defines \aut@authorcnt as Name #1 and \autdep@authorcnt as Name #1's department

\newcounter{authorno}
\setcounter{authorno}{0}

\NewDocumentCommand\@AuthorBlock{}{% Revised 2023/06/23
	\setcounter{authorno}{1}% 
	\ifnum\value{authorcnt}=0
		\ClassError{\ClassName}{Missing author! You must issue the \Author{name}{department} command}{%
		You MUST issue the \Author{name}{department} command after \begin{document} and before \maketitle.}%
	\fi	
	{by\par
	\whiledo{\value{authorno}<\value{authorcnt}}{%
    	\ignorespaces\csname aut@\theauthorno\endcsname\par
		\ifcsundef{prevdegree@\theauthorno}{\relax}{\normalsize\csname prevdegree@\theauthorno\endcsname}%
		\ifcsundef{secondprevdegree@\theauthorno}{\relax}{\linebreak\normalsize\csname secondprevdegree@\theauthorno\endcsname}%
		\ifcsundef{thirdprevdegree@\theauthorno}{\relax}{\linebreak\normalsize\csname thirdprevdegree@\theauthorno\endcsname}%
		\ifcsundef{fourthprevdegree@\theauthorno}{\relax}{\linebreak\normalsize\csname fourthprevdegree@\theauthorno\endcsname}%
		\par and\par
		\addtocounter{authorno}{1}%
	}%
    \ignorespaces\csname aut@\theauthorno\endcsname
    \ifcsundef{prevdegree@\theauthorno}{\relax}{\par\normalsize\csname prevdegree@\theauthorno\endcsname}%
    \ifcsundef{secondprevdegree@\theauthorno}{\relax}{\linebreak \normalsize\csname secondprevdegree@\theauthorno\endcsname}%
    \ifcsundef{thirdprevdegree@\theauthorno}{\relax}{\linebreak \normalsize\csname thirdprevdegree@\theauthorno\endcsname}%
    \ifcsundef{fourthprevdegree@\theauthorno}{\relax}{\linebreak \normalsize\csname fourthprevdegree@\theauthorno\endcsname}%
    \par\medskip 
    }%
}

\NewDocumentCommand\@AbstractAuthorBlock{}{% Revised 2023/07/20
	\setcounter{authorno}{1}% 
	{by\par
	\whiledo{\value{authorno}<\value{authorcnt}}{%
    	\ignorespaces\csname aut@\theauthorno\endcsname
		\par and\par
		\addtocounter{authorno}{1}%
	}%
    \ignorespaces\csname aut@\theauthorno\endcsname
    }%
}

\newcounter{autcrcnt}
\setcounter{autcrcnt}{1}

\NewDocumentCommand\@CopyrightAuthor{}{%
	\csname aut@\theautcrcnt\endcsname
    \addtocounter{autcrcnt}{1}%
	\whiledo{\value{autcrcnt}<\value{authorcnt}}{%
	   , \ignorespaces\csname aut@\theautcrcnt\endcsname
       \addtocounter{autcrcnt}{1}%
	}%
	\ifnum\value{autcrcnt}=\value{authorcnt}%
		\space and\space\csname aut@\theauthorcnt\endcsname\ignorespaces
	\fi
	\setcounter{autcrcnt}{1}% reset so we can use this command more than once
}

\newcounter{degcnt}
\setcounter{degcnt}{0}
\newcounter{depflag}
\setcounter{depflag}{0}
\NewDocumentCommand\Degree{mm}{% Revised 2023/06/23
	\ifblank{#1}{%
		\ClassError{\ClassName}{Missing degree name, check for blank \Degree{name}{department} command}{%
		Check for blank name \Degree{name}{department} command.}%
		}{%
		\addtocounter{degcnt}{1}%
		\expandafter\xdef\csname deg@\thedegcnt\endcsname{\ignorespaces#1}%
		\expandafter\xdef\csname degdep@\thedegcnt\endcsname{\ignorespaces#2}%
	}%
	\ifblank{#2}{%
	\setcounter{depflag}{\value{degcnt}}%
	\ClassWarning{\ClassName}{Missing degree department for Degree command number \thedegcnt. Assuming to be a duplicate of previous department}}{}%
}% defines \deg@degcnt as Name #1 and \degdep@degcnt as associated dept.

\newcounter{degno}
\newcounter{depno}
\NewDocumentCommand\@DegreeBlock{}{% extensive revision 2023/06/23
	\ifnum\value{degcnt}=0
		\ClassError{\ClassName}{Missing degree! You must issue the \Degree{name}{department} command}{%
		You MUST issue the \Degree{name}{department} command after \begin{document} and before \maketitle. You do want the degree, don't you?}%
	\fi	
	\setcounter{degno}{1}
	\setcounter{depno}{1}
	\newcommand*\PrevDept{\csname degdep@\thedepno\endcsname}
	\newcommand*\CurrDept{}
	Submitted to the \mbox{\PrevDept}%
	\whiledo{\value{depno}<\value{degcnt}}{%
		\addtocounter{depno}{1}%
		\renewcommand*\CurrDept{\csname degdep@\thedepno\endcsname}%
		\ifnum\value{depflag}=\value{depno}\relax\else 
			\space and the\linebreak
			\mbox{\CurrDept}%
			\fi%
		}%
    \linebreak \mbox{in partial fulfillment of the requirements for the\space
    \ifnum\value{degcnt}>1 degrees\else degree\fi\space of}%
	\par\medskip
	\whiledo{\value{degno}<\value{degcnt}}{%
    	\MakeUppercase{\ignorespaces\csname deg@\thedegno\endcsname}\par and\par
		\addtocounter{degno}{1}%
		}%
    \MakeUppercase{\ignorespaces\csname deg@\thedegno\endcsname}\par\medskip
}

\NewDocumentCommand\@AbstractDegreeBlock{}{% 2023/07/19
	\setcounter{degno}{1}
	\setcounter{depno}{1}
	\newcommand*\PrevDept{\csname degdep@\thedepno\endcsname}
	\newcommand*\CurrDept{}
	Submitted to the \mbox{\PrevDept}%
	\whiledo{\value{depno}<\value{degcnt}}{%
		\addtocounter{depno}{1}%
		\renewcommand*\CurrDept{\csname degdep@\thedepno\endcsname}%
		\ifnum\value{depflag}=\value{depno}\relax\else 
			\space and the\linebreak
			\mbox{\CurrDept}%
			\fi%
		}%
   \linebreak on \@ThesisDate \space \mbox{in partial fulfillment of the requirements for the\space
    \ifnum\value{degcnt}>1 degrees\else degree\fi\space of}%
	\par\medskip
	\whiledo{\value{degno}<\value{degcnt}}{%
    	\MakeUppercase{\ignorespaces\csname deg@\thedegno\endcsname}\par and\par
		\addtocounter{degno}{1}%
		}%
    \MakeUppercase{\ignorespaces\csname deg@\thedegno\endcsname}\par\medskip
}


\newcounter{supcnt}
\setcounter{supcnt}{0}
\newcounter{supno}
\setcounter{supno}{0}

\NewDocumentCommand\Supervisor{mm}{%
	\ifblank{#1}{%
		\ClassError{\ClassName}{Missing supervisor name, check for blank in \Supervisor{name}{department} command}{
		Check for blank in \Supervisor{name}{department} command.}%
		}{%
		\addtocounter{supcnt}{1}%
		\expandafter\xdef\csname sup@\thesupcnt\endcsname{#1}%
		\expandafter\xdef\csname supdep@\thesupcnt\endcsname{#2}%
	}%
	\ifblank{#2}{\ClassError{\ClassName}{Missing supervisor department, check for blank in \Supervisor{name}{department} command}{%
	check for blank in \Supervisor{name}{department} command.}}{}%
}% defines \sup@supcnt as Name #1 and \supdep@supcnt as associated dept.

\newcounter{acccnt}
\setcounter{acccnt}{0}
\newcounter{accno}
\setcounter{accno}{0}
\newif\ifmit@noacctitle\mit@noacctitlefalse %  Revised 2023/06/23
\NewDocumentCommand\Acceptor{mmm}{%
	\ifblank{#1}{%
		\ClassWarning{\ClassName}{Missing acceptor name, check for blank in \Acceptor{name}{department}{title} command}%
		}{%
		\addtocounter{acccnt}{1}%
		\expandafter\xdef\csname acc@\theacccnt\endcsname{#1}%
		\expandafter\xdef\csname accdep@\theacccnt\endcsname{#2}%
		\expandafter\xdef\csname acctitle@\theacccnt\endcsname{#3}%
	}%
	\ifblank{#2}{\ClassWarning{\ClassName}{Missing acceptor department, check for blank in \Acceptor{name}{department}{title} command.}}{}%
	\ifblank{#3}{%
		\mit@noacctitletrue
		\ClassWarning{\ClassName}{Missing acceptor title (blank in \Acceptor{name}{department}{title} command). Perhaps you are trying to save vertical space? You can put the acceptor title into department field instead. For consistency, I will omit titles of ALL acceptors.}%
	}{}%
}% defines \acc@acccnt as Name #1, \accdep@accccnt as associated dept, and \acctitle@acccnt as title of acceptor

\newcommand*\@SigSize{\relax}
\NewDocumentCommand\SignatureBlockSize{m}{\renewcommand\@SigSize{\ignorespaces#1}}% revised 2023/06/23

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NewDocumentCommand\@SetSignatureBlock{}{% Revised 2023/06/23
	\ifnum\value{supcnt}=0
		\ClassError{\ClassName}{Missing supervisor! You must issue the \Supervisor{name}{department} command}{%
		You MUST issue the \Supervisor{name}{department} command after \begin{document} and before \maketitle.}%
	\fi	
	\ifnum\value{acccnt}=0
		\ClassError{\ClassName}{Missing acceptor! You must issue the \Acceptor{name}{department} command}{%
		You MUST issue the \Acceptor{name}{department} command after \begin{document} and before \maketitle.}%
	\fi	
	\ifdefined\@ThesisDate\else\ClassError{\ClassName}{Missing thesis date!}{%
	You must issue the \ThesisDate{Date thesis is submitted} command between \begin{document} and \maketitle.}%
	\fi
	\setcounter{authorno}{0}%
	\setcounter{supno}{0}%
	\setcounter{accno}{0}%
    \@SigSize
    \begin{tabbing}
    \hspace{1.35in}\=\hspace{1in}\kill
    \whiledo{\value{authorno}<\value{authorcnt}}{% starting with authorno = 0 ensures we reach authorcnt with +1
        \addtocounter{authorno}{1}%
		Authored by: \> \csname aut@\theauthorno\endcsname\\% remove \ignorespaces x9, 2023/06/23
		\> \csname autdep@\theauthorno\endcsname\\
		\> \@ThesisDate \\[1em]
		}% end whiledo
    \whiledo{\value{supno}<\value{supcnt}}{%
        \addtocounter{supno}{1}%
		Certified by: \> \csname sup@\thesupno\endcsname\\
		\> \csname supdep@\thesupno\endcsname, Thesis Supervisor\\[1em]
		}% end whiledo
    \whiledo{\value{accno}<\value{acccnt}}{%
        \addtocounter{accno}{1}%
		Accepted by: \> \csname acc@\theaccno\endcsname\\
		\> \csname accdep@\theaccno\endcsname
			\ifmit@noacctitle\else %<=== 2023/06/23
				\\
				\> \csname acctitle@\theaccno\endcsname
			\fi
		\\[1em]
		}% end whiledo
	\end{tabbing}
}
\NewDocumentCommand\@SetAbstractSupervisorBlock{}{% revised 2023/06/23
	\setcounter{supno}{1}
	\setlength{\parindent}{0pt}
	\par\bigskip\noindent
    \whiledo{\value{supno}<\value{supcnt}}{%
		Thesis supervisor: \csname sup@\thesupno\endcsname\par
		Title: \csname supdep@\thesupno\endcsname\par\medskip 
        \addtocounter{supno}{1}%
	}% end whiledo
	Thesis supervisor: \csname sup@\thesupno\endcsname\par
	Title: \csname supdep@\thesupno\endcsname\ignorespaces
}

%%%%%%%%%%%%%%%%%%%  Copyright related  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ExplSyntaxOn
\newif\ifmit@cclicense\mit@cclicensefalse
\NewDocumentCommand\CClicense{m m}{%
	\def\CClicensetext{\hrefurl{#2}{\ignorespaces#1}}% #1 - text, #2 - url
	\def\CCname{#1}%
	\def\CCurl{#2}% only for backward compatibility
	\mit@cclicensetrue	
	\cs_if_exist:NT \pdfmeta_xmp_add:n {%
		\pdfmeta_xmp_add:n {<xmpRights:WebStatement>#2</xmpRights:WebStatement>}
	}
}
\ExplSyntaxOff


%%%%%%%%%%%%%%%%%%%  Create titlepage  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\MIT{\MakeUppercase{Universitat Politècnica de Catalunya}}

\RenewDocumentCommand\maketitle{s}{%
%
	\ifdefined\@DegreeMonth\else\ClassError{\ClassName}{Missing degree date!}{%
		You must issue the \DegreeDate{month}{year} command between \begin{document} and \maketitle}%
	\fi
%
	\ifmit@cclicense
    	\def\CopyrightLicense{This work is licensed under a \mbox{\CClicensetext} license.\par\MITpermission}% add mbox 2023/06/23
    	\typeout{^^JUsing Creative Commons License \CCname^^J}
    	\def\PDFRightsText{This work is licensed under a \CCname\ license. \MITpermission}% for use in metadata
	\else
    	\def\CopyrightLicense{All rights reserved.\par\MITpermission}
    	\def\PDFRightsText{All rights reserved. \MITpermission}% for use in metadata
    \fi
	\ifnum\value{authorcnt}>1
		\def\CRWords{The authors hereby grant}\else\def\CRWords{The author hereby grants}
	\fi
    \def\MITpermissionLast{to UPC a nonexclusive, worldwide, irrevocable, royalty-free license to exercise any and all rights under copyright, including to reproduce, preserve, distribute and publicly display copies of the thesis, or release the thesis under an open-access license.}%
    \IfBooleanTF{#1}{\def\MITpermission{\relax}}{\def\MITpermission{\CRWords\space\MITpermissionLast}}%
% 
	\clearpage
	\thispagestyle{empty}%
	\phantomsection\addcontentsline{toc}{chapter}{\protect\textbf{Title page}}%
	{\centering\vbox to \vsize{% vbox to prevent signature block from breaking across page. Remove if necessary.
        \setlength{\parskip}{0.5\baselineskip plus 2pt minus 2pt}\setlength{\parindent}{0pt}%
        {\Large\textbf{\@title}\par}%
        \@AuthorBlock
        \par
        \@DegreeBlock
        at the\par
        \MIT\par
        \@DegreeMonth\space\@DegreeYear
        \MonthCheck{\@@DegreeMonth}{%
			\ClassError{\ClassName}{Acceptable months for the degree date are February, May, June, and September}{Change %
				the month of your degree date to one of February, May, June, or September.}%
		}%
        \par
        \copyright\space\@DegreeYear\space\@CopyrightAuthor. \CopyrightLicense
        \par
        \vskip\baselineskip
        %
        \@SetSignatureBlock
    	\vfill
	}}%
	\newpage
}

%%%%%%%%%%%%%%%%%%%  Create abstract page  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RenewDocumentEnvironment{abstract}{+b}{%
	\newpage
	\phantomsection\addcontentsline{toc}{chapter}{\protect\textbf{Abstract}}%
    \begin{center}
        {\large{\textbf{\@title}}\par}
        \setlength{\parskip}{0.5\baselineskip plus 2pt minus 2pt}
        \@AbstractAuthorBlock
        \par
        \@AbstractDegreeBlock
	\end{center}
	\vskip\baselineskip
	\textbf{ABSTRACT}\par\vskip0.5em
	\ignorespaces#1\ignorespaces
	\ifblank{#1}{\typeout{Missing abstract!} MISSING ABSTRACT!}{\relax}
}{%
	\@SetAbstractSupervisorBlock
	\newpage
	\ignorespacesafterend
}

%%%%%%%  A nomenclature environment, if needed  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\providecommand{\nomname}{Nomenclature}  
\newlength\nomenwidth
\newlength\savitemsep

\makeatletter
\NewDocumentCommand\entry{m m}{%
	\ifblank{#2}{%
		\ClassWarning{\ClassName}{The command \protect\entry requires two arguments. To obtain a subheading, use \protect\EntryHeading}
 		\itemsep3\p@ plus 1\p@ minus 1\p@%
        \goodbreak\item[\itshape#1\hfill]\setlength\itemsep\savitemsep\@itempenalty=1000%
         }{%
         \item[#1\hfill]#2%
         \@itempenalty=-\@lowpenalty%
	}%
}
% A separate command command for nomenclature subheadings 
\NewDocumentCommand\EntryHeading{m}{%
	\itemsep3\p@ plus 1\p@ minus 1\p@%
    \goodbreak\item[\itshape#1\hfill]\setlength\itemsep\savitemsep\@itempenalty=1000%
}
\makeatother
%
%   Increase first optional argument to a dimension > 2em if wide entries cause undesired misalignment of columns. 
%   Second optional argument can be used to rename the environment, e.g., to List of Symbols.
\NewDocumentEnvironment{nomenclature}{O{2em} O{\nomname} O{section}}{%
    \setlength\columnsep{2em} 
    \setlength{\nomenwidth}{#1}
    \csname #3\endcsname *{#2}% this level will vary amongst users!
	\phantomsection\addcontentsline{toc}{#3}{#2}%
    \raggedright
    \begin{list}{}{%
         \setlength{\itemsep}{0pt}%
         \setlength{\parsep}{\itemsep}%
         \setlength{\labelsep}{1em}%
         \setlength{\labelwidth}{\nomenwidth}%
         \setlength{\leftmargin}{\labelwidth}%
         \addtolength{\leftmargin}{\labelsep}%
		 \setlength\savitemsep\itemsep%
    }%
}{\end{list}\ignorespacesafterend}

       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\endinput
%%
%% End of file `mitthesis.cls'.
