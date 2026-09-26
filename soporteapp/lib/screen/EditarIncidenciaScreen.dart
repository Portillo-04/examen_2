import 'package:flutter/material.dart';

import '../models/incidencia.dart';
import '../services/api_service.dart';

class EditarIncidenciaScreen extends StatefulWidget {
  final Incidencia incidencia;

  const EditarIncidenciaScreen({super.key, required this.incidencia});

  @override
  State<EditarIncidenciaScreen> createState() => _EditarIncidenciaScreenState();
}

class _EditarIncidenciaScreenState extends State<EditarIncidenciaScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreController;
  late TextEditingController correoController;
  late TextEditingController equipoController;
  late TextEditingController descripcionController;

  late String prioridad;
  late String estado;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(
      text: widget.incidencia.nombreUsuario,
    );

    correoController = TextEditingController(text: widget.incidencia.correo);

    equipoController = TextEditingController(
      text: widget.incidencia.numeroEquipo.toString(),
    );

    descripcionController = TextEditingController(
      text: widget.incidencia.descripcion,
    );

    prioridad = widget.incidencia.prioridad;
    estado = widget.incidencia.estado;
  }

  Future<void> actualizarIncidencia() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final incidenciaActualizada = Incidencia(
      id: widget.incidencia.id,
      nombreUsuario: nombreController.text.trim(),
      correo: correoController.text.trim(),
      numeroEquipo: int.parse(equipoController.text),
      descripcion: descripcionController.text.trim(),
      prioridad: prioridad,
      estado: estado,
      fechaRegistro: widget.incidencia.fechaRegistro,
    );

    try {
      await apiService.actualizarIncidencia(
        widget.incidencia.id!,
        incidenciaActualizada,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incidencia actualizada correctamente")),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar incidencia")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Incidencia")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre Usuario",
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
                controller: correoController,
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
                controller: equipoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número Equipo",
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
                controller: descripcionController,
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
                  label: const Text("Actualizar Incidencia"),
                  onPressed: actualizarIncidencia,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
