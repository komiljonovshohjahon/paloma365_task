import 'package:flutter/material.dart';
import 'package:paloma365_task/presentation/pages/homepage/homepage.dart';
import 'package:paloma365_task/presentation/pages/orders/orders_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
          ),
          ListTile(
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const OrdersPage()));
            },
          ),
        ],
      ),
    );
  }
}
