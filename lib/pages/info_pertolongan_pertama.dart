import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdonor/controllers/themes_controller.dart';
import 'package:getdonor/utils/components/app_bar.dart';
import 'package:getdonor/utils/expandable_container.dart';

import '../utils/colors.dart';

class InfoPertolonganPertama extends StatelessWidget {
  const InfoPertolonganPertama({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
            bgColor: Theme.of(context).scaffoldBackgroundColor,
            iconColor: themeController.isDarkTheme()
                ? Color(kLight.value)
                : Color(kDarkicon.value),
            text: 'Informasi Lainnya',
            centerTitle: false,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            )),
      ),
      body: const SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            ExpandableContainer(
                textTitle: 'Pengertian Pertolongan Pertama',
                textContent:
                    'adalah Pemberian pertolongan segera kepada penderita sakit atau cedera / kecelakaan yang memerlukan penanganan medis dasar.'),
            ExpandableContainer(
                textTitle: 'Pelaku Pertolongan Pertama',
                textContent:
                    'adalah Pemberian pertolongan segera kepada penderita sakit atau cedera / kecelakaan yang memerlukan penanganan medis dasar.'),
            ExpandableContainer(
                textTitle: 'Tujuan Pertolongan Pertama',
                textContent:
                    'a. Menyelamatkan jiwa penderita.\nb. Mencegah cacat.\nc. Memberikan rasa nyaman dan menunjang proses penyembuhan.'),
            ExpandableContainer(
                textTitle: 'Kewajiban Pelaku Pertolongan Pertama',
                textContent:
                    'a. Menjaga keselamatan diri, anggota tim, penderita dan orang sekitarnya. Karena keselamatan diri dan tim harus menjadi prioritas.\nb. Dapat menjangkau penderita. Dalam kasus kecelakaan atau musibah kemungkinan pelaku harus memindahkan penderita lain untuk dapat menjangkau penderita ynag lebih parah.\nc. Dapat mengenali dan mengatasi masalah yang mengancam nyawa.\nd. Meminta bantuan / rujukan. Pelaku pertolongan pertama harus bertanggung jawab sampai bantuan rujukan mengambil alih penanganan penderita.\ne. Memberikan pertolongan dengan cepat dan tepat berdasarkan keadaan korban.\nf. Membantu pelaku pertolongan pertama lainnya.\ng. Ikut menjaga kerahasiaan medis penderita.\nh. Melakukan komunikasi dengan petugas lain yang terlibat.\ni. Mempersiapkan penderita untuk ditransportasi.'),
            ExpandableContainer(
                textTitle: 'Alat Pelindung Diri (APD)',
                textContent:
                    'Sebagai pelaku pertolongan pertama seseorang akan dengan mudah terpapar dengan jasad renik maupun cairan tubuh seseorang yang memungkinkan penolong dapat tertular oleh penyakit. Prinsip utama dalam menghadapi darah dan cairan tubuh dari penderita adalah darah dan semua cairan tubuh sebagai media penularan penyakit.\n\nBeberapa penyakit yang dapat menular di antaranya adalah Hepatitis, TBC, HIV/AIDS. Disamping itu, APD juga berfungsi untuk mencegah penolong mengalami luka dalam melakukan tugasnya.'),
            ExpandableContainer(
                textTitle: 'Beberapa APD antara lain',
                textContent:
                    '1. Sarung tangan lateks. Jangan menggunakan sarung tangan kain saja karena cairan dapat merembes. Bila akan melakukan tindakan lainnya yang memerlukan sarung tangan kerja, maka sebaiknya sarung tangan lateks dipakai terlebih dahulu.\n2. Kacamata pelindung. Berguna untuk melindungi mata dari percikan darah, maupun mencegah terjadinya cedera akibat benturan atau kelilipan pada mata saat melakukan pertolongan.\n3. Baju pelindung. Penggunanya kurang popular di Indonesia, gunanya adalh untuk mencegah merembesnya cairan tubuh penderita melalui baju penolong.\n4. Masker penolong. Sangat berguna untuk mencegah penularan penyakit melalui udara.\n5. Masker resusitasi. Diperlukan bila akan melakukan Resusitasi Jantung Paru (RJP).\n6. Helm. Dipakai bila akan bekerja ditempat yang rawan akan jatuhnya benda dari atas. Misalnya dalam bangunan runtuh dan sebagainya.'),
            ExpandableContainer(
                textTitle: 'Pelatihan Pertolongan Pertama',
                textContent:
                    'Pelatihan pertolongan pertama adalah suatu pelatihan yang diberikan kepada tenaga kerja pada suatu perusahaan atau instansi dan perorangan sebagai bentuk antisipasi terhadap terjadinya kecelakaan diri atau kejadian di tempat kerja, sehingga terampil memberikan pertolongan pertama dan mampu menyelamatkan jiwa.\n\nPelatihan Pertolongan Pertama dilaksanakan sesuai dengan :\n\n• UU RI No.1 Tahun 1970 tentang Keselamatan dan Kesehatan Kerja. • Permenkes RI No.23/Birhub/1972 tentang Tugas PMI di Bidang Kesehatan.\n• UU No.13 Tahun 2003 tentang Ketenagakerjaan.\n• Permenaker RI No. Per-15/Men/VIII/2008 tentang Pertolongan Pertama pada kecelakaan di tempat kerja.\nPalang Merah Indonesia (PMI) Provinsi DKI Jakarta memiliki pelatih atau instruktur yang kompeten di bidangnya, dan selalu siap membantu perusahaan atau perorangan yang akan melaksanakan pelatihan pertolongan pertama. Metode pelatihan Program pelatihan akan dilakukan secara interaktif dan menggunakan kombinasi berbagai metode pembelajaran mencakup :\n\n• Teori        : 40% \n• Praktek    : 60%\n• Ceramah, Praktek, Simulasi dan Diskusi.\n\nDalam pelatihan ini akan banyak menggunakan perlengkapan, alat peraga dan perlengkapan lain yang mendukung. Dengan demikian pelatihan ini benar-benar dapat lebih aplikatif dan menjembatani berbagai metode peserta dalam menyerap pelajaran.'),
            ExpandableContainer(
                textContent:
                    '• Kurangi konsumsi garam (natrium). Batasi makanan yang tinggi garam seperti makanan olahan, makanan cepat saji, dan camilan asin.\n\n• Tingkatkan asupan kalium dengan mengonsumsi buah-buahan (seperti pisang, jeruk, dan alpukat) dan sayuran (seperti bayam dan kentang).\n\n• Fokus pada diet rendah lemak jenuh, tinggi serat, dan kaya akan nutrisi seperti biji-bijian utuh, ikan berlemak, dan produk susu rendah lemak.',
                textTitle: 'Pola Makan Sehat'),
            ExpandableContainer(
                textContent:
                    '1.  Pola Makan Sehat :\n• Konsumsi makanan yang kaya akan nutrisi seperti buah-buahan, sayuran, biji-bijian utuh, protein sehat (misalnya, ayam tanpa kulit, ikan, kacang-kacangan, dan kedelai), serta produk susu rendah lemak.\n• Batasi makanan tinggi gula, makanan cepat saji, camilan yang tinggi lemak dan gula, serta minuman beralkohol.\n• Hindari makan berlebihan. Cobalah untuk mengontrol porsi makan dan menghindari makanan berkalori tinggi dalam jumlah besar\n\n2.  Perencanaan Makanan :\n• Rencanakan makanan Anda dan persiapkan makanan sendiri jika memungkinkan. Ini membantu Anda memiliki kendali lebih besar atas apa yang Anda konsumsi.\n• Jangan melewatkan sarapan, karena sarapan dapat membantu mengatur nafsu makan sepanjang hari.\n\n3.  Kontrol Porsi Makan :\n• Lakukan aktivitas fisik secara teratur. Ini dapat termasuk berjalan cepat, berlari, bersepeda, berenang, atau latihan lainnya yang Anda nikmati.\n• Usahakan untuk berolahraga setidaknya 150 menit per minggu, sesuai dengan rekomendasi dokter.\n\n4.  Kontrol Porsi Makan :\n• Hindari makan berlebihan dengan memperhatikan ukuran porsi makanan Anda. Gunakan piring yang lebih kecil jika perlu.\n• Makan perlahan dan nikmati makanan Anda, sehingga Anda lebih sadar saat sudah kenyang.\n\n5.  Hindari Makanan Cepat Saji dan Camilan Tidak Sehat :\n• Batasi konsumsi makanan cepat saji, camilan yang tinggi gula dan lemak, serta minuman bersoda.\n\n6.  Minum Air Secukupnya :\n• Pastikan Anda cukup minum air putih setiap hari. Terkadang, rasa haus bisa disalahartikan sebagai rasa lapar.\n\n7.  Jurnal Makanan :\n• Menjaga catatan tentang apa yang Anda makan dan minum dapat membantu Anda mengidentifikasi kebiasaan makan yang tidak sehat dan membuat perubahan yang diperlukan.\n\n8.  Kendalikan Stres :\n• Stres dapat memengaruhi pola makan. Cobalah teknik relaksasi seperti meditasi, yoga, atau olahraga untuk mengurangi stres.\n\n9.  Konsultasi dengan Ahli Gizi atau Dokter :\n• Jika Anda memiliki masalah berat badan yang serius, pertimbangkan untuk berkonsultasi dengan seorang ahli gizi atau dokter untuk membuat rencana yang sesuai dengan kebutuhan kesehatan Anda.\n\n10.  Jaga Konsistensi :\n• Yang terpenting adalah menjaga konsistensi. Upaya jangka panjang lebih berhasil daripada upaya cepat-celaka yang tidak bisa dipertahankan.',
                textTitle: 'Mengontrol Berat Badan'),
            ExpandableContainer(
                textContent:
                    '1. Tetapkan Tujuan yang Jelas :\n• Tentukan tujuan olahraga yang spesifik, terukur, dan realistis. Misalnya, berapa kali seminggu Anda ingin berolahraga, berapa lama, atau target peningkatan kesehatan apa yang ingin Anda capai\n\n2. Buat Rencana Jadwal :\n• nJadwalkan sesi olahraga dalam kalender Anda seperti janji penting lainnya. Ini akan membantu Anda melibatkan diri secara teratur.\n\n3. Pilih Aktivitas yang Anda Nikmati :\n• Pilih jenis olahraga atau aktivitas yang Anda nikmati. Jika Anda menikmatinya, Anda lebih cenderung untuk tetap konsisten.\n\n4. Temukan Teman atau Partner Olahraga :\n• Berolahraga dengan teman atau pasangan bisa membuatnya lebih menyenangkan dan memberikan akuntabilitas satu sama lain.\n\n5. Mulailah Dengan Sesuat yang Realistis :\n• Jika Anda baru memulai, jangan terlalu ambisius. Mulailah dengan sesi olahraga yang ringan dan tingkatkan secara bertahap.\n\n6. Variasi Aktvitas :\n• Jangan bosan dengan melakukan hal yang sama berulang-ulang. Cobalah berbagai jenis olahraga atau aktivitas fisik untuk menjaga keberagaman dan menjaga semangat.\n\n7. Sisihkan Waktu yang Khusus untuk Olahraga :\n• Sisihkan waktu khusus untuk berolahraga, baik itu di pagi hari sebelum pekerjaan atau di malam hari setelah pekerjaan. Jadikan itu sebagai prioritas.\n\n8. Gunakan Alat Bantu :\n• Gunakan alat bantu seperti aplikasi kebugaran atau tracker aktivitas fisik untuk memantau kemajuan Anda. Ini dapat memberikan motivasi tambahan.\n\n9. Jangan Pernah Menyerah :\n• Jika Anda melewatkan sesi olahraga atau terhenti sementara, jangan menyerah. Terkadang, ada halangan yang tidak dapat dihindari. Lanjutkan kembali secepat mungkin.\n\n10. Konsultasikan dengan Ahli Kesehatan\n• Sebelum memulai program olahraga baru, konsultasikan dengan dokter Anda, terutama jika Anda memiliki kondisi medis tertentu atau sudah lama tidak berolahraga.',
                textTitle: 'Olahraga Teratur'),
            ExpandableContainer(
                textContent:
                    '1. Tentukan Tujuan yang Jelas :\n• Tetapkan tujuan yang spesifik dan realistis untuk mengurangi atau berhenti minum alkohol. Misalnya, Anda dapat merencanakan untuk tidak minum alkohol selama sebulan pertama, kemudian perpanjang tujuan Anda.\n\n2. Buat Rencana dan Komitmen :\n• Buat rencana yang jelas tentang kapan dan di bawah kondisi apa Anda akan menghindari alkohol. Bagi rencana ini dengan teman-teman atau keluarga Anda agar mereka dapat memberikan dukungan.\n\n3. Hindari Lingkungan yang Mendorong Minum Alkohol :\n• Jika Anda tahu bahwa Anda cenderung minum alkohol dalam situasi tertentu atau di lokasi tertentu, hindarilah situasi atau lingkungan itu.\n\n4. Tingkatkan Kesadaran Anda :\n• Cobalah untuk lebih sadar tentang pola minum alkohol Anda. Catat kapan, di mana, dan berapa banyak alkohol yang Anda konsumsi.\n\n5. Hindari Godaan Untuk Minum Alkohol :\n• Cari kegiatan seputar agama agar terhindar dari godaan untuk minum alkohol • Buang atau hindari alkohol di rumah Anda sehingga Anda tidak tergoda untuk minum.\n\n6. Carilah Dukungan Sosial :\n• Gantilah kebiasaan minum alkohol dengan aktivitas lain yang sehat dan bermanfaat, seperti berolahraga, belajar, atau berpartisipasi dalam kegiatan sosial tanpa alkohol.\n\n8. Konsultasikan dengan Ahli Kesehatan :\n• Jika Anda mengalami kesulitan mengurangi konsumsi alkohol, pertimbangkan untuk berkonsultasi dengan profesional kesehatan, seperti seorang terapis atau konselor yang memiliki pengalaman dalam membantu individu mengatasi masalah alkohol.\n\n9. Ikuti Program Dukungan :\n• Pertimbangkan untuk bergabung dengan kelompok dukungan atau program pemulihan alkohol, seperti Alcoholic Anonymous (AA) atau program serupa, jika diperlukan.\n\n10. Perhatikan Perubahan Kesehatan Anda :\n• Perhatikan perubahan positif dalam kesehatan dan kualitas hidup Anda ketika Anda mengurangi atau berhenti minum alkohol. Ini dapat menjadi motivasi tambahan.',
                textTitle: 'Mengurangi Konsumsi Alkohol'),
            ExpandableContainer(
                textContent:
                    '1. Buang Rokok dan Barang-barang Terkait :\n• Buang semua rokok, korek api, asbak, dan barang-barang terkait lainnya dari rumah, mobil, dan tempat kerja. Ini dapat mengurangi godaan.\n\n2. Identifikasi Pemicu Untuk Merokok :\n• Identifikasi situasi atau kejadian yang memicu keinginan untuk merokok, seperti stres, perayaan, atau berada di lingkungan di mana Anda biasanya merokok. Kemudian, cari cara untuk mengatasi pemicu ini tanpa merokok.\n\n5. Gantilah Kebiasaan :\n• Gantilah kebiasaan merokok dengan aktivitas yang sehat dan bermanfaat, seperti berolahraga, berkumpul dengan teman-teman yang tidak merokok, atau mengejar hobi baru.\n\n6. Gunakan Terapi Pengganti Nikotin :\n• Pertimbangkan untuk menggunakan produk pengganti nikotin seperti permen karet, plester nikotin, atau inhalator nikotin. Produk ini dapat membantu mengurangi keinginan merokok.\n\n7. Jangan Menyerah :\n• Jika Anda merokok lagi setelah berhenti, jangan menyerah. Jangan anggap kegagalan sebagai akhir dari upaya Anda untuk berhenti. Banyak orang perlu mencoba beberapa kali sebelum berhasil berhenti merokok.',
                textTitle: 'Berhenti Merokok'),
            ExpandableContainer(
                textContent:
                    '1. Tentukan Batasan Harian :\n• Tetapkan batasan harian untuk konsumsi kafein dan patuhi batasan tersebut. Rekomendasi konsumsi kafein harian yang aman bervariasi tergantung pada individu, tetapi sekitar 400 mg kafein (setara dengan sekitar empat cangkir kopi) adalah tingkat yang umumnya dianggap aman untuk kebanyakan orang.\n\n2. Pantau Asupan Kafein :\n• Perhatikan sumber-sumber kafein dalam diet Anda. Selain kopi, kafein juga dapat ditemukan dalam teh, minuman ringan berkafein, minuman energi, dan beberapa suplemen makanan. Baca label dengan cermat untuk mengetahui berapa banyak kafein yang Anda konsumsi.\n\n3. Kurangi Konsumsi Secara Bertahap :\n• Jika Anda telah kecanduan kafein, kurangi konsumsi secara bertahap daripada berhenti secara tiba-tiba. Ini akan membantu mengurangi gejala penarikan yang tidak nyaman seperti sakit kepala dan kelelahan.\n\n4. Ganti dengan Pilihan Non-kafein :\n• Pertimbangkan untuk menggantikan minuman berkafein dengan minuman non-kafein seperti air putih, teh herbal tanpa kafein, atau minuman herbal lainnya yang tidak mengandung kafein.\n\n5. Hindari Kafein di Malam Hari :\n• Hindari konsumsi kafein terutama di malam hari karena dapat mengganggu tidur. Tidur yang cukup sangat penting untuk kesehatan dan kesejahteraan Anda.\n\n6. Cari Alternatif untuk Energi :\n• Jika Anda mengonsumsi kafein untuk mendapatkan energi, pertimbangkan untuk mencari cara alami untuk meningkatkan energi Anda, seperti dengan olahraga teratur, tidur yang cukup, dan diet sehat.',
                textTitle: 'Batasi Konsumsi Kafein'),
            ExpandableContainer(
                textContent:
                    '1. Masukkan Nomor Induk Kependudukan yang telah digunakan saat melakukan pendaftaran akun sebelumya\n2. Jika NIK yang dimasukkan sudah benar sesuai dengan data yang tersimpan dalam database.\n3. Lakukan pengubahan password atau edit profile pada bagian lupa password atau edit profile (Harap Mengisi Data Sesuai dengan KTP)\n4. Jika Nomor Induk Kependudukan anda belum tersedia, harap melakukan registrasi ulang.',
                textTitle: 'Check NIK untuk Edit Profile atau Lupa Password')
          ],
        ),
      )),
    );
  }
}
