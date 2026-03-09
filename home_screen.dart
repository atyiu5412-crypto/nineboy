import 'package:flutter/material.dart';
import 'animations_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: CustomScrollView(
        // ใช้ Slivers เพื่อช่วยจัดการหน่วยความจำให้ดีขึ้น
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: Colors.brown[700],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text("FARM HUG PET HOTEL",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              background: Image.network(
                'https://st-th-1.byteark.com/assets.punpro.com/cover-contents/i9640/1599123966431-%E0%B9%82%E0%B8%A3%E0%B8%87%E0%B9%81%E0%B8%A3%E0%B8%A1%E0%B8%AB%E0%B8%A1%E0%B8%B2%E0%B9%81%E0%B8%A1%E0%B8%A7%20%E0%B8%A3%E0%B8%B5%E0%B8%A3%E0%B8%B1%E0%B8%99.jpg',
                fit: BoxFit.cover,
                cacheWidth: 800, // จำกัดความกว้างรูปแบนเนอร์เพื่อประหยัด RAM
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FadeInSlide(delay: 1, child: _buildWelcomeSection()),
                  const SizedBox(height: 20),
                  const FadeInSlide(delay: 2, 
                    child: Align(alignment: Alignment.centerLeft, 
                    child: Text("บริการของเรา", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
                  const SizedBox(height: 10),
                  _buildServiceList(), // รายการบริการ
                  const SizedBox(height: 20),
                  const FadeInSlide(delay: 3, 
                    child: Align(alignment: Alignment.centerLeft, 
                    child: Text("ภาพบรรยากาศ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
                  const SizedBox(height: 10),
                  _buildGalleryGrid(), // แกลเลอรี่
                ],
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

  Widget _buildServiceList() {
    final List<Map<String, String>> services = [
      {'t': '👑 ห้อง VIP', 'p': '350.-', 'img': 'https://thonglorpet.com/_content_html_editor_upload/images/400213D1-C3AC-E299-4062-AD1160DE97BB.jpg'},
      {'t': '🐶 ห้อง Standard', 'p': '600.-', 'img': 'https://dogsportclub.readyplanet.site/images/content/original-1734080900219.jpg'},
      {'t': '✂️ อาบน้ำตัดขน', 'p': '250.-', 'img': 'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=400'},
      {'t': '🏡 บริการรับ-ส่งสัตว์เลี้ยง', 'p': '100.-', 'img': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZIjh1rNaVoTiG0DaSzJyERwHq0aHbHtthDQ&s'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // ให้เลื่อนตาม CustomScrollView
      itemCount: services.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(services[index]['img']!, width: 60, height: 60, fit: BoxFit.cover, cacheWidth: 150),
            ),
            title: Text(services[index]['t']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(services[index]['p']!, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildGalleryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
      itemCount: 6, // จำกัดไว้ที่ 6 รูปพอครับ
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          'https://farmhugcafe.com/wp-content/uploads/2023/10/209859_0.webp',
          fit: BoxFit.cover,
          cacheWidth: 200, // จำกัดความกว้างรูปใน Grid เพื่อไม่ให้เครื่องค้าง
        ),
      ),
    );
  }
}