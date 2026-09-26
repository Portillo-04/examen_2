import 'package:flutter/material.dart';

import '../models/incidencia.dart';
import '../services/api_service.dart';
import 'DetalleIncidenciaScreen.dart';

class IncidenciasScreen extends StatefulWidget {
  const IncidenciasScreen({super.key});

  @override
  State<IncidenciasScreen> createState() => _IncidenciasScreenState();
}

class _IncidenciasScreenState extends State<IncidenciasScreen> {
  final ApiService apiService = ApiService();

  late Future<List<Incidencia>> incidencias;

  @override
  void initState() {
    super.initState();
    cargarIncidencias();
  }

  void cargarIncidencias() {
    incidencias = apiService.obtenerIncidencias();
  }

  IconData obtenerIcono(String prioridad) {
    switch (prioridad) {
      case 'Alta':
        return Icons.error;
      case 'Media':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  Color obtenerColor(String prioridad) {
    switch (prioridad) {
      case 'Alta':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Incidencias...'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Incidencia>>(
        future: incidencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar incidencias...'));
          }

          final lista = snapshot.data ?? [];

          if (lista.isEmpty) {
            return const Center(
              child: Text('No hay incidencias registradas...'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                cargarIncidencias();
              });
            },
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final incidencia = lista[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: Icon(
                      obtenerIcono(incidencia.prioridad),
                      color: obtenerColor(incidencia.prioridad),
                    ),
                    title: Text(
                      incidencia.nombreUsuario,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incidencia.descripcion,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("Estado: ${incidencia.estado}"),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetalleIncidenciaScreen(incidencia: incidencia),
                        ),
                      ).then((_) {
                        setState(() {
                          cargarIncidencias();
                        });
                      });
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
