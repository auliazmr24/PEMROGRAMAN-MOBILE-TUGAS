## 🧮 Karakteristik Kalkulator

| Fitur            | Deskripsi |
|------------------|-----------|
| **inputDigit()** | Menambahkan digit ke display (bukan increment) |
| **performOperation()** | Melakukan operasi (÷, ×, -, +) |
| **calculate()** | Menghitung hasil berdasarkan operator |
| **clear()** | Reset semua nilai |
| **inputDecimal()** | Menambahkan titik desimal |

## 📊 Perbandingan Lengkap: setState vs Provider

| Aspek            | setState Pattern                 | Provider Pattern                   |
|------------------|----------------------------------|------------------------------------|
| **Lokasi State** | Di dalam widget (lokal)          | Di luar widget (global)            |
| **Akses**        | Hanya 1 widget                    | Banyak widget                      |
| **Update**       | `setState(() {})`                | `notifyListeners()`                |
| **Kompleksitas** | Sederhana                        | Lebih terstruktur                  |
| **Use Case**     | Form, counter sederhana          | Shopping cart, user auth, theme    |
| **Sharing Data** | ❌ Susah                           | ✔ Mudah                            |
