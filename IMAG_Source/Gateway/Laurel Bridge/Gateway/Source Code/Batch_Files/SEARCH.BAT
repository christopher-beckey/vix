@echo off
if "%1"=="" goto help
if "%2"=="" goto help

set s="%2"
if not "%3"=="" set s="%2 %3"
if not "%4"=="" set s="%2 %3 %4"

echo for %%f in (%1\*.txt) do find /i %s% %%f
for %%f in (%1\*.txt) do find /i %s% %%f
goto exit

:help
echo search {input directory} {search string}
echo example: search w00000 smith

:exit
