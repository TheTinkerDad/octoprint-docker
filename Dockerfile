# Based on ubuntu - might port it to Alpine some day to further reduce footprint. A multistage build would be also fine...
FROM ubuntu

EXPOSE 8080

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  imagemagick \
  v4l-utils \
  libjpeg-dev \
  libv4l-dev \
  unzip \
  wget \
  zlib1g-dev

# Download and extract the source code
WORKDIR /tmp
RUN wget --no-check-certificate https://github.com/jacksonliam/mjpg-streamer/archive/master.zip; unzip master.zip

# Build and install
WORKDIR /tmp/mjpg-streamer-master/mjpg-streamer-experimental
RUN make; make install

####
# These settings should be overridden according to user preferences
ENV MJPG_RES=640x480
ENV MJPG_FPS=30
ENV MJPG_USER=admin
ENV MJPG_PASS=adm1n
# End of user preferences
####

ENV CAMERA_DEV /dev/video0
ENV LD_LIBRARY_PATH='/opt/vc/lib/:/usr/local/lib/mjpeg_streamer'

# Add new user, just to avoid opening up a commonly used port as root
RUN adduser \
   --system \
   --disabled-password \
   mjpg-streamer

# Add the user to the video group to access the camera
RUN usermod -aG video mjpg-streamer

# Start mjpg-streamer with the fresh user
USER mjpg-streamer
CMD /usr/local/bin/mjpg_streamer -o "output_http.so -w /usr/local/share/mjpg-streamer/www -c $MJPG_USER:$MJPG_PASS" -i "input_uvc.so -r $MJPG_RES -fps $MJPG_FPS"

