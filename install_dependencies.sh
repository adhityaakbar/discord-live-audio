#!/bin/bash

echo "Memulai instalasi dependensi sistem..."

# Perbarui daftar paket
sudo apt-get update -y

# Instal portaudio19-dev yang diperlukan oleh PyAudio
echo "Menginstal portaudio19-dev..."
sudo apt-get install -y portaudio19-dev

# Instal pip jika belum ada
echo "Memeriksa dan menginstal pip..."
sudo apt-get install -y python3-pip

echo "Instalasi dependensi sistem selesai. Sekarang menginstal dependensi Python..."

# Instal dependensi Python dari requirements.txt
pip install -r requirements.txt

echo "Instalasi semua dependensi selesai. Anda sekarang dapat menjalankan bot dengan 'python3 main.py'"
