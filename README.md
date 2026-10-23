# Project UTS: Tebak Game

Tebak Game adalah aplikasi kuis berbasis Flutter untuk menguji pengetahuan pengguna tentang game free-to-play. Setiap soal menampilkan gambar game dan petunjuk genre serta platform. Pengguna memilih satu judul dari empat pilihan jawaban.

Aplikasi mengambil data game secara dinamis dari FreeToGame API. Screenshot digunakan sebagai petunjuk jika tersedia; jika tidak, aplikasi menggunakan thumbnail game.

## Fitur Utama
- Kuis berisi 5 pertanyaan per sesi.
- Setiap pertanyaan memiliki gambar, petunjuk genre dan platform, serta 4 pilihan judul.
- Pilihan jawaban diacak.
- Skor dihitung berdasarkan jawaban yang benar.
- Halaman skor akhir dan tombol untuk bermain lagi.
- Menampilkan indikator loading dan pesan error saat data gagal dimuat.
- Tombol coba lagi untuk memuat ulang data dari API.
