# lab06

1. What is the difference between the Model, View, and ViewModel in this application?
= Perbedaan dari Model, View, dan ViewModel untuk aplikasi tersebut adalah model hanya menyimpan data, ViewModel yang membuat keputusan, dan View hanya menampilkan hasil.

2. What should happen if a student attempts to borrow a book that already has an active loan?
= ViewModel harus menolaknya. Di aplikasinya, borrowBook tidak menemukan buku yang tersedia dan mengembalikan BorrowResult.notEnoughStock. Layar hanya menampilkan pesan “Stok buku tidak mencukupi”.

3. Why is it better to calculate the fine in one place rather than repeating the formula in multiple widgets?
= Supaya konsisten hasilnya dan kalau misalnya ada perbaikan kepada rumus denda bisa dilakukan sekali tanpa mencari dibanyak widget.

4. What is the difference between a book being Overdue and being Missing?
= Perbedaan sebuah buku termasuk Overdue dan Missing terdapat pada berapa lama buku tersebut dipinjam dari perpustakaan. Kalau Overdue artinya sudah melewati 6 hari setelah peminjaman, tetapi belum melawati 6 bulan, dan Denda terus bertambah denda harian naik Rp5.000 setiap minggu penuh contoh, minggu pertama setekah hari ke-6 Rp5.000 per hari, minggu ke-2: Rp10.000 per hari, minggu ke-3: Rp15.000 per hari, dan seterusnya, naiknya Rp5.000 tiap minggu. Kalau Missing kalau masih belum dikembalikkan selama 6 bulan atau lebih, dan denda berhenti bertambah di tanggal itu, dan harga ganti buku ditambahkan

5. If the university changes its weekly fine from Rp5,000 to Rp7,000, how should the app be updated?
= Ubah satu baris di loan_service.dart
Dari 
    static const int weeklyRateIncrease = 5000;
Menjadi
    static const int weeklyRateIncrease = 7000;