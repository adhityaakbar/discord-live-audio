import discord
from discord.ext import commands
import pyaudio
import threading
import time
import os
from dotenv import load_dotenv

load_dotenv() # Muat variabel lingkungan dari file .env

# --- Konfigurasi ---
BOT_TOKEN = os.getenv("BOT_TOKEN")
VOICE_CHANNEL_NAME = os.getenv("VOICE_CHANNEL_NAME", "General") # Default ke "General" jika tidak disetel
# ------------------

# --- Konfigurasi Audio ---
CHUNK = 1024
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 48000
# -------------------------

intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix="!", intents=intents)
p = pyaudio.PyAudio()

class MicrophoneAudioSource(discord.AudioSource):
    def __init__(self, p_audio, stream):
        self.p_audio = p_audio
        self.stream = stream

    def read(self):
        return self.stream.read(CHUNK, exception_on_overflow=False)

    def cleanup(self):
        self.stream.stop_stream()
        self.stream.close()

class AudioPlayer(discord.reader.AudioSink):
    def __init__(self):
        self.p = pyaudio.PyAudio()
        self.stream = self.p.open(format=FORMAT,
                                  channels=CHANNELS,
                                  rate=RATE,
                                  output=True,
                                  frames_per_buffer=CHUNK)
        self.thread = threading.Thread(target=self._play)
        self.buffer = bytearray()
        self.lock = threading.Lock()
        self.playing = True
        self.thread.start()

    def _play(self):
        while self.playing:
            with self.lock:
                if len(self.buffer) >= CHUNK * 2:
                    data = self.buffer[:CHUNK*2]
                    self.stream.write(data)
                    self.buffer = self.buffer[CHUNK*2:]
                else:
                    time.sleep(0.01) # Hindari busy-waiting

    def write(self, data):
        with self.lock:
            self.buffer += data.data

    def cleanup(self):
        self.playing = False
        self.thread.join()
        self.stream.stop_stream()
        self.stream.close()
        self.p.terminate()

@bot.event
async def on_ready():
    print(f'Bot telah masuk sebagai {bot.user}')
    voice_channel = discord.utils.get(bot.get_all_channels(), name=VOICE_CHANNEL_NAME)
    if voice_channel:
        print(f'Menemukan channel suara: {voice_channel.name}')
        try:
            vc = await voice_channel.connect()
            print(f'Berhasil terhubung ke channel suara: {voice_channel.name}')

            # Setup input stream (microphone)
            input_stream = p.open(format=FORMAT, channels=CHANNELS, rate=RATE, input=True, frames_per_buffer=CHUNK)
            microphone_source = MicrophoneAudioSource(p, input_stream)
            
            # Setup output sink (speaker)
            player_sink = AudioPlayer()
            vc.my_sink = player_sink # Attach sink to voice client for later access

            # Mulai mengirim audio dari mikrofon dan menerima audio
            vc.play(microphone_source, after=lambda e: print('Player error: %s' % e) if e else None)
            vc.listen(player_sink)
            
            print("Bot sekarang live! Audio dari mikrofon Anda sedang dikirim dan audio dari channel akan diputar.")

        except Exception as e:
            print(f'Gagal terhubung atau memulai audio: {e}')
    else:
        print(f'Channel suara dengan nama "{VOICE_CHANNEL_NAME}" tidak ditemukan.')

@bot.command()
async def stop(ctx):
    """Stops and disconnects the bot from voice"""
    if ctx.voice_client:
        # Hentikan dan bersihkan sumber audio dan sink
        ctx.voice_client.stop_listening()
        ctx.voice_client.stop()
        if ctx.voice_client.source:
            ctx.voice_client.source.cleanup()
        if hasattr(ctx.voice_client, 'my_sink'):
             ctx.voice_client.my_sink.cleanup()

        await ctx.voice_client.disconnect()
        print("Bot telah dihentikan dan koneksi ditutup.")


if __name__ == "__main__":
    if BOT_TOKEN is None:
        print("Kesalahan: Token bot tidak ditemukan.")
        print("Harap buat file .env di direktori yang sama dengan main.py")
        print("dan tambahkan BOT_TOKEN=YOUR_DISCORD_BOT_TOKEN ke dalamnya.")
    else:
        try:
            bot.run(BOT_TOKEN)
        finally:
            p.terminate()
            print("PyAudio dihentikan.")