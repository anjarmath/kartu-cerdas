import 'package:barcode_detector/currencyFormat.dart';
import 'package:barcode_detector/kelas.dart';
import 'package:barcode_detector/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmPagePerpustakaan extends StatefulWidget {
  final String nis;
  const ConfirmPagePerpustakaan({Key? key, required this.nis})
      : super(key: key);

  @override
  State<ConfirmPagePerpustakaan> createState() =>
      _ConfirmPagePerpustakaanState(nis);
}

class _ConfirmPagePerpustakaanState extends State<ConfirmPagePerpustakaan> {
  final String nis;
  _ConfirmPagePerpustakaanState(this.nis);

  String pil = 'a';
  String? buku;
  TextEditingController nama_buku = new TextEditingController();
  int? saldoSekarang;
  int load = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  SizedBox(height: 18),
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
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RadioListTile(
                          title: Text("Pinjam Buku"),
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
                          title: Text("Kembalikan Buku"),
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
                  Divider(
                    color: Colors.black,
                  ),
                  pil == 'a'
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: TextField(
                            controller: nama_buku,
                            decoration:
                                new InputDecoration(labelText: "Nama Buku"),
                          ),
                        )
                      : Expanded(
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
                                // showSnackBar(context, snap.length.toString());
                                return ListView.builder(
                                  itemCount: snap.length,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                      title:
                                          Text(snap[index]['nama'].toString()),
                                      value: snap[index]['nama'].toString(),
                                      groupValue: buku,
                                      onChanged: (value) {
                                        setState(() {
                                          buku = value.toString();
                                        });
                                      },
                                    );
                                    // return Text(snap.length.toString());
                                  },
                                );
                              } else {
                                return Text('Tidak ada buku dipinjam');
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
                      if (pil == 'a') {
                        simpan();
                      } else {
                        kembalikan();
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
                    ? Text(
                        pil == 'a' ? 'Simpan' : 'Kembalikan',
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

  Future simpan() async {
    await FirebaseFirestore.instance
        .collection("siswa")
        .doc(nis)
        .collection("Buku")
        .doc(nama_buku.text)
        .set({
      'nama': nama_buku.text,
      'diunggah': DateFormat('dd MMMM yyyy').format(DateTime.now()),
    }).then((value) {
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

  Future kembalikan() async {
    await FirebaseFirestore.instance
        .collection("siswa")
        .doc(nis)
        .collection("Buku")
        .doc(buku)
        .delete()
        .then((value) {
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
                        'Dikembalikan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      Icon(
                        Icons.delete_forever_rounded,
                        size: 94,
                        color: Colors.red,
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
