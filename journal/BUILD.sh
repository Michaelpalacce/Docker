VERSION=1.0.0

cd journal && docker buildx build --platform linux/amd64,linux/arm64 \
-f Dockerfile \
-t stefangenov/journal:latest \
-t stefangenov/journal:"${VERSION}" \
--build-arg TAG_VERSION="${VERSION}" \
--cpu-quota="400000" \
--memory=16g \
--push .
