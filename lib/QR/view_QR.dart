import 'package:flutter/material.dart';

class ScanQRCode extends StatelessWidget {
  ScanQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                children: [
                  Text(
                    'To get the product from other user scan the QR code and collect the item.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text('The QR code from the other user')
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: Container()),
            const SizedBox(height: 10),
            const Expanded(
              child: Text('Scan the code to get credits'),
            )
          ],
        ),
      ),
    );
  }
}
