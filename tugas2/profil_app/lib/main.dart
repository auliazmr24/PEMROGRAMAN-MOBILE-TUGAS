import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilApp());
}

class ProfilApp extends StatelessWidget {
  const ProfilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Produk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const ProfilProdukPage(),
    );
  }
}

class ProfilProdukPage extends StatelessWidget {
  const ProfilProdukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Profil Produk'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // FOTO PRODUK
            CircleAvatar(
              radius: 70,
              backgroundImage: const AssetImage('assets/images/aulia.jpg'),
              backgroundColor: Colors.indigo.shade100,
            ),
            const SizedBox(height: 20),

            // NAMA PRODUK
            const Text(
              'Tesla Model S',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Mobil Listrik Premium',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // ICON BAR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.speed, color: Colors.indigo),
                SizedBox(width: 5),
                Text('200 km/jam'),
                SizedBox(width: 20),
                Icon(Icons.battery_charging_full, color: Colors.green),
                SizedBox(width: 5),
                Text('600 km range'),
              ],
            ),
            const SizedBox(height: 30),

            // CARD DESKRIPSI
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Deskripsi Produk',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tesla Model S adalah mobil listrik mewah dengan performa tinggi dan desain futuristik. '
                      'Dilengkapi dengan autopilot, layar sentuh besar, dan sistem penggerak semua roda.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // TOMBOL AKSI
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('Pesan Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pesanan Anda sedang diproses...'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}