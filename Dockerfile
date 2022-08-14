FROM debian:stable-slim as base

RUN DEBIAN_FRONTEND=noninteractive \
  apt update \
  && apt install --assume-yes --no-install-recommends \
    gcc \
  && rm -rf /var/lib/apt/lists/* 

FROM base as builder

RUN DEBIAN_FRONTEND=noninteractive \
  apt update \
  && apt install --assume-yes --no-install-recommends \
     libc6-dev make cmake \
  && rm -rf /var/lib/apt/lists/* 

WORKDIR /Sqlite3

COPY . .

RUN  cmake . \
  && make \
  && make install

FROM base 

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib /usr/local/lib

RUN LD_LIBRARY_PATH=/usr/local/lib \
  && export LD_LIBRARY_PATH && ldconfig
