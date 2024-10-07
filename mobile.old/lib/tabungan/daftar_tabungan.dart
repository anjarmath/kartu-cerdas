import 'package:barcode_detector/currencyFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../kelas.dart';

class DaftarTabungan extends StatefulWidget {
  const DaftarTabungan({Key? key}) : super(key: key);

  @override
  State<DaftarTabungan> createState() => _DaftarTabunganState();
}

class _DaftarTabunganState extends State<DaftarTabungan> {
  String kelas = 'a';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Tabungan'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RadioListTile(
                  title: Text("Kelas V-A"),
                  value: 'a',
                  groupValue: kelas,
                  onChanged: (value) {
                    setState(() {
                      kelas = value.toString();
                    });
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RadioListTile(
                  title: Text("Kelas V-B"),
                  value: 'b',
                  groupValue: kelas,
                  onChanged: (value) {
                    setState(() {
                      kelas = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                  child: Text(
                    'NIS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Center(
                  child: Text(
                    'Nama',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                  child: Text(
                    'Tabungan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          Divider(
            thickness: 2.0,
            color: Colors.black.withAlpha(80),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: kelas == 'a' ? kelasA.length : kelasB.length,
              itemBuilder: (BuildContext context, int position) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Center(
                              child: Text(
                                kelas == 'a'
                                    ? kelasA[position].toString()
                                    : kelasB[position].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              kelas == 'a'
                                  ? namaKelasA[position].toString()
                                  : namaKelasB[position].toString(),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('siswa')
                                    .doc(kelas == 'a'
                                        ? kelasA[position].toString()
                                        : kelasB[position].toString())
                                    .snapshots(),
                                builder: (_, snapshot) {
                                  if (snapshot.hasData) {
                                    final snap = snapshot.data!.data();
                                    return Text(CurrencyFormat.convertToIdr(
                                        snap!['tabungan'], 2));
                                  } else {
                                    return Text('null');
                                  }
                                },
                              )
                              // Center(
                              //   child: Icon(
                              //     Icons.circle,
                              //     color: Colors.green,
                              //     size: 20,
                              //   ),
                              // ),
                              ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.black.withAlpha(80)),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
