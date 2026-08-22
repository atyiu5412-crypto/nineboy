import 'package:flutter/material.dart';
import 'animations_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ย้ายข้อมูลออกจาก build method เพื่อประสิทธิภาพที่ดีขึ้น
    final List<Map<String, String>> services = [
      {'t': '👑 ห้อง VIP', 'p': '350.-', 'img': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQ1d2dcbV2fqQkg-M7oL7m9tLokR2jFKqdBbrtJzTCFloXVZp64PMLwTY&s=10'},
      {'t': '🐶 ห้อง Standard', 'p': '600.-', 'img': 'https://dogsportclub.readyplanet.site/images/content/original-1734080900219.jpg'},
      {'t': '✂️ อาบน้ำตัดขน', 'p': '250.-', 'img': 'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=400'},
      {'t': '🏡 บริการรับ-ส่งสัตว์เลี้ยง', 'p': '100.-', 'img': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZIjh1rNaVoTiG0DaSzJyERwHq0aHbHtthDQ&s'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: CustomScrollView(
        // ใช้ Slivers ในการจัดการ Viewport ทั้งหมด ช่วยประหยัดหน่วยความจำสูงสุด
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: Colors.brown[700],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text("FARM HUG PET HOTEL",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              background: _buildOptimizedImage(
                'https://st-th-1.byteark.com/assets.punpro.com/cover-contents/i9640/1599123966431-%E0%B9%82%E0%B8%A3%E0%B8%87%E0%B9%81%E0%B8%A3%E0%B8%A1%E0%B8%AB%E0%B8%A1%E0%B8%B2%E0%B9%81%E0%B8%A1%E0%B8%A7%20%E0%B8%A3%E0%B8%B5%E0%B8%A3%E0%B8%B1%E0%B8%99.jpg', // ใส่ URL ตัวอย่างแทนค่าว่าง
                cacheWidth: 800,
              ),
            ),
          ),

          // ส่วนหัวของบริการ
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  FadeInSlide(delay: 1, child: _buildWelcomeSection()),
                  const SizedBox(height: 20),
                  const FadeInSlide(
                    delay: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("บริการของเรา", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // รายการบริการเปลี่ยนเป็น SliverList (โหลดเฉพาะตัวที่โชว์บนจอ)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildOptimizedImage(
                          services[index]['img']!,
                          width: 50,
                          height: 50,
                          cacheWidth: 150,
                        ),
                      ),
                      title: Text(services[index]['t']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(services[index]['p']!, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
                childCount: services.length,
              ),
            ),
          ),

          // ส่วนหัวของภาพบรรยากาศ
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const FadeInSlide(
                    delay: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("ภาพบรรยากาศ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // แกลเลอรี่เปลี่ยนเป็น SliverGrid (โหลดตามการเลื่อนหน้าจอจริง)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildOptimizedImage(
                    'https://farmhugcafe.com/wp-content/uploads/2023/10/209859_0.webp',
                    cacheWidth: 200,
                  ),
                ),
                childCount: 6,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Row(
        children: [
          Icon(Icons.pets, color: Colors.brown),
          SizedBox(width: 10),
          Text("ยินดีต้อนรับสู่ Farm Hug", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ฟังก์ชันช่วยเรนเดอร์รูปภาพแบบใส่ตัวโหลด (Loading Indicator) ป้องกันแอปกระตุก
  Widget _buildOptimizedImage(String url, {double? width, double? height, int? cacheWidth}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      cacheWidth: cacheWidth,
      // แสดงวงกลมหมุนๆ ระหว่างดาวน์โหลดรูป ลดอาการ UI ค้าง
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          width: width,
          height: height,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.brown),
            ),
          ),
        );
      },
      // แสดงไอคอนแจ้งเตือนหากลิงก์เสียหรือโหลดไม่ผ่าน
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          width: width,
          height: height,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }
}