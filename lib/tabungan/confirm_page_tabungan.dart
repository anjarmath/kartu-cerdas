import 'dart:convert';

import 'package:barcode_detector/currencyFormat.dart';
import 'package:barcode_detector/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../kelas.dart';

class ConfirmPageTabungan extends StatefulWidget {
  final String nis;
  const ConfirmPageTabungan({
    Key? key,
    required this.nis,
  }) : super(key: key);

  @override
  State<ConfirmPageTabungan> createState() => _ConfirmPageTabunganState(nis);
}

class _ConfirmPageTabunganState extends State<ConfirmPageTabungan> {
  final String nis;
  _ConfirmPageTabunganState(this.nis);

  String pil = 'a';
  TextEditingController jumlah = new TextEditingController();
  int? saldoSekarang;
  int load = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jumlah.text = '';
    getSaldo();
  }

  Future getSaldo() async {
    DocumentSnapshot saldo =
        await FirebaseFirestore.instance.collection('siswa').doc(nis).get();
    setState(() {
      if (saldo.get('tabungan') != null) {
        saldoSekarang = saldo.get('tabungan');
      } else {
        saldoSekarang = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konfirmasi Tabungan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nama Siswa:',
                    style: TextStyle(
                        color: Colors.black.withAlpha(140), fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    kelasA.indexOf(nis) != -1
                        ? namaKelasA[kelasA.indexOf(nis)]
                        : namaKelasB[kelasB.indexOf(nis)],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  SizedBox(height: 18),
                  Text(
                    'Nomor Induk:',
                    style: TextStyle(
                        color: Colors.black.withAlpha(140), fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    nis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tabungan Saat ini:',
                    style: TextStyle(
                        color: Colors.black.withAlpha(140), fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    CurrencyFormat.convertToIdr(saldoSekarang, 2),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RadioListTile(
                          title: Text("Isi tabungan"),
                          value: 'a',
                          groupValue: pil,
                          onChanged: (value) {
                            setState(() {
                              pil = value.toString();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RadioListTile(
                          title: Text("Ambil tabungan"),
                          value: 'b',
                          groupValue: pil,
                          onChanged: (value) {
                            setState(() {
                              pil = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: jumlah,
                      decoration: new InputDecoration(labelText: "Jumlah"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: TextButton(
              onPressed: load == 0
                  ? () async {
                      if (pil == 'b') {
                        if (saldoSekarang != null) {
                          if (saldoSekarang! < int.tryParse(jumlah.text)!) {
                            showSnackBar(context, 'Maaf, saldo Anda kurang');
                          } else {
                            ubahSaldo();
                          }
                        } else {
                          showSnackBar(context, 'Maaf, saldo Anda kosong');
                        }
                      } else {
                        ubahSaldo();
                      }
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: load == 0
                    ? const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white, fontSize: 28.0),
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future ubahSaldo() async {
    await FirebaseFirestore.instance.collection("siswa").doc(nis).update({
      'tabungan': pil == 'a'
          ? saldoSekarang == null
              ? int.tryParse(jumlah.text)!
              : saldoSekarang! + int.tryParse(jumlah.text)!
          : saldoSekarang == null
              ? -int.tryParse(jumlah.text)!
              : saldoSekarang! - int.tryParse(jumlah.text)!,
    }).then((value) {
      getSaldo();
      showDialog(
          context: context,
          builder: (_) => Dialog(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Tersimpan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        size: 94,
                        color: Colors.green,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: const Text(
                            'Tutup',
                            style:
                                TextStyle(color: Colors.white, fontSize: 28.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    });
  }
}
