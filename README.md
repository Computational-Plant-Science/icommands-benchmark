<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Contents**

- [Usage](#usage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Usage

First, make some copies of the sample:

```bash
chmod +x util/make-copies.sh
./util/make-copies.sh root.png 100
```

Then bundle them:

```bash
tar -czvlf samples.tar samples
```

Configure environment variables by adding a file called `.env` to the project root:

```
IRODS_HOST=irods
IRODS_PORT=1247
IRODS_ZONE=tempZone
IRODS_USER=rods
IRODS_PASSWORD=rods
```

These values (and this repository, by default) work with the `mjstealey/irods-provider-postgres:4.2.3` Docker image. To benchmark against a different server, comment out the `irods` service in `docker-compose.yml` as well as the `agent`'s `depends_on` statement:

```yaml
version: '3.7'

services:

  # irods:
  #   image: mjstealey/irods-provider-postgres:4.2.3
  #   ports:
  #     - 1247:1247

  agent:
    build:
      context: .
      dockerfile: Dockerfile
    command: ./util/wait-for-it.sh $IRODS_HOST:$IRODS_PORT -- ./benchmark.sh -h $IRODS_HOST -p $IRODS_PORT -z $IRODS_ZONE -u $IRODS_USER -w $IRODS_PASSWORD
    # depends_on:
    #   - irods

```

You will also need to adjust environment variables.

Run the benchmark with `docker-compose -f docker-compose.yml up --build`.
