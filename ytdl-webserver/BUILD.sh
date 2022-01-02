# https://github.com/Algram/ytdl-webserver
VERSION=1.0.0

DIR="ytdl-webserver"
#if [ -d "$DIR" ]; then
#  echo "${DIR} missing, cloning repo!"
#  git clone https://github.com/Algram/ytdl-webserver ytdl-webserver
#fi

cd $DIR && docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/ytdl-webserver:latest \
-t stefangenov/ytdl-webserver:"${VERSION}" \
-f Dockerfile \
--build-arg TAG_VERSION="${VERSION}" \
--cpu-quota="400000" \
--memory=8g \
--push .
