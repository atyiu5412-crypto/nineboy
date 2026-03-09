import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'add_pet_screen.dart';
import 'booking_screen.dart';
import 'home_screen.dart'; // หน้าโชว์ข้อมูลระบบที่คุณต้องการ
import 'history_screen.dart'; // หน้าสรุปรายการ (Process 6)

void main() => runApp(PetHotelApp());

class PetHotelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farm Hug Pet Hotel',
      theme: ThemeData(
        // ใช้ฟอนต์ Kanit เพื่อความสวยงามสไตล์คาเฟ่
        textTheme: GoogleFonts.kanitTextTheme(),
        primaryColor: const Color(0xFF795548), 
        scaffoldBackgroundColor: const Color(0xFFF5F5DC), 
      ),
      home: LoginScreen(), // เริ่มต้นแอปที่หน้า Login
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int userId;
  const MainNavigation({super.key, required this.userId});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // รวมรายการหน้าจอทั้งหมดตามโครงสร้างงานของคุณ
    final List<Widget> pages = [
      const HomeScreen(), // 1. หน้าหลักโชว์ข้อมูล (รูปภาพ/บริการ/รีวิว)
      AddPetScreen(userId: widget.userId), // 2. เพิ่มสัตว์เลี้ยง (Process 3)
      BookingScreen(userId: widget.userId, petId: 1), // 3. จองบริการ (Process 4 & 5)
      HistoryScreen(userId: widget.userId), // 4. ประวัติการจอง (Process 6)
    ];

    return Scaffold(
      body: pages[_currentIndex],
      // ส่วนของแถบเมนูด้านล่าง (Bottom Navigation Bar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown[700],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าหลัก'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'สัตว์เลี้ยง'),
          BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'จองบริการ'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'ประวัติ'),
        ],
      ),
      // เพิ่มปุ่ม Logout ไว้ที่ AppBar เพื่อความสะดวก
      appBar: AppBar(
        title: const Text("Farm Hug Pet Hotel"),
        backgroundColor: Colors.brown[600],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // ย้อนกลับไปหน้า Login และล้าง Stack ทั้งหมด
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => LoginScreen())
              );
            },
          )
        ],
      ),
    );
  }
}