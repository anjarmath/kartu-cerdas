import 'package:barcode_detector/kelas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmPagePresensi extends StatefulWidget {
  final String nis;
  const ConfirmPagePresensi({
    Key? key,
    required this.nis,
  }) : super(key: key);

  @override
  State<ConfirmPagePresensi> createState() => _ConfirmPagePresensiState(nis);
}

class _ConfirmPagePresensiState extends State<ConfirmPagePresensi> {
  final String nis;
  _ConfirmPagePresensiState(this.nis);
  TextEditingController dateController = TextEditingController();
  String dropdownvalue = 'Hadir';
  int load = 0;

  var items = ['Hadir', 'Sakit', 'Izin', 'Alpha'];

  @override
  void initState() {
    dateController.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konfirmasi Kehadiran'),
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller:
                          dateController, //editing controller of this TextField
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
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: TextButton(
              onPressed: load == 0
                  ? () async {
                      await FirebaseFirestore.instance
                          .collection("siswa")
                          .doc(nis)
                          .collection("Record")
                          .doc(dateController.text)
                          .set({
                        'date': dateController.text,
                        'checkIn': 1,
                      }).then((value) {
                        showDialog(
                            context: context,
                            builder: (_) => Dialog(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 32),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: const Text(
                                              'Tutup',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                      });
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
                        'Simpan Presensi',
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
}
