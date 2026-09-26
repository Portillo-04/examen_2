import 'package:flutter/material.dart';

import '../models/incidencia.dart';
import '../services/api_service.dart';
import 'EditarIncidenciaScreen.dart';

class DetalleIncidenciaScreen extends StatelessWidget {
  final Incidencia incidencia;

  const DetalleIncidenciaScreen({super.key, required this.incidencia});

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

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de Incidencia")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(obtenerIcono(incidencia.prioridad), size: 80)),

            const SizedBox(height: 20),

            Text(
              "Usuario: ${incidencia.nombreUsuario}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("Correo: ${incidencia.correo}"),

            const SizedBox(height: 10),

            Text("Número de Equipo: ${incidencia.numeroEquipo}"),

            const SizedBox(height: 10),

            Text(
              "Descripción:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(incidencia.descripcion),

            const SizedBox(height: 10),

            Text("Prioridad: ${incidencia.prioridad}"),

            const SizedBox(height: 10),

            Text("Estado: ${incidencia.estado}"),

            const SizedBox(height: 10),

            Text("Fecha Registro: ${incidencia.fechaRegistro ?? ''}"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Editar Incidencia"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditarIncidenciaScreen(incidencia: incidencia),
                    ),
                  ).then((_) {
                    Navigator.pop(context);
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                label: const Text("Eliminar Incidencia"),
                onPressed: () async {
                  bool? confirmar = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Confirmar eliminación"),
                        content: const Text("¿Desea eliminar esta incidencia?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Eliminar"),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmar == true) {
                    await apiService.eliminarIncidencia(incidencia.id!);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Incidencia eliminada correctamente"),
                        ),
                      );

                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
