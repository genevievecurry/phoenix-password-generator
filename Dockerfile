# To determine the Alpine release being used:
#
#   - Look at the Dockerfile dependencies and follow it back to the base until
#     reaching the actual alpine version.
#     - https://hub.docker.com/_/elixir
#  
#   - cat /etc/alpine-release
#
# Debugging Notes:
#
#   docker run -it --rm phoenix-password-generator /bin/ash

FROM node:15.14-alpine AS node
FROM hexpm/elixir:1.12.1-erlang-24.0.1-alpine-3.13.3 AS build

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

# install build dependencies
RUN apk add --no-cache build-base npm

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# set build ENV as prod
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey

# Copy over the mix.exs and mix.lock files to load the dependencies. If those
# files don't change, then we don't keep re-fetching and rebuilding the deps.
COPY mix.exs mix.lock ./
COPY config config


RUN mix deps.get --only prod && \
    mix deps.compile

# install npm dependencies
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets

# NOTE: If using TailwindCSS, it uses a special "purge" step and that requires
# the code in `lib` to see what is being used. 
COPY lib lib

RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
RUN mix compile

RUN mix release.init

RUN mix release

# prepare release docker image
FROM alpine:3.13 AS app
RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody


ENV HOME=/app
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=nokey
ENV PORT=4000

COPY --from=build --chown=nobody:nobody /app/_build/${MIX_ENV}/rel/pw_app ./

CMD ["/app/bin/server"]

# Appended by flyctl
ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"