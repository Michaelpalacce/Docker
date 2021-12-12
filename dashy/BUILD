# GET LATEST VERSION FROM: https://github.com/wallabag/wallabag
VERSION=$(curl -s -XGET https://api.github.com/repos/lissy93/dashy/tags | grep name -m 1 | awk '{print $2}' | cut -d'"' -f2)

docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/dashy:latest \
-t stefangenov/dashy:"${VERSION}" \
-f Dockerfile \
--build-arg TAG_VERSION="${VERSION}" \
--cpu-quota="400000" \
--memory=8g \
--push .