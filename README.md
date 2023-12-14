  
  #mitthesis --- A LaTeX template for MIT theses#

  v1.05 dated 2023/07/21

  ####Overview####
  This class provides a LaTeX template for MIT theses formatted according to
  the requirements of the Massachusetts Institute of Technology Libraries (as posted in 2023):
  
  [https://libraries.mit.edu/distinctive-collections/thesis-specs/](https://libraries.mit.edu/distinctive-collections/thesis-specs/)

  This template is appropriate for MIT theses of all types.
  
  This template works with either pdfLaTeX or unicode engines such as luaLaTeX. The bibliography can be prepared with either biblatex (default) or natbib/bibtex. The class is based on current LaTeX distributions, ideally 11/2022 or later, but  compatible with distributions back to 2020. This template replaces the older version of mitthesis.cls, which was first composed in the 1980s.
  
  With minor adjustments, this template can be adapted for use at other institutions (see the documentation for details).

  The files in this distribution are:

          README.md             --  this file
          mitthesis.cls         --  the class file
          MIT-Thesis.pdf        --  a sample thesis from the template, using default fonts
          *
          MIT-thesis-template/  --  a directory with the files needed to starting writing your thesis
              MIT-Thesis.tex        --  the main latex template file for this class
              abstract.tex          --  put your abstract in this file
              acknowledgments.tex   --  put your acknowledgments in this file
              biosketch.tex         --  put your biosketch in this file (optional)
              chapter1.tex          --  put your first chapter in this file (etc.)
              appendixa.tex         --  put your first appendix in this file (etc.)
              mitthesis-sample.bib  --  a sample bibliography file with many examples
              mydesign.tex          --  an optional file to load packages for document design
          *
          mitthesis-doc/        --  documentation for usage and options
          fontsets/             --  a directory of input files that load optional fonts
          examples/font_samples/  
                                --  sample theses in different fonts 
          examples/cover_page_samples/  
                                --  sample theses for one or more authors and degrees
          
    
  ####Author####
  
  John H. Lienhard V
  
  Department of Mechanical Engineering
          
  Massachusetts Institute of Technology
          
  Cambridge, MA 02139-4307 USA


 ---
 
 ####Change log####
 v1.05 (21 July 2023): 
 - Fix bug in toc page number affecting some lists of figures or tables (note: for backward compatibility, remove code in .tex file around \tableofcontents, \listoffigures, and \listoftables so that your code will match the present version)
 - Include thesis submission date in abstract, remove previous degrees from abstract page, and allow May for degree month, per MIT Libraries
 - Fill pdflicenseurl in class file; update a class warning message
 - Clean-up documentation and code

 v1.04 (3 July 2023): 
 - Embed default fontset in class file, in case fontset directory is missing

 v1.03 (26 June 2023): 
 - Bug fix: fontset naming for older LaTeX formats
 - Change default biblatex style to IEEE
 - Code hacks for non-MIT use of template (see documentation, pg. 7)

 v1.02 (23 June 2023): 
 - Bug fixes: triple major counter, \SignatureBlockSize
 - Code revisions for cover page and abstract pages: spacing, linebreaking, and user command options
  
 v1.01 (19 June 2023): Changes to file structure and naming
 
 v1.00 (17 June 2023): Initial release
 
 ---
 
 ####License####

 Copyright (c) 2023 John H. Lienhard

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
 associated documentation files (the "Software"), to deal in the Software without restriction, 
 including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
 subject to the following two conditions:

 The above copyright notice and this permission notice shall be included in all copies or 
 substantial portions of the Software.

 The software is provided "as is", without warranty of any kind, express or implied, including but 
 not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. 
 In no event shall the authors or copyright holders be liable for any claim, damages or other liability, 
 whether in an action of contract, tort or otherwise, arising from, out of or in connection with the 
 software or the use or other dealings in the software.
# MITThesisLaTeX
