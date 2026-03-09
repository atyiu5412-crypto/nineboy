import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart'; // เพื่อให้เรียกใช้ MainNavigation ได้

class AddPetScreen extends StatefulWidget {
  final int userId;
  const AddPetScreen({super.key, required this.userId});

  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  String _selectedType = 'สุนัข';

  // --- ฟังก์ชันแสดงหน้าต่างสำเร็จ (Success Dialog) ---
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text("บันทึกสำเร็จ!", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("ข้อมูลสัตว์เลี้ยงของคุณถูกบันทึกแล้ว", textAlign: TextAlign.center),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  minimumSize: const Size(120, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // ปิด Dialog
                  Navigator.of(context).pop(); 
                  // เด้งไปหน้าหลัก (MainNavigation) และล้างประวัติการเปิดหน้าเก่าทิ้งทั้งหมด (กันหน้าจอดำ)
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainNavigation(userId: widget.userId)),
                    (route) => false,
                  );
                },
                child: const Text("ตกลง", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- ฟังก์ชันบันทึกข้อมูล ---
  Future<void> savePet() async {
    // แสดงตัวโหลดหมุนๆ (Loading)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final url = Uri.parse('http://172.24.163.18/pet_api/add_pet.php');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "user_id": widget.userId,
          "pet_name": _nameController.text,
          "pet_type": _selectedType,
          "pet_breed": _breedController.text,
        }),
      ).timeout(const Duration(seconds: 10));

      // ปิด Loading
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        // เมื่อสำเร็จ ให้แสดง Success Dialog
        _showSuccessDialog();
      } else {
        _showSnackBar(result['message'], Colors.red);
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      _showSnackBar("การเชื่อมต่อล้มเหลว: $e", Colors.red);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: color, content: Text(msg))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text("เพิ่มสัตว์เลี้ยงใหม่"),
        backgroundColor: Colors.brown[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.pets, size: 80, color: Colors.brown),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController, 
                      decoration: const InputDecoration(labelText: "ชื่อสัตว์เลี้ยง", prefixIcon: Icon(Icons.edit))
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      items: ['สุนัข', 'แมว', 'นก', 'อื่นๆ'].map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedType = val.toString()),
                      decoration: const InputDecoration(labelText: "ประเภท", prefixIcon: Icon(Icons.category)),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _breedController, 
                      decoration: const InputDecoration(labelText: "สายพันธุ์", prefixIcon: Icon(Icons.pets))
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: savePet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("บันทึกข้อมูล", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}