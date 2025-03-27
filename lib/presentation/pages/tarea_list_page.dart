// import 'package:app_clase_juan/domain/controller/tarea_controller.dart';
// import 'package:flutter/widgets.dart';

// class TareaListPage extends StatelessWidget {
//   const TareaListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TareaController tareaController = TareaController();

//     return Container();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_clase_juan/domain/controller/tarea_controller.dart';
import 'package:app_clase_juan/data/models/tarea_model.dart';

class TareaListPage extends StatelessWidget {
  const TareaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TareaController tareaController = Get.put(TareaController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const TareaFormPage()),
          ),
        ],
      ),
      body: Obx(() {
        if (tareaController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tareaController.error.value.isNotEmpty) {
          return Center(
            child: Text(
              'Error: ${tareaController.error.value}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (tareaController.tareas.isEmpty) {
          return const Center(
            child: Text('No hay tareas pendientes'),
          );
        }

        return ListView.builder(
          itemCount: tareaController.tareas.length,
          itemBuilder: (context, index) {
            final tarea = tareaController.tareas[index];
            return ListTile(
              title: Text(tarea.nombre),
              subtitle: Text(tarea.detalle),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Get.to(() => TareaFormPage(tarea: tarea)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => tareaController.deleteTarea(tarea.id),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

class TareaFormPage extends StatefulWidget {
  final Tarea? tarea;

  const TareaFormPage({super.key, this.tarea});

  @override
  _TareaFormPageState createState() => _TareaFormPageState();
}

class _TareaFormPageState extends State<TareaFormPage> {
  late TextEditingController _nombreController;
  late TextEditingController _detalleController;
  late String _estado;
  final TareaController _tareaController = Get.find();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.tarea?.nombre ?? '');
    _detalleController =
        TextEditingController(text: widget.tarea?.detalle ?? '');
    _estado = widget.tarea?.estado ?? 'pendiente';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _detalleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarea == null ? 'Nueva Tarea' : 'Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration:
                    const InputDecoration(labelText: 'Nombre de la Tarea'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _detalleController,
                decoration: const InputDecoration(labelText: 'Detalles'),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                value: _estado,
                items: ['pendiente', 'en progreso', 'completada']
                    .map((estado) => DropdownMenuItem(
                          value: estado,
                          child: Text(estado),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _estado = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                    widget.tarea == null ? 'Crear Tarea' : 'Actualizar Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_nombreController.text.isNotEmpty) {
      final nuevaTarea = Tarea(
        nombre: _nombreController.text,
        detalle: _detalleController.text,
        estado: _estado,
        id: widget.tarea?.id,
      );
      if (widget.tarea == null) {
        _tareaController.craeteTarea(nuevaTarea);
      } else if (widget.tarea!.id != null) {
        _tareaController.updateTarea(widget.tarea!.id!, nuevaTarea);
      }

      Get.back(); // Regresar a la lista de tareas
    }
  }
}
