# syntax=docker/dockerfile:1.4

###################################################
# Stage: base
###################################################
FROM node:20 AS base
WORKDIR /usr/local/app

################## CLIENT STAGES ##################

###################################################
# Stage: client-base
###################################################
FROM base AS client-base
COPY client/package.json client/yarn.lock ./
RUN yarn install --frozen-lockfile
COPY client/.eslintrc.cjs client/index.html client/vite.config.js ./
COPY client/public ./public
COPY client/src ./src

###################################################
# Stage: client-dev
###################################################
FROM client-base AS client-dev
CMD ["yarn", "dev"]

###################################################
# Stage: client-build
###################################################
FROM client-base AS client-build
RUN yarn build

################## BACKEND STAGES #################

###################################################
# Stage: backend-dev
###################################################
FROM base AS backend-dev
COPY backend/package.json backend/yarn.lock ./

# Debug: list files to verify correct copy
RUN ls -la /usr/local/app

RUN yarn install --frozen-lockfile

COPY backend/spec ./spec
COPY backend/src ./src

CMD ["yarn", "dev"]

###################################################
# Stage: test
###################################################
FROM backend-dev AS test
RUN yarn test

###################################################
# Stage: final
###################################################
FROM base AS final
ENV NODE_ENV=production
COPY --from=test /usr/local/app/package.json /usr/local/app/yarn.lock ./

RUN yarn install --frozen-lockfile

COPY backend/src ./src
COPY --from=client-build /usr/local/app/dist ./src/static

EXPOSE 3000
CMD ["node", "src/index.js"]
