import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final int userId;
  HistoryScreen({required this.userId});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final url = Uri.parse('http://172.24.163.18/pet_api/get_bookings.php?user_id=${widget.userId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          bookings = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC), // สีครีมสไตล์คาเฟ่
      appBar: AppBar(
        title: Text("ประวัติการจอง", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown[600],
      ),
      body: isLoading 
        ? Center(child: CircularProgressIndicator()) // แสดงตัวหมุนรอโหลด
        : bookings.isEmpty 
          ? Center(child: Text("ยังไม่มีรายการจอง"))
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final b = bookings[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Icon(Icons.pets, color: Colors.green[800]),
                    ),
                    title: Text("ชื่อสัตว์เลี้ยง: ${b['pet_name']}", 
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("วันที่: ${b['booking_date']}"),
                        Text("ยอดรวม: ${b['total_price']} บาท", 
                             style: TextStyle(color: Colors.brown, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: b['status'] == 'สำเร็จ' ? Colors.green[50] : Colors.orange[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        b['status'],
                        style: TextStyle(color: b['status'] == 'สำเร็จ' ? Colors.green : Colors.orange),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}