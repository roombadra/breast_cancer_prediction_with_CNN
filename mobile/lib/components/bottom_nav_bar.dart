import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final BottomNavController navController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: navController.tabIndex.value,
          onTap: navController.changeTabIndex, //Simplified onTap
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              label: 'Prediction',
            ),
          ],
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
        ));
  }
}
