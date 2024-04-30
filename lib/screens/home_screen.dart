import 'package:flutter/material.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.email});

  final String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService().signOut(context: context);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: ProductContainer()
    );
  }
}
