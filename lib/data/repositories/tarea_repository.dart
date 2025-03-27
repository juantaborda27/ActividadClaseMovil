
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
}