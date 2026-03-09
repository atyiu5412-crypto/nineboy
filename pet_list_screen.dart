import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'booking_screen.dart';

class PetListScreen extends StatefulWidget {
  final int userId;
  const PetListScreen({super.key, required this.userId});

  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  List pets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserPets();
  }

  Future<void> fetchUserPets() async {
    // อย่าลืมเปลี่ยน IP ให้ตรงกับเครื่องคุณ
    final url = Uri.parse('http://172.24.163.18/pet_api/get_user_pets.php?user_id=${widget.userId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          setState(() {
            pets = result['data'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text("เลือกสัตว์เลี้ยงที่ต้องการจอง"),
        backgroundColor: Colors.brown[600],
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pets.isEmpty
              ? const Center(child: Text("ยังไม่มีข้อมูลสัตว์เลี้ยง กรุณาเพิ่มข้อมูลก่อน"))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return _buildPetCard(pet);
                  },
                ),
    );
  }

  Widget _buildPetCard(Map pet) {
    // แก้ไขจาก Icons.cat เป็น Icons.pets เพื่อแก้ Error ในรูปที่ 10
    IconData petIcon = Icons.pets; 
    Color iconColor = pet['pet_type'] == 'หมา' ? Colors.brown : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: CircleAvatar(
          backgroundColor: Colors.green[50],
          child: Icon(petIcon, color: iconColor),
        ),
        title: Text(pet['pet_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("ประเภท: ${pet['pet_type']} | อายุ: ${pet['age']} ปี"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
        onTap: () {
          // ส่ง pet_id ไปที่หน้า Booking
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(
                userId: widget.userId,
                petId: int.parse(pet['pet_id'].toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}