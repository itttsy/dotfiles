#!/bin/ksh
MYLIST="../vim_plugin_list.txt"
DEST=`echo $0 | sed -e 's/\(.*[/]\).*/\1bundle/'`

echo "update vim-script..."

cd ${DEST}
pwd
while read LN;do
    cd ${LN}
        echo "update ${LN}"
        git reset --hard HEAD
        git pull
    cd ../
pwd
done < ${MYLIST}

echo "done."
