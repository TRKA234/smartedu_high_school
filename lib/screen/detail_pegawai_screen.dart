import 'package:flutter/material.dart';
import '../models/pegawai_model.dart';
import '../services/pegawai_service.dart';
import 'edit_pegawai_screen.dart';

class DetailPegawaiScreen extends StatefulWidget {
  final Pegawai pegawai;
  const DetailPegawaiScreen({super.key, required this.pegawai});

  @override
  State<DetailPegawaiScreen> createState() => _DetailPegawaiScreenState();
}

class _DetailPegawaiScreenState extends State<DetailPegawaiScreen> {
  final PegawaiService _service = PegawaiService();
  bool isDeleting = false;

  Future<void> _delete() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Pegawai'),
        content: Text('Yakin menghapus ${widget.pegawai.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isDeleting = true);
    try {
      await _service.deletePegawai(widget.pegawai.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil dihapus')));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Pegawai p = widget.pegawai;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pegawai'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditPegawaiScreen(pegawai: p),
                ),
              );
              if (updated == true && mounted) Navigator.pop(context, true);
            },
          ),
          IconButton(
            icon: isDeleting
                ? const CircularProgressIndicator()
                : const Icon(Icons.delete),
            onPressed: isDeleting ? null : _delete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              p.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${p.email}'),
            const SizedBox(height: 4),
            Text('Phone: ${p.phone}'),
            const SizedBox(height: 4),
            if (p.address.isNotEmpty) Text('Alamat: ${p.address}'),
            const SizedBox(height: 8),
            Text('Jabatan: ${p.position}'),
            const SizedBox(height: 8),
            Text('Dibuat: ${p.createdAt ?? "-"}'),
            const SizedBox(height: 4),
            Text('Diperbarui: ${p.updatedAt ?? "-"}'),
          ],
        ),
      ),
    );
  }
}
