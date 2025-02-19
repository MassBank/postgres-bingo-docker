# Postgres Docker Image with Bingo Chemistry search engine

This repository contains a Docker image for a PostgreSQL database extended with the [Bingo chemistry cartridge](https://github.com/epam/indigo) based on [bitnami/postgresql](https://github.com/bitnami/containers/blob/main/bitnami/postgresql/README.md).

## Overview

The Bingo Postgres Docker image provides a PostgreSQL database with the Bingo chemistry cartridge pre-installed. This setup is ideal for applications that require advanced chemical structure searching and indexing capabilities.

## Usage

To use this Docker image, you can pull it from the Docker registry or build it locally.

### Pull from Docker Registry

```sh
docker pull quay.io/massbank/postgres-bingo:latest
```

### Build Locally

Clone this repository and build the Docker image:

```sh
git clone https://github.com/MassBank/postgres-bingo.git
cd postgres-bingo
docker build -t postgres-bingo:latest .
```

## Running the Container

To run a container using this image:

```sh
$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d quay.io/massbank/postgres-bingo
```

The bingo cartridge needs administrator rights during the initialisation. If you set a POSTGRESQL_USERNAME environment variable the system will set no password for the `postgres` admin user. Thus, you must also set POSTGRESQL_POSTGRES_PASSWORD or the bingo initialisation will fail.

```sh
docker run --name some-postgres -e POSTGRESQL_DATABASE=mydatabase -e POSTGRESQL_USERNAME=mydbuser -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRESQL_POSTGRES_PASSWORD=mysecretadminpassword -d postgres-bingo:latest
```

## Initialization Scripts

This image supports initialization scripts located in the `/docker-entrypoint-initdb.d/` directory like normal postgres images. The bing specific init scripts are integrated in the image and located in `/opt/bingo-postgres/init-scripts/`. The ENTRYPOINT script is modified to automatically execute this script.

## Init Container

There is a second container `quay.io/massbank/postgres-bingo-init` available, which can be used as init container in a K8s deployment. It holds the required files in `/bingo-postgres`.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
