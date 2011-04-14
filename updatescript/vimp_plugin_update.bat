@ECHO OFF
set MYLIST=..\vimp_plugin_list.txt
set DEST=.\plugin

echo update vimperator plugins...

cd %DEST%
for /f %%A in (%MYLIST%) do curl -k -O %%A
cd ../

echo done.
