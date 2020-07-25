# Preliminaries
# clone or download https://github.com/OHIF/Viewers.git
# cd to your location of the OHIF repo 
# install yarn
# export $STATIC_DIR= your location of the IDC-Viewer-Support repo
# export $WBUCKET= cloud bucket location


yarn install
yarn run build
cd ./platform/viewers/dist/

cp $STATIC_DIR/app-config.js .
cp $STATIC_DIR/idc-black.svg .
cp $STATIC_DIR/idc-dark.svg .

gsutil web set -m index.html -e index.html gs://$WBUCKET
gsutil -h "Cache-Control:no-cache, max-age=0" rsync -d -r . gs://$WBUCKET 


