import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  // ฟังก์ชันสมัครสมาชิกที่แก้บัคหน้าจอดำแล้ว
  Future<void> register() async {
    // 1. แสดง Loading Dialog เพื่อล็อคหน้าจอ
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final url = Uri.parse('http://172.24.163.18/pet_api/register.php'); 
    
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "fullname": _fullnameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "phone": _phoneController.text,
        }),
      ).timeout(const Duration(seconds: 10)); // เพิ่ม Timeout กันแอปค้าง

      // 2. ปิด Loading Dialog ก่อนเสมอ
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        _showSnackBar("สมัครสมาชิกสำเร็จ!", Colors.green);
        
        // 3. หน่วงเวลาเล็กน้อยเพื่อให้ Snackbar แสดง แล้วค่อยกลับหน้า Login อย่างปลอดภัย
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.of(context).pop(); 
          }
        });
      } else {
        _showSnackBar(result['message'], Colors.red);
      }
    } catch (e) {
      // ปิด Loading และแจ้งเตือนเมื่อเกิด Error
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      _showSnackBar("เกิดข้อผิดพลาด: $e", Colors.red);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: color, content: Text(msg), duration: const Duration(seconds: 2))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text("สมัครสมาชิกใหม่", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Icon(Icons.person_add_alt_1, size: 80, color: Colors.green[700]),
            const SizedBox(height: 20),
            _buildInputCard(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("ยืนยันการสมัคร", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(_fullnameController, "ชื่อ-นามสกุล", Icons.person),
            _buildTextField(_emailController, "อีเมล", Icons.email),
            _buildTextField(_passwordController, "รหัสผ่าน", Icons.lock, isObscure: true),
            _buildTextField(_phoneController, "เบอร์โทรศัพท์", Icons.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isObscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.brown),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }
}