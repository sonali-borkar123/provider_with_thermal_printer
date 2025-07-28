import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'print_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PrinterProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PrinterHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrinterHome extends StatelessWidget {
  const PrinterHome({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrinterProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('LAN POS Printer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: provider.ipController,
              decoration: const InputDecoration(
                labelText: 'Printer IP Address',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: provider.portController,
              decoration: const InputDecoration(
                labelText: 'Printer Port (default: 9100)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: provider.textController,
              decoration: const InputDecoration(labelText: 'Text to Print'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.printReceipt,
              child: const Text('Print'),
            ),
            const SizedBox(height: 24),
            Text(
              provider.status,
              style: TextStyle(
                color:
                    provider.status.contains('Success')
                        ? Colors.green
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
