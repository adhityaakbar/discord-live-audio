#!/bin/bash

# Pilih interpreter Python: utamakan python3.12, jika tidak ada, gunakan python3
if command -v python3.12 &> /dev/null; then
    PYTHON_CMD="python3.12"
else
    PYTHON_CMD="python3"
fi
echo "Menggunakan interpreter Python: $PYTHON_CMD"

VENV_DIR="venv"

echo "Memulai instalasi dependensi sistem..."

# Perbarui daftar paket
sudo apt-get update -y

# Instal portaudio19-dev
echo "Menginstal portaudio19-dev..."
sudo apt-get install -y portaudio19-dev

# Instal pip dan venv
echo "Memeriksa dan menginstal python3-pip dan python3-venv..."
sudo apt-get install -y python3-pip python3-venv

# Hapus lingkungan virtual lama
echo "Menghapus lingkungan virtual lama (jika ada)..."
rm -rf $VENV_DIR

# Membuat lingkungan virtual baru
echo "Membuat lingkungan virtual baru di '$VENV_DIR' menggunakan $PYTHON_CMD..."
$PYTHON_CMD -m venv $VENV_DIR

# Menginstal dependensi Python
echo "Menginstal dependensi Python dari requirements.txt (tanpa cache)..."
$VENV_DIR/bin/pip install --no-cache-dir -r requirements.txt

echo "Instalasi semua dependensi selesai!"
echo ""
echo "PENTING: Untuk menjalankan bot, Anda harus mengaktifkan lingkungan virtual terlebih dahulu."
echo "Jalankan perintah berikut:"
echo "source $VENV_DIR/bin/activate"
echo "Setelah itu, jalankan bot dengan:"
echo "$PYTHON_CMD main.py"
