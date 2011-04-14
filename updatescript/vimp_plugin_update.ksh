#!/bin/pdksh
MYLIST="../vimp_plugin_list.txt"
DEST=`echo $0 | sed -e 's/\(.*[/]\).*/\1plugin/'`

echo "update vimperator plugins..."

cd ${DEST}
    wget --no-check-certificate -i ${MYLIST} -N
cd ../

echo "done."
