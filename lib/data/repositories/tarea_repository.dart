
import 'dart:convert';
import 'package:app_clase_juan/data/models/tarea_model.dart';
import 'package:http/http.dart' as http;


class TareaRepository {


  final String baseUrl = 'https://nk0blh78-8000.use2.devtunnels.ms';


  Future<List<Tarea>> getTareas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tareas/'));
      if(response.statusCode == 200){
        final List jsonList = json.decode(response.body);
        return jsonList.map((json) => Tarea.fromJson(json)).toList();
      }else{
        throw Exception('Error al cargar las tareas ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion: ${e}');
    }
  }


  Future getTareaById(int id) async{
    try {
      final response = await http.get(Uri.parse('$baseUrl/tareas/$id'));
      if(response.statusCode == 200){
        return Tarea.fromJson(json.decode(response.body));
      }else{
        throw Exception('Error al cargar la tarea ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexion2: ${e}');
    }
  }


  Future<Tarea> createTarea(Tarea tarea) async{
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tareas/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tarea.toJson()),
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
}