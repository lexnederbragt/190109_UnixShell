# create data.tgz
tar -cvzf data.tgz data
# copy to abel
rsync -av data.tgz abel:/work/users/alexajo/190109_UnixShell_data.tgz
