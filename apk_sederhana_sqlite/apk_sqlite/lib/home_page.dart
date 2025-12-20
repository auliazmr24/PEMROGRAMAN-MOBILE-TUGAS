import 'package:flutter/material.dart';
import 'db/db_helper.dart';
import 'add_transaction_page.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  int saldo = 0;

  @override
  void initState() {
    super.initState();
    loadSaldo();
  }

  Future<void> loadSaldo() async {
    final transactions = await dbHelper.getTransactions();
    int total = 0;
    for (var t in transactions) {
      if (t['type'] == 'IN') {
        total += t['amount'] as int;
      } else {
        total -= t['amount'] as int;
      }
    }
    setState(() {
      saldo = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'FlowDana',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: loadSaldo,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Card Saldo Utama
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade400, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'DANA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Total Saldo',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${_formatNumber(saldo)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.add_circle,
                    label: 'Pemasukan',
                    color: Colors.green,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddTransactionPage(type: 'IN'),
                        ),
                      );
                      loadSaldo();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.remove_circle,
                    label: 'Pengeluaran',
                    color: Colors.red,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddTransactionPage(type: 'OUT'),
                        ),
                      );
                      loadSaldo();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Tombol Riwayat
            _buildFullWidthButton(
              context,
              icon: Icons.history,
              label: 'Lihat Riwayat Transaksi',
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}