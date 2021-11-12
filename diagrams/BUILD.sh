# GET LATEST VERSION FROM: https://github.com/jgraph/drawio
VERSION=$(curl -s -XGET https://api.github.com/repos/jgraph/drawio/tags | grep name -m 1 | awk '{print $2}' | cut -d'"' -f2)

docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/diagrams:latest \
-t stefangenov/diagrams:"${VERSION}" \
-f Dockerfile \
--build-arg TAG_VERSION="${VERSION}" \
--push .
