import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Kontak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        cardColor: Colors.grey[800],
      ),
      themeMode: _themeMode,
      home: ContactListPage(
        toggleTheme: _toggleTheme,
        currentTheme: _themeMode,
      ),
    );
  }
}

class Contact {
  final String name;
  final String phone;
  final String status;

  Contact({required this.name, required this.phone, required this.status});
}

class ContactListPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode currentTheme;

  ContactListPage({super.key, required this.toggleTheme, required this.currentTheme});

  final List<Contact> contacts = [
    Contact(name: 'Aulia Zamaira', phone: '08123456789', status: 'Online'),
    Contact(name: 'Budi Santoso', phone: '08234567890', status: 'Away'),
    Contact(name: 'Citra Dewi', phone: '08345678901', status: 'Offline'),
    Contact(name: 'Doni Pratama', phone: '08456789012', status: 'Online'),
    Contact(name: 'Eka Lestari', phone: '08567890123', status: 'Online'),
    Contact(name: 'Fajar Hidayat', phone: '08678901234', status: 'Away'),
    Contact(name: 'Gina Marlina', phone: '08789012345', status: 'Offline'),
    Contact(name: 'Hendra Saputra', phone: '08890123456', status: 'Online'),
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Online':
        return Colors.green;
      case 'Away':
        return Colors.orange;
      case 'Offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showAvatarDialog(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Gambar Profil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60, // lebih besar dari sebelumnya
                    backgroundColor:
                        // ignore: deprecated_member_use
                        Theme.of(context).primaryColor.withOpacity(0.2),
                    child: Icon(Icons.person,
                        size: 60, color: Theme.of(context).primaryColor),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: CircleAvatar(
                      radius: 12, // lingkaran status lebih besar
                      backgroundColor: getStatusColor(contact.status),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                contact.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kontak'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              currentTheme == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: GestureDetector(
                onTap: () => _showAvatarDialog(context, contact),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          // ignore: deprecated_member_use
                          Theme.of(context).primaryColor.withOpacity(0.2),
                      child: Icon(Icons.person,
                          size: 28, color: Theme.of(context).primaryColor),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: getStatusColor(contact.status),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                contact.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.phone,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Status: ${contact.status}',
                    style: TextStyle(
                      fontSize: 12,
                      color: getStatusColor(contact.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.call, color: Colors.blue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Memanggil ${contact.name}...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}