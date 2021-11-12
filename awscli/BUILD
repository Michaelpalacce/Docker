docker buildx build --platform linux/amd64,linux/arm64 \
-f Dockerfile \
-t stefangenov/awscli:alpine \
-t stefangenov/awscli:alpine-latest \
-t stefangenov/awscli:latest \
--cpu-quota="400000" \
--memory=16g \
--push \
.
