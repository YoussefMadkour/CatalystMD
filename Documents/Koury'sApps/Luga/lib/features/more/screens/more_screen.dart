import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () {}),
          ListTile(leading: const Icon(Icons.help), title: const Text('How it works'), onTap: () {}),
          ListTile(leading: const Icon(Icons.shield), title: const Text('Trust & Safety'), onTap: () {}),
          ListTile(leading: const Icon(Icons.notifications), title: const Text('Notifications'), onTap: () {}),
          ListTile(leading: const Icon(Icons.delete_forever), title: const Text('Delete account'), onTap: () {}),
        ],
      ),
    );
  }
}
