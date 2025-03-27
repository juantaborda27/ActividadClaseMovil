


// class Tarea{
//   final String nombre;
//   final String detalle;
//   final String estado;
//   final int id;

//   Tarea({required this.nombre, required this.detalle, required this.estado, required this.id});


//   factory Tarea.fromJson(Map json){
//     return Tarea(
//       nombre: json['nombre'],
//       detalle: json['detalle'],
//       estado: json['estado'],
//       id: json['id'],
//     );
//   }


//   Map toJson(){
//     return {
//       'nombre': nombre,
//       'detalle': detalle,
//       'estado': estado,
//       'id': id,
//     };
//   }

//   Map toJson2(){
//     return {
//       'nombre': nombre,
//       'detalle': detalle,
//       'estado': estado,
//     };
//   }
// }

class Tarea {
  final String nombre;
  final String detalle;
  final String estado;
  final int? id; // Hacemos el id opcional

  Tarea({
    required this.nombre,
    required this.detalle,
    required this.estado,
    this.id, // Ahora el id es opcional
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      nombre: json['nombre'],
      detalle: json['detalle'],
      estado: json['estado'],
      id: json['id'], // Se mantiene opcional
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'detalle': detalle,
      'estado': estado,
      if (id != null) 'id': id, // Solo incluye el id si no es null
    };
  }

  Map<String, dynamic> toJson2() {
    return {
      'nombre': nombre,
      'detalle': detalle,
      'estado': estado,
    };
  }
}
