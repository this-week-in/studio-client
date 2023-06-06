#!/usr/bin/env bash

export IMAGE_NAME=gcr.io/${GCLOUD_PROJECT}/${APP_NAME}
export ROOT_DIR=${GITHUB_WORKSPACE:-$(cd `dirname $0` && pwd)}

cd $GITHUB_WORKSPACE
./bin/prod.sh

mkdir -p ${ROOT_DIR}/build/public
cp $ROOT_DIR/deploy/nginx-buildpack-config/* ${ROOT_DIR}/build
cp -r $ROOT_DIR/dist/* ${ROOT_DIR}/build/public
cd $ROOT_DIR/build
pack build $IMAGE_NAME --builder paketobuildpacks/builder:full --buildpack gcr.io/paketo-buildpacks/nginx:latest --env PORT=8080
docker push $IMAGE_NAME