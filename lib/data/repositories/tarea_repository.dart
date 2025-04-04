
import 'dart:convert';
import 'package:app_clase_juan/data/models/tarea_model.dart';
import 'package:http/http.dart' as http;


class TareaRepository {


  // final String baseUrl = 'https://nk0blh78-8000.use2.devtunnels.ms';
    final String baseUrl = 'https://nk0blh78-8000.use2.devtunnels.ms/tareas/';
    


  Future<List<Tarea>> getTareas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl'));
      if(response.statusCode == 200){
        final List jsonList = json.decode(response.body);
        return jsonList.map((json) => Tarea.fromJson(json)).toList();
      }else{
        throw Exception('Error al cargar las tareas ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion1: $e');
    }
  }


  Future getTareaById(int id) async{
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if(response.statusCode == 200){
        return Tarea.fromJson(json.decode(response.body));
      }else{
        throw Exception('Error al cargar la tarea ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion2: $e');
    }
  }


  Future<Tarea> createTarea(Tarea tarea) async{
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nombre': tarea.nombre,
          'detalle': tarea.detalle,
          'estado': tarea.estado,
        }),
      );

      if(response.statusCode == 201){
        return Tarea.fromJson(json.decode(response.body));
      }else{
        throw Exception('Error al crear la tarea ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion3');
    }
  }


  Future<Tarea> updateTarea(int id, Tarea tarea) async{
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tarea.toJson()),
      );

      if(response.statusCode == 200){
        return Tarea.fromJson(json.decode(response.body));
      }else{
        throw Exception('Error al actualizar la tarea ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion4: $e');
    }
  }


  Future<void> deleteTarea(int id) async{
    try {
      final response = await http.delete(Uri.parse('$baseUrl$id'));
      if(response.statusCode == 204){
        return;
      }else{
        throw Exception('Error al eliminar la tarea ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion5: $e');
    }
  }
}