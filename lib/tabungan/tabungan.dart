import 'dart:io';

import 'package:barcode_detector/tabungan/confirm_page_tabungan.dart';
import 'package:barcode_detector/tabungan/daftar_tabungan.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../kelas.dart';

class Tabungan extends StatefulWidget {
  const Tabungan({Key? key}) : super(key: key);

  @override
  State<Tabungan> createState() => _TabunganState();
}

class _TabunganState extends State<Tabungan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  int deteksi = 1;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.pauseCamera();
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      if (kelasA.indexOf(scanData.code!) != -1 ||
          kelasB.indexOf(scanData.code!) != -1) {
        setState(() {
          result = scanData;
          deteksi == 0;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => ConfirmPageTabungan(nis: scanData.code!)));
        controller.pauseCamera();
      } else {
        setState(() {
          result = "QR Code tidak valid" as Barcode?;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: QRView(
                key: qrKey,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.teal,
                  borderWidth: 5,
                  borderRadius: 12,
                ),
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(result != null
                    ? result!.code!
                    : "Tidak ada QR Code terdeteksi"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => DaftarTabungan()));
                  },
                  child: Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: const Text(
                      'Lihat Data Tabungan',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
