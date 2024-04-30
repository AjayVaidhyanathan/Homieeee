
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRCode extends StatelessWidget {
  const GenerateQRCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'The person collecting the food from you should scan the QR code to successfully complete the transaction and get credits',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 80),
            const Text('Product ID is '),
            const SizedBox(height: 80),
            SizedBox(
              height: 300,
              width: 300,
              child: QrImageView(
                  embeddedImage:
                      const AssetImage('assets/logos/Icon_Image.png'),
                  data: 'data'),
            )
          ],
        ),
      ),
    );
  }
}
