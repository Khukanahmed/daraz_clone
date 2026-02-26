import 'package:daraz_clone/core/nav_bar/controller/navbar_controller.dart';
import 'package:daraz_clone/feature/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarScreen extends StatelessWidget {
  NavbarScreen({super.key});

  final NavController controller = Get.put(NavController());

  final List<Widget> pages = [
    HomeScreen(),
    Center(child: Text("WishList")),
    Center(child: Text("Cart")),
    Center(child: Text("Account")),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,

          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: "WishList",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }
}
