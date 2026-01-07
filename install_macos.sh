#!/bin/bash

VENV_DIR="venv"

echo "Memulai instalasi dependensi untuk macOS..."

# Cek apakah Homebrew sudah terinstal, jika tidak, instal
if ! command -v brew &> /dev/null; then
    echo "Homebrew tidak ditemukan. Menginstal Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew sudah terinstal."
fi

# Pastikan Homebrew ada di PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Instal portaudio
echo "Menginstal atau memperbarui portaudio..."
brew install portaudio

# Membuat lingkungan virtual
echo "Membuat lingkungan virtual di '$VENV_DIR'..."
python3 -m venv $VENV_DIR

# Menginstal dependensi Python ke dalam lingkungan virtual, mengabaikan cache
echo "Menginstal dependensi Python dari requirements.txt (tanpa cache)..."
$VENV_DIR/bin/pip install --no-cache-dir -r requirements.txt

echo "Instalasi semua dependensi untuk macOS selesai!"
echo ""
echo "PENTING: Untuk menjalankan bot, Anda harus mengaktifkan lingkungan virtual terlebih dahulu."
echo "Jalankan perintah berikut:"
echo "source $VENV_DIR/bin/activate"
echo "Setelah itu, jalankan bot dengan:"
echo "python3 main.py"
