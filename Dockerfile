FROM node:20 AS base
WORKDIR /usr/local/app

FROM base AS client-base
COPY client/package.json client/yarn.lock ./
RUN --mount=type=cache,id=yarn,target=/usr/local/share/.cache/yarn yarn install
COPY client/.eslintrc.cjs client/index.html client/vite.config.js ./
COPY client/public ./public
COPY client/src ./src

FROM client-base AS client-dev
CMD ["yarn", "dev"]

FROM client-base AS client-build
RUN yarn build

FROM base AS backend-dev
COPY backend/package.json backend/yarn.lock ./
RUN --mount=type=cache,id=yarn,target=/usr/local/share/.cache/yarn yarn install --frozen-lockfile
COPY backend/spec ./spec
COPY backend/src ./src
COPY backend/wait-for-mysql.sh ./
RUN chmod +x wait-for-mysql.sh
CMD ["./wait-for-mysql.sh", "mysql", "yarn", "dev"]

FROM backend-dev AS test
RUN yarn test

FROM base AS final
ENV NODE_ENV=production
COPY --from=test /usr/local/app/package.json /usr/local/app/yarn.lock ./
RUN --mount=type=cache,id=yarn,target=/usr/local/share/.cache/yarn yarn install --production --frozen-lockfile
COPY backend/src ./src
COPY backend/wait-for-mysql.sh ./
RUN chmod +x wait-for-mysql.sh
COPY --from=client-build /usr/local/app/dist ./src/static
EXPOSE 3000
CMD ["./wait-for-mysql.sh", "mysql", "node", "src/index.js"]
