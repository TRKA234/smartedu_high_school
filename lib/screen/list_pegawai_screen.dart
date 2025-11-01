import 'package:flutter/material.dart';
import '../models/pegawai_model.dart';
import '../services/pegawai_service.dart';
import 'add_pegawai_screen.dart';
import 'detail_pegawai_screen.dart';

class ListPegawaiScreen extends StatefulWidget {
  const ListPegawaiScreen({super.key});

  @override
  State<ListPegawaiScreen> createState() => _ListPegawaiScreenState();
}

class _ListPegawaiScreenState extends State<ListPegawaiScreen> {
  final PegawaiService _service = PegawaiService();
  late Future<List<Pegawai>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchPegawaiList();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.fetchPegawaiList();
    });
    await _future;
  }

  void _delete(Pegawai p) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Pegawai'),
        content: Text('Yakin ingin menghapus ${p.name}?'),
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

    try {
      await _service.deletePegawai(p.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil dihapus')));
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pegawai'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3),
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<Pegawai>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Terjadi kesalahan: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              final list = snapshot.data ?? [];
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada data pegawai',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Colors.white24),
                itemBuilder: (context, index) {
                  final p = list[index];
                  return Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        p.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${p.position} • ${p.phone}'),
                      onTap: () async {
                        final changed = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPegawaiScreen(pegawai: p),
                          ),
                        );
                        if (changed == true) _refresh();
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _delete(p),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPegawaiScreen()),
          );
          if (created == true) _refresh();
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah Pegawai"),
      ),
    );
  }
}
