#!/bin/bash

echo "Memulai instalasi dependensi untuk macOS..."

# Cek apakah Homebrew sudah terinstal, jika tidak, instal
if ! command -v brew &> /dev/null; then
    echo "Homebrew tidak ditemukan. Menginstal Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew sudah terinstal."
fi

# Pastikan Homebrew ada di PATH (penting untuk shell non-interaktif)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Instal portaudio
echo "Menginstal atau memperbarui portaudio..."
brew install portaudio

# Instal dependensi Python
echo "Menginstal dependensi Python dari requirements.txt..."
pip3 install -r requirements.txt

echo "Instalasi semua dependensi untuk macOS selesai!"
echo "Anda sekarang dapat menjalankan bot dengan 'python3 main.py'"
