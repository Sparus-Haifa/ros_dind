# FROM ubuntu:18.04
# FROM ubuntu:16.04
# FROM ros:melodic-ros-base-bionic
# FROM iquarobotics/cola2:ubuntu_20.04
FROM osrf/ros:melodic-desktop-full

ARG TOKEN

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# ENV DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTEND=noninteractive

# install docker
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy curl && \
    apt-get install -qy curl && \
    curl -sSL https://get.docker.com/ | sh

# # install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-perception=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /home/catkin_ws/src
WORKDIR /home/catkin_ws/src

WORKDIR /home/catkin_ws/

# dev tools
RUN apt-get update && \
    apt-get install -y gedit \
    && rm -rf /var/lib/apt/lists/*




# copy source files from local
COPY . /home/catkin_ws/src/

# catin make
WORKDIR /home/catkin_ws
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash && catkin_make'

# source
RUN echo "source /home/catkin_ws/devel/setup.bash" >> ~/.bashrc