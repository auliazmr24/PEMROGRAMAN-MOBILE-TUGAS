import 'package:flutter/material.dart';
import 'db/db_helper.dart';

class AddTransactionPage extends StatefulWidget {
  final String type; // 'IN' atau 'OUT'

  const AddTransactionPage({super.key, required this.type});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool isLoading = false;

  Future<void> simpanTransaksi() async {
    if (descController.text.isEmpty || amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await dbHelper.insertTransaction({
      'wallet': 'DANA',
      'description': descController.text,
      'amount': int.parse(amountController.text),
      'type': widget.type,
    });

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaksi berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = widget.type == 'IN';
    final color = isIncome ? Colors.green : Colors.red;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          isIncome ? 'Tambah Pemasukan' : 'Tambah Pengeluaran',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon & Title
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: color,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isIncome ? 'Pemasukan' : 'Pengeluaran',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form Input
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dompet',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet,
                            color: Colors.teal),
                        const SizedBox(width: 12),
                        const Text(
                          'DANA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nominal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      prefixText: 'Rp ',
                      prefixStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: color, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Keterangan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Gaji bulanan, Beli makan, dll',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: color, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Simpan
            ElevatedButton(
              onPressed: isLoading ? null : simpanTransaksi,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Simpan Transaksi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    descController.dispose();
    amountController.dispose();
    super.dispose();
  }
}