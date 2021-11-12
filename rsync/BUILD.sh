docker buildx build --platform linux/amd64,linux/arm64 \
-t stefangenov/rsync:latest \
-t stefangenov/rsync:alpine-latest \
-t stefangenov/rsync:alpine \
-f Dockerfile \
--cpu-quota="400000" \
--memory=16g \
--push .
