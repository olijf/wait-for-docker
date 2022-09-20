# Wait-for docker wrapper

The wait-for script (from [eficode](https://github.com/eficode/wait-for)) wrapped in a convinient docker container.

## Usage
```bash
docker run --rm wait-for google.com:80 -- echo success!
success!
```

Or add it as alias:
```bash
alias wait-for="docker run --rm wait-for"
wait-for google.com:80 -- echo success
success
```

In your docker compose:
```yml
version: "3.9" # optional since v1.27.0
services:
  node:
    build: nodeapp
    ports:
      - "8080:8080"
    volumes:
      - ./nodelogs:/nodelog
    command: ["/bin/bash", "-c", "node index.js | tee /nodelog/output.txt"]
  web:
    image: nginx
    ports:
      - "80:80"
    depends_on:
      downloadFromNode:
        condition: service_completed_successfully
    volumes:
      - ./src:/usr/share/nginx/html
  wait-for:
    build: .
    depends_on:
      node:
        condition: service_started
    command: >
      node:8080 -- echo node app running
  downloadFromNode:
    depends_on:
      wait-for:
        condition: service_completed_successfully
    image: alpine/curl
    volumes:
      - ./src:/download
    command: >
      'http://node:8080/download' --output /download/download
```
the depends_on now has conditions, so you can wait with starting your containers. This yaml waits for the node app to be running before downloading something and placing it in an nginx server.
