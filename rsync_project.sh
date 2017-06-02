#/bin/bash
LOCAL_DIR=/local_dir/
REMOTE_DIR=username@0.0.0.0:/remote_dir/
DIRNAME=project_dir_name
if [[ $# = 1 && $1 = "init" ]]; then
    rsync -avz $REMOTE_DIR$DIRNAME $LOCAL_DIR
    exit
fi
rsync -avz --exclude *'.git/index.lock' $LOCAL_DIR$DIRNAME $REMOTE_DIR
fswatch -r $LOCAL_DIR$DIRNAME | while read line; do
    if [[ $line == *'.git/index.lock' ]]; then
        continue
    fi
    if [ ! -e "$line" ]; then
        rsync -avz --exclude *'.git/index.lock' $LOCAL_DIR$DIRNAME $REMOTE_DIR
    else
        rsync -avz ${line##*$LOCAL_DIR} ${REMOTE_DIR}${line##*$FROMDIR}
    fi
done
