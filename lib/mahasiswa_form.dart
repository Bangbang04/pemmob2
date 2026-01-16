import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MahasiswaForm extends StatefulWidget {
  final String? docId;
  final String? nama;
  final String? nim;
  final String? jurusan;

  const MahasiswaForm({
    super.key,
    this.docId,
    this.nama,
    this.nim,
    this.jurusan,
  });

  @override
  State<MahasiswaForm> createState() => _MahasiswaFormState();
}

class _MahasiswaFormState extends State<MahasiswaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _nimCtrl = TextEditingController();
  final TextEditingController _jurusanCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.docId != null) {
      _namaCtrl.text = widget.nama ?? '';
      _nimCtrl.text = widget.nim ?? '';
      _jurusanCtrl.text = widget.jurusan ?? '';
    }
  }

  Future<void> _saveMahasiswa() async {
    final mahasiswaRef = FirebaseFirestore.instance.collection('mahasiswa');
    final data = {
      'nama': _namaCtrl.text,
      'nim': _nimCtrl.text,
      'jurusan': _jurusanCtrl.text,
    };
    if (widget.docId == null) {
      // Add new
      await mahasiswaRef.add(data);
    } else {
      // Update
      await mahasiswaRef.doc(widget.docId).update(data);
    }
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.docId != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Mahasiswa' : 'Tambah Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              TextFormField(
                controller: _nimCtrl,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (v) => v == null || v.isEmpty ? 'NIM wajib diisi' : null,
              ),
              TextFormField(
                controller: _jurusanCtrl,
                decoration: const InputDecoration(labelText: 'Jurusan'),
                validator: (v) => v == null || v.isEmpty ? 'Jurusan wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) _saveMahasiswa();
                },
                child: Text(isEdit ? 'Update' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}