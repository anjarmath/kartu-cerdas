import 'package:barcode_detector/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../kelas.dart';

class DaftarPerpustakaan extends StatefulWidget {
  const DaftarPerpustakaan({Key? key}) : super(key: key);

  @override
  State<DaftarPerpustakaan> createState() => _DaftarPerpustakaanState();
}

class _DaftarPerpustakaanState extends State<DaftarPerpustakaan> {
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
                    '',
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
                            child: TextButton(
                              onPressed: () {
                                if (kelas == 'a') {
                                  lihatData(
                                      kelasA[position].toString(), position);
                                } else {
                                  lihatData(
                                      kelasB[position].toString(), position);
                                }
                              },
                              child: Icon(Icons.open_in_new,
                                  color: Colors.blue, size: 18),
                            ),
                            //
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

  Future lihatData(String nis, int index) async {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      kelas == 'a' ? namaKelasA[index] : namaKelasB[index],
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Buku',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Tanggal Dipinjam',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Colors.black.withAlpha(80),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("siswa")
                            .doc(nis)
                            .collection("Buku")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            final snap = snapshot.data!.docs;
                            return ListView.builder(
                                itemCount: snap.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                snap[index]['nama'].toString()),
                                            Text(snap[index]['diunggah']
                                                .toString()),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.black.withAlpha(80)),
                                    ],
                                  );
                                });
                          } else {
                            return Text('Tidak ada buku dipinjam');
                          }
                        },
                      ),
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
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
