import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';

class GreetingCard extends StatelessWidget {
  final String message;
  final double width;
  final double height;
  final bool isPreview; // Nếu là preview có thể giảm bớt shadow để mượt hơn

  const GreetingCard({
    super.key,
    required this.message,
    this.width = 360,
    this.height = 640,
    this.isPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TetColors.luckyRed,
            TetColors.luckyRedDark,
            TetColors.luckyRed,
          ],
        ),
        boxShadow: isPreview 
          ? null 
          : [
              BoxShadow(
                color: TetColors.prosperityGold.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
      ),
      child: Stack(
        children: [
          // 1. Hoa văn góc (Icon trang trí)
          ..._buildDecorativeIcons(),

          // 2. Viền khung vàng nội bộ (Gold Border Accent)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: TetColors.prosperityGold.withOpacity(0.5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 3. Nội dung chính
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: TetColors.prosperityGold,
                    size: 32,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    message.isEmpty ? 'Chúc mừng năm mới!' : message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: TetColors.prosperityGold,
                      fontSize: 24,
                      fontFamily: 'Cursive', // Hoặc font chữ thư pháp nếu bạn có
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Label phía trên
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '2026',
                  style: TextStyle(
                    color: TetColors.prosperityGold.withOpacity(0.8),
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                  ),
                ),
                const Text(
                  'Chúc Mừng Năm Mới',
                  style: TextStyle(
                    color: TetColors.prosperityGold,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          
          // 5. Chân trang (Branding nhẹ)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: TetColors.prosperityGold),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'TẾT NGUYÊN ĐÁN',
                  style: TextStyle(
                    color: TetColors.prosperityGold,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDecorativeIcons() {
    return [
      _positionIcon(top: 24, left: 24, icon: Icons.local_florist),
      _positionIcon(top: 24, right: 24, icon: Icons.local_florist),
      _positionIcon(bottom: 24, left: 24, icon: Icons.filter_vintage),
      _positionIcon(bottom: 24, right: 24, icon: Icons.filter_vintage),
    ];
  }

  Widget _positionIcon({double? top, double? bottom, double? left, double? right, required IconData icon}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Icon(
        icon,
        size: 40,
        color: TetColors.prosperityGold.withOpacity(0.4),
      ),
    );
  }
}