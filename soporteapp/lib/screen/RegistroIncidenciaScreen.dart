import 'package:flutter/material.dart';

import '../models/incidencia.dart';
import '../services/api_service.dart';

class RegistroIncidenciaScreen extends StatefulWidget {
  const RegistroIncidenciaScreen({super.key});

  @override
  State<RegistroIncidenciaScreen> createState() =>
      _RegistroIncidenciaScreenState();
}

class _RegistroIncidenciaScreenState extends State<RegistroIncidenciaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();

  final _correoController = TextEditingController();

  final _equipoController = TextEditingController();

  final _descripcionController = TextEditingController();

  String prioridad = "Baja";
  String estado = "Pendiente";

  final ApiService apiService = ApiService();

  Future<void> guardarIncidencia() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final incidencia = Incidencia(
      nombreUsuario: _nombreController.text.trim(),
      correo: _correoController.text.trim(),
      numeroEquipo: int.parse(_equipoController.text),
      descripcion: _descripcionController.text.trim(),
      prioridad: prioridad,
      estado: estado,
    );

    try {
      await apiService.crearIncidencia(incidencia);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incidencia registrada correctamente")),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al registrar incidencia")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Incidencia")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre del Usuario",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Campo obligatorio";
                  }

                  if (value.trim().length < 3) {
                    return "Mínimo 3 caracteres";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Campo obligatorio";
                  }

                  if (!value.contains("@") || !value.contains(".")) {
                    return "Correo inválido";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _equipoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número de Equipo",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Campo obligatorio";
                  }

                  final numero = int.tryParse(value);

                  if (numero == null || numero <= 0) {
                    return "Debe ser mayor que 0";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _descripcionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Campo obligatorio";
                  }

                  if (value.length < 10) {
                    return "Mínimo 10 caracteres";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                initialValue: prioridad,
                decoration: const InputDecoration(
                  labelText: "Prioridad",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Baja", child: Text("Baja")),
                  DropdownMenuItem(value: "Media", child: Text("Media")),
                  DropdownMenuItem(value: "Alta", child: Text("Alta")),
                ],
                onChanged: (value) {
                  setState(() {
                    prioridad = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                initialValue: estado,
                decoration: const InputDecoration(
                  labelText: "Estado",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Pendiente",
                    child: Text("Pendiente"),
                  ),
                  DropdownMenuItem(
                    value: "En proceso",
                    child: Text("En proceso"),
                  ),
                  DropdownMenuItem(value: "Resuelta", child: Text("Resuelta")),
                ],
                onChanged: (value) {
                  setState(() {
                    estado = value!;
                  });
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Guardar Incidencia"),
                  onPressed: guardarIncidencia,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
