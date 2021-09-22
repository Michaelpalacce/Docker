################### Based on https://github.com/Lissy93/dashy/blob/master/Dockerfile ############################
FROM node:lts-alpine3.14

# Define some ENV Vars
ENV PORT=80 \
  DIRECTORY=/app \
  IS_DOCKER=true

# Create and set the working directory
WORKDIR ${DIRECTORY}

RUN apk add git && git clone https://github.com/Lissy93/dashy.git .

RUN rm -rf /app/public/item-icons && GIT_SSL_NO_VERIFY=true git clone https://github.com/NX211/homer-icons.git /app/public/item-icons
COPY extraimages/* /app/public/item-icons

# Install project dependencies
RUN yarn

# Build initial app for production
RUN yarn build

# Expose given port
EXPOSE ${PORT}

# Finally, run start command to serve up the built application
CMD [ "yarn", "build-and-start"]

# Run simple healthchecks every 5 mins, to check the Dashy's everythings great
HEALTHCHECK --interval=5m --timeout=2s --start-period=30s CMD yarn health-check
