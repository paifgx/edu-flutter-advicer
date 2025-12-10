import 'package:flutter/material.dart';

class ListDemoPage extends StatelessWidget {
  const ListDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(50, (i) => 'Eintrag $i');
    return Scaffold(
      appBar: AppBar(title: const Text('Liste')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            onTap: () => debugPrint('Klick auf $index'),
          );
        },
      ),
    );
  }
}
