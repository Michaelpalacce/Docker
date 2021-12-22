################### Based on https://github.com/Lissy93/dashy/blob/master/Dockerfile ############################
FROM node:lts-alpine3.14

ARG TAG_VERSION

# Define some ENV Vars
ENV PORT=80 \
  DIRECTORY=/app \
  IS_DOCKER=true

# Create and set the working directory
WORKDIR ${DIRECTORY}

RUN apk add git && git clone --depth 1 --branch $TAG_VERSION https://github.com/Lissy93/dashy.git .

COPY extraimages/* /app/public/item-icons

# Install project dependencies
RUN yarn

# Build initial app for production
RUN yarn build

# Expose given port
EXPOSE ${PORT}

# Finally, run start command to serve up the built application
CMD ["yarn", "build-and-start"]
