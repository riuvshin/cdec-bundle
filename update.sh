###########################################################
###         Transfer binaries to update server          ###
###########################################################

SSH_KEY_NAME=~/.ssh/as1-cldide_cl-server.skey
SSH_AS_USER_NAME=codenvy
AS_IP=updater.codenvy-stg.com

ARTIFACT="codenvy"
FILENAME=`ls target | grep -G 'cdec-bundle.*[.]zip'`
SOURCE="target/${FILENAME}"
VERSION=`ls target | grep -G 'cdec-bundle.*[.]zip' | sed 's/cdec-bundle-//' | sed 's/.zip//'`
DESCRIPTION="Codenvy binaries"
DESTINATION=update-server-repository/${ARTIFACT}/${VERSION}

MD5=`md5sum ${SOURCE} | cut -d ' ' -f 1`
SIZE=`du -b ${SOURCE} | cut -f1`
BUILD_TIME=`stat -c %y ${SOURCE}`
BUILD_TIME=${BUILD_TIME:0:19}

echo "file=codenvy-${VERSION}.zip" > .properties
echo "artifact=${ARTIFACT}" >> .properties
echo "version=${VERSION}" >> .properties
echo "label=STABLE" >> .properties
echo "previous-version=" >> .properties
echo "description=${DESCRIPTION}" >> .properties
echo "authentication-required=false" >> .properties
echo "build-time="${BUILD_TIME} >> .properties
echo "md5=${MD5}" >> .properties
echo "size=${SIZE}" >> .properties

ssh -i ${SSH_KEY_NAME} ${SSH_AS_USER_NAME}@${AS_IP} "mkdir -p /home/${SSH_AS_USER_NAME}/${DESTINATION}"
scp -o StrictHostKeyChecking=no -i ${SSH_KEY_NAME} ${SOURCE} ${SSH_AS_USER_NAME}@${AS_IP}:${DESTINATION}/"codenvy-"${VERSION}".zip"
scp -o StrictHostKeyChecking=no -i ${SSH_KEY_NAME} .properties ${SSH_AS_USER_NAME}@${AS_IP}:${DESTINATION}/.properties

rm .properties