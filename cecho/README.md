Description : An enhanced ECHO command line utility with color support.<br>
Website     : https://www.codeproject.com/Articles/17033/Add-Colors-to-Batch-Files<br>

Observation : This great utility was written by Thomas Polaert.
             (https://www.codeproject.com/script/Membership/View.aspx?mid=138320)<br>
            
Source code : ./software/source/source.zip<br>
Tests       : ./software/tests/test.cmd<br>

--------------------------------------------------------------------------------


Introduction

Batch files are useful to deal with repetitive tasks. However, they lack some 
user-friendly features such as colorizing console outputs. Colorized outputs 
might be useful to draw attention to important information. The Win32 API 
provides some useful functions to interact with the console (see Console 
Functions in MSDN). But in your batch files, the only command available is 
COLOR. The COLOR command only defines the color of the entire window console.

cecho is an enhanced ECHO command line utility with color support, inspired by 
the CTEXT utility by Dennis Bareis.

The last section explains how to embed the cecho utility into a batch file using
the Debug.exe program (until Windows Vista).

Using the Code
cecho simply redirects the command arguments to the standard output after 
parsing color information. cecho arguments include:

{XX}: colors coded as two hexadecimal digits. E.g., {0A} light green
{color}: color information as understandable text. E.g., {light red on black}
{\n \t}: New line character - Tab character.
{\u0000}: Unicode character code.
{{: escape character '{'.
{#}: restore initial colors.
Available colors:

0 = black	8 = gray
1 = navy	9 = blue
2 = green	A = lime
3 = teal	B = aqua
4 = maroon	C = red
5 = purple	D = fuchsia
6 = olive	E = yellow
7 = silver	F = white
Sample batch file:

@echo off

cecho {0C}This line is red{#}

REM Print ASCII char 0x07 (beep) 
cecho {\u07 \u07}

cecho This {black on blue}word{#} is black on a blue background

--------------------------------------------------------------------------------<br>
Changes log: in cecho v2.0, the {0x00} ASCII code has been replaced by the 
{\u0000} Unicode character.