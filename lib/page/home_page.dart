import 'package:flutter/material.dart';
import 'package:messenger/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void singOut() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.singOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [IconButton(onPressed: singOut, icon: Icon(Icons.logout))],
      ),
    );
  }
}
