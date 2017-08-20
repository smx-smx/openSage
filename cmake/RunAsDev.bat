@echo off
call "%VS140COMNTOOLS%\vsvars32.bat"

set exe="%1"

set RESTVAR=
shift
:loop1
if "%1"=="" goto after_loop
set RESTVAR=%RESTVAR% %1
shift
goto loop1

:after_loop

%exe% %RESTVAR%