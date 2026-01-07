#!/bin/bash

# Pilih interpreter Python: utamakan python3.12, jika tidak ada, gunakan python3
if command -v python3.12 &> /dev/null; then
    PYTHON_CMD="python3.12"
else
    PYTHON_CMD="python3"
fi
echo "Menggunakan interpreter Python: $PYTHON_CMD"

VENV_DIR="venv"

echo "Memulai instalasi dependensi untuk macOS..."

# Cek apakah Homebrew sudah terinstal
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

# Hapus lingkungan virtual lama
echo "Menghapus lingkungan virtual lama (jika ada)..."
rm -rf $VENV_DIR

# Membuat lingkungan virtual baru
echo "Membuat lingkungan virtual baru di '$VENV_DIR' menggunakan $PYTHON_CMD..."
$PYTHON_CMD -m venv $VENV_DIR

# Menginstal dependensi Python
echo "Menginstal dependensi Python dari requirements.txt (tanpa cache)..."
$VENV_DIR/bin/pip install --no-cache-dir -r requirements.txt

echo "Instalasi semua dependensi untuk macOS selesai!"
echo ""
echo "PENTING: Untuk menjalankan bot, Anda harus mengaktifkan lingkungan virtual terlebih dahulu."
echo "Jalankan perintah berikut:"
echo "source $VENV_DIR/bin/activate"
echo "Setelah itu, jalankan bot dengan:"
echo "$PYTHON_CMD main.py"
