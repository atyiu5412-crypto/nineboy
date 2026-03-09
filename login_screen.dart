import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_screen.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login() async {
    // *** สำคัญ: เปลี่ยน IP เป็นเลข IPv4 ของคุณ (ห้ามใช้ localhost) ***
    final url = Uri.parse('http://172.24.163.18/pet_api/login.php'); 
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "email": _emailController.text,
          "password": _passwordController.text,
        }),
      );

      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        int uId = int.parse(result['user']['id'].toString());
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => MainNavigation(userId: uId))
        );
      } else {
        _showError(result['message']);
      }
    } catch (e) {
      _showError("เชื่อมต่อ API ไม่ได้: ตรวจสอบ IP และเปิด XAMPP");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Color(0xFF8D6E63), Color(0xFFD7CCC8)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // แก้ไขจากรูปที่ 1
          children: [
            const Text("Farm Hug", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)), // แก้ไขจากรูปที่ 1
            const Text("Pet Hotel & Cafe", style: TextStyle(fontSize: 18, color: Colors.white70)),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(controller: _emailController, decoration: const InputDecoration(labelText: "อีเมล", prefixIcon: Icon(Icons.email))),
                      TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "รหัสผ่าน", prefixIcon: Icon(Icons.lock))),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], minimumSize: const Size(double.infinity, 50)),
                        child: const Text("เข้าสู่ระบบ", style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                        child: Text("สมัครสมาชิกที่นี่", style: TextStyle(color: Colors.brown[700])),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}