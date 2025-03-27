


class Tarea{
  final String nombre;
  final String detalle;
  final String estado;
  final int id;

  Tarea({required this.nombre, required this.detalle, required this.estado, required this.id});


  factory Tarea.fromJson(Map json){
    return Tarea(
      nombre: json['nombre'],
      detalle: json['detalle'],
      estado: json['estado'],
      id: json['id'],
    );
  }


  Map toJson(){
    return {
      'nombre': nombre,
      'detalle': detalle,
      'estado': estado,
      'id': id,
    };
  }
}