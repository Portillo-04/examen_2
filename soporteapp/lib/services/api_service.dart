import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/incidencia.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/incidencias';

  Future<List<Incidencia>> obtenerIncidencias() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((e) => Incidencia.fromJson(e)).toList();
    }

    throw Exception('Error al obtener incidencias');
  }

  Future<void> crearIncidencia(Incidencia incidencia) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incidencia.toJson()),
    );
  }

  Future<void> actualizarIncidencia(int id, Incidencia incidencia) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(incidencia.toJson()),
    );
  }

  Future<void> eliminarIncidencia(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
