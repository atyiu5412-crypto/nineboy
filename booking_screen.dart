import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'main.dart'; // เพื่อให้เรียกใช้ MainNavigation ได้

class BookingScreen extends StatefulWidget {
  final int userId;
  final int petId;
  const BookingScreen({super.key, required this.userId, required this.petId});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List services = [];
  List petList = [];
  int? selectedPetId;
  List<int> selectedServiceIds = [];
  double totalPrice = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  // ดึงข้อมูลบริการและรายชื่อสัตว์เลี้ยง
  Future<void> fetchAllData() async {
    const ip = '172.24.163.18';
    try {
      final resServices = await http.get(Uri.parse('http://$ip/pet_api/get_services.php'));
      final resPets = await http.get(Uri.parse('http://$ip/pet_api/get_user_pets.php?user_id=${widget.userId}'));

      if (resServices.statusCode == 200 && resPets.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          services = jsonDecode(resServices.body);
          petList = jsonDecode(resPets.body);
          if (petList.isNotEmpty) {
            selectedPetId = int.parse(petList[0]['pet_id']);
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _calculateTotal() {
    double total = 0;
    for (var service in services) {
      if (selectedServiceIds.contains(int.parse(service['service_id']))) {
        total += double.parse(service['price_per_day']);
      }
    }
    setState(() => totalPrice = total);
  }

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
              const Text("จองสำเร็จ!", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("เราได้รับรายการจองของคุณเรียบร้อยแล้ว", textAlign: TextAlign.center),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  minimumSize: const Size(120, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); 
                  // เด้งไปหน้าหลัก (Home) และล้าง Stack ทั้งหมด (กันหน้าจอดำ)
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

  // ฟังก์ชันกดยืนยันการจอง
  Future<void> confirmBooking() async {
    if (selectedPetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("กรุณาเลือกสัตว์เลี้ยง")));
      return;
    }
    if (selectedServiceIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("กรุณาเลือกบริการ")));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.post(
        Uri.parse('http://172.24.163.18/pet_api/save_booking.php'),
        body: jsonEncode({
          "user_id": widget.userId,
          "pet_id": selectedPetId,
          "total_price": totalPrice,
          "services": selectedServiceIds,
        }),
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        _showSuccessDialog(); // เรียก Dialog สำเร็จ
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(title: const Text("จองบริการ"), backgroundColor: Colors.green[800], foregroundColor: Colors.white),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildPetSelector(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final s = services[index];
                      final sId = int.parse(s['service_id']);
                      final isSelected = selectedServiceIds.contains(sId);
                      return Card(
                        child: CheckboxListTile(
                          title: Text(s['service_name']),
                          subtitle: Text("ราคา: ${s['price_per_day']} บาท/วัน"),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              value == true ? selectedServiceIds.add(sId) : selectedServiceIds.remove(sId);
                              _calculateTotal();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                _buildSummaryPanel(),
              ],
            ),
    );
  }

  Widget _buildPetSelector() {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonFormField<int>(
        value: selectedPetId,
        decoration: const InputDecoration(labelText: "เลือกสัตว์เลี้ยง", prefixIcon: Icon(Icons.pets)),
        items: petList.map((pet) {
          return DropdownMenuItem<int>(value: int.parse(pet['pet_id']), child: Text("${pet['pet_name']} (${pet['pet_type']})"));
        }).toList(),
        onChanged: (value) => setState(() => selectedPetId = value),
      ),
    );
  }

  Widget _buildSummaryPanel() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ยอดรวม:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("${NumberFormat('#,###').format(totalPrice)} บาท", style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: confirmBooking,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[700], minimumSize: const Size(double.infinity, 55)),
            child: const Text("ยืนยันการจอง", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}