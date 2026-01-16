import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mahasiswa_form.dart';

class MahasiswaPage extends StatelessWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mahasiswaRef = FirebaseFirestore.instance.collection('mahasiswa');

    return Scaffold(
      appBar: AppBar(title: const Text('Data Mahasiswa')),
      body: StreamBuilder<QuerySnapshot>(
        stream: mahasiswaRef.orderBy('nama').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('Belum ada data'));

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final doc = data[i];
              final nama = doc['nama'];
              final nim = doc['nim'];
              final jurusan = doc['jurusan'];
              return ListTile(
                title: Text(nama),
                subtitle: Text('$nim • $jurusan'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MahasiswaForm(
                              docId: doc.id,
                              nama: nama,
                              nim: nim,
                              jurusan: jurusan,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await mahasiswaRef.doc(doc.id).delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MahasiswaForm()),
          );
        },
      ),
    );
  }
}