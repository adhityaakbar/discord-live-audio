#!/bin/bash

VENV_DIR="venv"

echo "Memulai instalasi dependensi sistem..."

# Perbarui daftar paket
sudo apt-get update -y

# Instal portaudio19-dev yang diperlukan oleh PyAudio
echo "Menginstal portaudio19-dev..."
sudo apt-get install -y portaudio19-dev

# Instal pip dan venv jika belum ada
echo "Memeriksa dan menginstal python3-pip dan python3-venv..."
sudo apt-get install -y python3-pip python3-venv

# Membuat lingkungan virtual
echo "Membuat lingkungan virtual di '$VENV_DIR'..."
python3 -m venv $VENV_DIR

# Menginstal dependensi Python ke dalam lingkungan virtual, mengabaikan cache
echo "Menginstal dependensi Python dari requirements.txt (tanpa cache)..."
$VENV_DIR/bin/pip install --no-cache-dir -r requirements.txt

echo "Instalasi semua dependensi selesai!"
echo ""
echo "PENTING: Untuk menjalankan bot, Anda harus mengaktifkan lingkungan virtual terlebih dahulu."
echo "Jalankan perintah berikut:"
echo "source $VENV_DIR/bin/activate"
echo "Setelah itu, jalankan bot dengan:"
echo "python3 main.py"
