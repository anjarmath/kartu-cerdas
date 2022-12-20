// ignore_for_file: prefer_const_constructors

import 'package:barcode_detector/kelas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaftarPresensi extends StatefulWidget {
  const DaftarPresensi({Key? key}) : super(key: key);

  @override
  State<DaftarPresensi> createState() => _DaftarPresensiState();
}

class _DaftarPresensiState extends State<DaftarPresensi> {
  TextEditingController dateController = TextEditingController(
    text: DateFormat('dd MMMM yyyy').format(DateTime.now()),
  );

  String kelas = 'a';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Presensi'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: dateController, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Masukkan tanggal",
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ) //label text of field
                  ),
              readOnly: true, // when true user cannot edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('dd MMMM yyyy').format(pickedDate);

                  setState(() {
                    dateController.text =
                        formattedDate; //set foratted date to TextField value.
                  });
                } else {
                  print("Date is not selected");
                }
              },
            ),
          ),
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
                    'Keterangan',
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
                                    .collection('Record')
                                    .doc(dateController.text)
                                    .snapshots(),
                                builder: (_, snapshot) {
                                  if (snapshot.hasData) {
                                    final snap = snapshot.data!.data();
                                    if (snap != null) {
                                      return Center(
                                        child: Icon(Icons.circle,
                                            color: Colors.green, size: 20),
                                      );
                                    } else {
                                      return Center(
                                        child: Icon(Icons.circle,
                                            color: Colors.red, size: 20),
                                      );
                                    }
                                  } else {
                                    return const SizedBox();
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
