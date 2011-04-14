@ECHO OFF
set MYLIST=.\vim_plugin_list.txt
set DEST=.\bundle

echo update vim-script...

for /f %%A in (%MYLIST%) do (
    echo update %%A
    cd %DEST%\%%A
    git reset --hard HEAD
    git pull
    cd ..\..\
)
cd ..\

echo done.
