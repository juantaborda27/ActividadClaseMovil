import 'package:app_clase_juan/data/models/tarea_model.dart';
import 'package:app_clase_juan/domain/controller/tarea_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TareaFormPage extends StatelessWidget {
  final Tarea? tarea;
  TareaFormPage({Key? key, this.tarea}) : super(key: key);

  // Controladores para los campos de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _detalleController = TextEditingController();
  
  // Variables reactivas
  final RxString _estado = 'pendiente'.obs;
  final RxBool _isSubmitting = false.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TareaController _tareaController = Get.find<TareaController>();
    
    // Inicializar valores si estamos editando
    if (tarea != null) {
      _nombreController.text = tarea!.nombre;
      _detalleController.text = tarea!.detalle;
      _estado.value = tarea!.estado;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tarea == null ? 'Nueva Tarea' : 'Editar Tarea'),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información de la tarea',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nombreController,
                        decoration: InputDecoration(
                          labelText: 'Nombre de la Tarea',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.assignment),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _detalleController,
                        decoration: InputDecoration(
                          labelText: 'Detalles',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.description),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Obx(() => DropdownButtonFormField<String>(
                        value: _estado.value,
                        items: [
                          DropdownMenuItem(
                            value: 'pendiente',
                            child: Row(
                              children: [
                                const Icon(Icons.schedule, color: Colors.blue),
                                const SizedBox(width: 8),
                                const Text('Pendiente'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'en progreso',
                            child: Row(
                              children: [
                                const Icon(Icons.pending, color: Colors.orange),
                                const SizedBox(width: 8),
                                const Text('En progreso'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'completada',
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                const SizedBox(width: 8),
                                const Text('Completada'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          _estado.value = value!;
                        },
                        decoration: InputDecoration(
                          labelText: 'Estado',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                onPressed: _isSubmitting.value ? null : () => _submitForm(_tareaController),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting.value
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Procesando...'),
                        ],
                      )
                    : Text(
                        tarea == null ? 'Crear Tarea' : 'Actualizar Tarea',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )),
              if (tarea != null) const SizedBox(height: 12),
              if (tarea != null)
                TextButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Cancelar'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(TareaController tareaController) async {
    if (_formKey.currentState!.validate()) {
      _isSubmitting.value = true;

      final nuevaTarea = Tarea(
        nombre: _nombreController.text,
        detalle: _detalleController.text,
        estado: _estado.value,
        id: tarea?.id,
      );

      try {
        if (tarea == null) {
          await tareaController.craeteTarea(nuevaTarea);
          Get.snackbar(
            'Éxito',
            'Tarea creada correctamente',
            backgroundColor: Colors.green[100],
            colorText: Colors.green[800],
            snackPosition: SnackPosition.BOTTOM,
          );
        } else if (tarea!.id != null) {
          await tareaController.updateTarea(tarea!.id!, nuevaTarea);
          Get.snackbar(
            'Éxito',
            'Tarea actualizada correctamente',
            backgroundColor: Colors.green[100],
            colorText: Colors.green[800],
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        
        // Regresar a la lista de tareas
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Ha ocurrido un error: $e',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        _isSubmitting.value = false;
      }
    }
  }
}