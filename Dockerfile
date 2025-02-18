FROM debian:bullseye-slim as builder

# install tools (wget, unzip)
RUN apt-get update \
  && apt-get install -y --no-install-recommends wget unzip

RUN wget --no-check-certificate https://lifescience.opensource.epam.com/downloads/bingo-1.28.0/bingo-postgres-15-linux-x86_64.zip
RUN mkdir -p /opt/bingo-postgres
RUN unzip -p bingo-postgres-15-linux-x86_64.zip | tar -xzf- -C /opt/bingo-postgres --strip-components=1
WORKDIR /opt/bingo-postgres
RUN /bin/sh bingo-pg-install.sh -libdir /opt/bingo-postgres/lib -y

FROM bitnami/postgresql:15 as base
USER root
COPY --from=builder /opt/bingo-postgres/lib /opt/bingo-postgres/lib
COPY --from=builder /opt/bingo-postgres/bingo_install.sql /opt/bingo-postgres/init-scripts/000-bingo_install.sql
RUN sed -i '/# Allow running custom initialization scripts/a POSTGRESQL_INITSCRIPTS_USERNAME=postgres POSTGRESQL_INITSCRIPTS_DIR=\/opt\/bingo-postgres\/init-scripts postgresql_custom_init_scripts' /opt/bitnami/scripts/postgresql/setup.sh
USER 1001
