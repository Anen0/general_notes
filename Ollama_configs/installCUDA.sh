#!/bin/bash


echo "\n\n[$(date)] - Downloading CUDA from source: \n" 
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb 

echo "[$(date)] - Download complete....Installing CUDA\n\n"


sudo dpkg -i cuda-keyring_1.1-1_all.deb &&
sudo apt-get update &&
sudo apt-get -y install cuda-toolkit-13-4 

echo "[$(date)] - CUDA installed\n\n"

