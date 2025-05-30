import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todos_example/screens/cart_page.dart';
import 'package:todos_example/screens/home_page.dart';
import 'package:todos_example/data/api/store_api.dart';
import 'package:todos_example/screens/product_page.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  int _currentIndex = 0;

  final _api = StoreApi(Dio());

  @override
  Widget build(BuildContext context) {
    final pages = [
      const MyHomePage(title: 'new app'),
      ProductPage(),
      CartPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Products'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
