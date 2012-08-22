@echo off 

REM : get current bat dir
REM : http://blogs.msdn.com/b/oldnewthing/archive/2005/01/28/362565.aspx
set nodeScitePath=%~dp0 
cd %nodeScitePath%
node "nodeScite.js"
