import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const BottomNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedBarClipper(),
      child: Container(
        height: 100,
        color: Colors.white,
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment(
                selectedIndex == 0
                    ? -1
                    : selectedIndex == 1
                    ? 0
                    : 1,
                0,
              ),
              child: FractionallySizedBox(
                widthFactor: 1 / 3,
                heightFactor: 0.75,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5ECFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            Row(
              children: [
                navItem(context, Icons.home, 'Home', 0),
                navItem(context, Icons.credit_card, 'Cards', 1),
                navItem(context, Icons.person, 'Profile', 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(BuildContext context, IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          onTabSelected(index);

          switch (index) {
            case 0:
              context.go('/Dashboard');
              break;
            case 1:
              context.go('/my-cards');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CURVED BAR CLIPPER
class CurvedBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 25);
    path.quadraticBezierTo(size.width / 2, -25, size.width, 25);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CurvedBarClipper oldClipper) => false;
}
