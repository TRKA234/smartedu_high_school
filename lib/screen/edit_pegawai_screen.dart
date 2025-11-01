import 'package:flutter/material.dart';
import '../models/pegawai_model.dart';
import '../services/pegawai_service.dart';

class EditPegawaiScreen extends StatefulWidget {
  final Pegawai pegawai;
  const EditPegawaiScreen({super.key, required this.pegawai});

  @override
  State<EditPegawaiScreen> createState() => _EditPegawaiScreenState();
}

class _EditPegawaiScreenState extends State<EditPegawaiScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController positionController;

  bool isLoading = false;
  final PegawaiService _service = PegawaiService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.pegawai.name);
    emailController = TextEditingController(text: widget.pegawai.email);
    phoneController = TextEditingController(text: widget.pegawai.phone);
    addressController = TextEditingController(text: widget.pegawai.address);
    positionController = TextEditingController(text: widget.pegawai.position);
  }

  Future<void> _submit() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    try {
      final Pegawai payload = Pegawai(
        id: widget.pegawai.id,
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        position: positionController.text,
        createdAt: widget.pegawai.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _service.updatePegawai(payload);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pegawai berhasil diperbarui')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pegawai')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: positionController,
              decoration: const InputDecoration(
                labelText: 'Jabatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _submit,
                child: isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                    : const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
