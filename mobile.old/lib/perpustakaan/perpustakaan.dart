import 'dart:io';

import 'package:barcode_detector/perpustakaan/confirm_page_perpustakaan.dart';
import 'package:barcode_detector/perpustakaan/daftar_perpustakaan.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../kelas.dart';

class Perpustakaan extends StatefulWidget {
  const Perpustakaan({Key? key}) : super(key: key);

  @override
  State<Perpustakaan> createState() => _PerpustakaanState();
}

class _PerpustakaanState extends State<Perpustakaan> {
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
    if (deteksi == 1) {
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
                  builder: (_) =>
                      ConfirmPagePerpustakaan(nis: scanData.code!)));
          controller.pauseCamera();
        } else {
          setState(() {
            result = "QR Code tidak valid" as Barcode?;
          });
        }
      });
    }
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DaftarPerpustakaan()));
                  },
                  child: Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: const Text(
                      'Lihat Data Perpustakaan',
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
