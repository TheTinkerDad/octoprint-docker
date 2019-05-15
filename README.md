# octoprint-docker
Another solution for running OctoPrint in Docker - this time multiple instances of it, with multiple streaming webcams as well!

## Configuration

You can change settings either via Docker command line, or - more conveniently - via Docker Compose. See the individual settings below, demonstrated through corresponding parts of the docker-compose.yaml file.

See the docker-compose.yaml file in this repository for a complete example.

### Ports

The MJPEG Streamer in the Docker container by default exposes HTTP 8080 - of course, you can "override" this by mapping it to another port, like:

```yaml
    ports:
      - 8912:8080
```      

OctoPrint exposes port 5000. You can map it to any other port like:

```yaml
    ports:
      - 5001:5000
```      
      
### WebCam selection

By default, your USB web cam will end up as /dev/video0 - however, in case of multiple webcams, you need to map each camera (visible on the host as /dev/videoX, where X is a number) to a specific Docker container by assigning it to the /dev/video0 node of the container:

```yaml
    devices:
      - /dev/video1:/dev/video0
```

### WebCam resolution & FPS

These settings are fully depend on your camera's capabilities and you can override the default 640x480@30fps like this:

```yaml
    environment:
      - MJPG_RES=640x480
      - MJPG_FPS=25
```      

### Username and password

You can override the default admin/adm1n for making your camera's stream a bit more secure...

```yaml
    environment:
      - MJPG_RES=640x480
      - MJPG_FPS=25
      - MJPG_USER=admin
      - MJPG_PASS=adm1n 
```
