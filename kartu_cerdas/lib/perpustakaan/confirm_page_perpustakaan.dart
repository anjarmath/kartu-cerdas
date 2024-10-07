import 'package:kartu_cerdas/kelas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmPagePerpustakaan extends StatefulWidget {
  final String nis;
  const ConfirmPagePerpustakaan({Key? key, required this.nis})
      : super(key: key);

  @override
  State<ConfirmPagePerpustakaan> createState() =>
      _ConfirmPagePerpustakaanState();
}

class _ConfirmPagePerpustakaanState extends State<ConfirmPagePerpustakaan> {
  String pil = 'a';
  String? buku;
  TextEditingController namaBukuController = TextEditingController();
  int? saldoSekarang;
  int load = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Tabungan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 18),
                  Text(
                    'Nama Siswa:',
                    style: TextStyle(
                        color: Colors.black.withAlpha(140), fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kelasA.contains(widget.nis)
                        ? namaKelasA[kelasA.indexOf(widget.nis)]
                        : namaKelasB[kelasB.indexOf(widget.nis)],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Nomor Induk:',
                    style: TextStyle(
                        color: Colors.black.withAlpha(140), fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.nis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RadioListTile(
                          title: const Text("Pinjam Buku"),
                          value: 'a',
                          groupValue: pil,
                          onChanged: (value) {
                            setState(() {
                              pil = value.toString();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RadioListTile(
                          title: const Text("Kembalikan Buku"),
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
                  const Divider(
                    color: Colors.black,
                  ),
                  pil == 'a'
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextField(
                            controller: namaBukuController,
                            decoration:
                                const InputDecoration(labelText: "Nama Buku"),
                          ),
                        )
                      : Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("siswa")
                                .doc(widget.nis)
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
                                return const Text('Tidak ada buku dipinjam');
                              }
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
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
                        style: const TextStyle(
                            color: Colors.white, fontSize: 28.0),
                      )
                    : const CircularProgressIndicator(),
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
        .doc(widget.nis)
        .collection("Buku")
        .doc(namaBukuController.text)
        .set({
      'nama': namaBukuController.text,
      'diunggah': DateFormat('dd MMMM yyyy').format(DateTime.now()),
    }).then((value) {
      showDialog(
          context: context,
          builder: (_) => Dialog(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.9,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Tersimpan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      const Icon(
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
        .doc(widget.nis)
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Dikembalikan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      const Icon(
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
