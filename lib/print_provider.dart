// printer_provider.dart
import 'package:flutter/material.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class PrinterProvider extends ChangeNotifier {
  final ipController = TextEditingController();
  final portController = TextEditingController(text: '9100');
  final textController = TextEditingController(text: 'Test Print in Bold!');

  String _status = '';
  String get status => _status;

  Future<void> printReceipt() async {
    final ip = ipController.text.trim();
    final port = int.tryParse(portController.text.trim()) ?? 9100;
    final printText = textController.text;

    _status = 'Printing...';
    notifyListeners();

    try {
      final profile = await CapabilityProfile.load();
      final printer = NetworkPrinter(PaperSize.mm80, profile);
      final res = await printer.connect(ip, port: port);

      if (res == PosPrintResult.success) {
        printer.text(
          printText,
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
        );
        printer.feed(2);
        printer.cut();
        printer.disconnect();

        _status = 'Print Success!';
      } else {
        _status = 'Print Failed: ${res.msg}';
      }
    } catch (e) {
      _status = 'Error: $e';
    }

    notifyListeners();
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    textController.dispose();
    super.dispose();
  }
}
