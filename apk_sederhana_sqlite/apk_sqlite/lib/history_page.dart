import 'package:flutter/material.dart';
import 'db/db_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> transactions = [];
  String filter = 'ALL'; // ALL, IN, OUT

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final data = await dbHelper.getTransactions();
    setState(() {
      transactions = data.reversed.toList(); // Terbaru di atas
    });
  }

  List<Map<String, dynamic>> get filteredTransactions {
    if (filter == 'ALL') return transactions;
    return transactions.where((t) => t['type'] == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterChip('Semua', 'ALL'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip('Pemasukan', 'IN'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip('Pengeluaran', 'OUT'),
                ),
              ],
            ),
          ),

          // List Transaksi
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada transaksi',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: loadTransactions,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final t = filteredTransactions[index];
                        final isIncome = t['type'] == 'IN';
                        final color = isIncome ? Colors.green : Colors.red;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isIncome
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: color,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              t['description'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    t['wallet'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Text(
                              '${isIncome ? '+' : '-'} Rp ${_formatNumber(t['amount'])}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: color,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = filter == value;
    Color color;

    if (value == 'IN') {
      color = Colors.green;
    } else if (value == 'OUT') {
      color = Colors.red;
    } else {
      color = Colors.teal;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          filter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
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