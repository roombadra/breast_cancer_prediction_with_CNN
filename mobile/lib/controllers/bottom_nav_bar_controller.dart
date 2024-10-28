import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var tabIndex = 0.obs;
  final routes = {
    0: '/home',
    1: '/prediction',
  };

  void changeTabIndex(int index) {
    tabIndex.value = index;
    Get.toNamed(routes[index]!); // Navigate using named routes
  }
}
