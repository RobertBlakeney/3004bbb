#!/bin/bash

#update and upgrade
sudo apt-get update -y
sudo apt-get upgrade -y

#base dependencies
sudo apt-get install -y apache2 openvswitch-switch mininet iperf ffmpeg gpac x264 python2-pip unzip

#Test video
wget https://github.com/RobertBlakeney/3004bbb/raw/refs/heads/main/bbb.zip

sudo mv bbb.zip /var/www/html

cd /var/www/html
unzip bbb.zip
mv bbb1.mp4 bbb.mp4

sudo ffmpeg -i bbb.mp4 -t 00:02:00 bbb_2m.mp4
sudo mv bbb_2m.mp4 bbb.mp4

#Creating video reps

#2400
sudo x264 --output bbb_2400k.264 --fps 24 --preset slow --bitrate 2400 --vbv-maxrate 4800 --vbv-bufsize 9600 --min-keyint 96 --keyint 96 --scenecut 0 --no-scenecut --pass 1 --video-filter resize:width=1280,height=720 bbb.mp4
sudo MP4Box -add bbb_2400k.264 -fps 24 bbb_2400k.mp4
sudo MP4Box -dash 4000 -frag 4000 -rap -segment-name segment_2400k_ bbb_2400k.mp4

#1200
sudo x264 --output bbb_1200k.264 --fps 24 --bitrate 1200 --vbv-maxrate 2400 --vbv-bufsize 4800 --min-keyint 49 --keyint 49 --scenecut 0 --no-scenecut --pass 1 --video-filter resize:width=1280,height=720 bbb.mp4
sudo MP4Box -add bbb_1200k.264 -fps 24 bbb_1200k.mp4
sudo MP4Box -dash 4000 -frag 4000 -rap -segment-name sgement_1200k_ bbb_1200k.mp4

#400
sudo x264 --output bbb_400k.264 --fps 24 --bitrate 400 --vbv-maxrate 800 --vbv-bufsize 1600 --min-keyint 16 --keyint 16 --scenecut 0 --no-scenecut --pass 1 --video-filter resize:width=1280,height=720 bbb.mp4
sudo MP4Box -add bbb_400k.264 -fps 24 bbb_400k.mp4
sudo MP4Box -dash 4000 -frag 4000 -rap -segment-name sgement_4000k_ bbb_400k.mp4

#File to combine reps
sudo cp bbb_400k_dash.mpd bbb_dash.mpd


# Vserion confirmations
git --version
MP4Box -version
apache2 -v
mininet --version
iperf -v
ffmpeg -v
x264 --version
pip3 --version

echo "Setup complete."


