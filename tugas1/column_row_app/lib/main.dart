import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas 1 (Baris & Kolom)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // warna background lembut
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian judul
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 16, bottom: 10),
            child: Text(
              'Tugas 1 Baris & Kolom',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          // Bar biru dengan ikon (warna ikon hitam)
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home, color: Colors.black, size: 28),
                    SizedBox(height: 4),
                    Text(
                      'Home',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search, color: Colors.black, size: 28),
                    SizedBox(height: 4),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications, color: Colors.black, size: 28),
                    SizedBox(height: 4),
                    Text(
                      'Notifications',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bagian isi kosong
          const Expanded(
            child: Center(
              child: Text(''),
            ),
          ),
        ],
      ),
    );
  }
}
