import 'package:app_clase_juan/presentation/widgets/tarea_form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_clase_juan/domain/controller/tarea_controller.dart';
import 'package:app_clase_juan/data/models/tarea_model.dart';

class TareaListPage extends StatelessWidget {
  const TareaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TareaController tareaController = Get.put(TareaController());
    final searchController = TextEditingController();
    final RxString searchQuery = ''.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => TareaFormPage()),
            tooltip: 'Añadir nueva tarea',
          ),
        ],
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar tarea...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() => searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          searchQuery.value = '';
                        },
                      )
                    : const SizedBox.shrink()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                searchQuery.value = value;
              },
            ),
          ),
          
          // Lista de tareas
          Expanded(
            child: Obx(() {
              if (tareaController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (tareaController.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${tareaController.error.value}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => tareaController.fetchTareas(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              // Filtrar tareas según la búsqueda
              final filteredTareas = tareaController.tareas.where((tarea) {
                return tarea.nombre
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase());
              }).toList();

              if (filteredTareas.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        searchQuery.value.isEmpty
                            ? Icons.assignment
                            : Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        searchQuery.value.isEmpty
                            ? 'No hay tareas pendientes'
                            : 'No se encontraron resultados para "${searchQuery.value}"',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (searchQuery.value.isNotEmpty)
                        TextButton.icon(
                          icon: const Icon(Icons.clear),
                          label: const Text('Limpiar búsqueda'),
                          onPressed: () {
                            searchController.clear();
                            searchQuery.value = '';
                          },
                        ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  itemCount: filteredTareas.length,
                  itemBuilder: (context, index) {
                    final tarea = filteredTareas[index];
                    // Obtener colores según el estado
                    Color statusColor;
                    IconData statusIcon;
                    
                    switch (tarea.estado.toLowerCase()) {
                      case 'completada':
                        statusColor = Colors.green;
                        statusIcon = Icons.check_circle;
                        break;
                      case 'en progreso':
                        statusColor = Colors.orange;
                        statusIcon = Icons.pending;
                        break;
                      default:
                        statusColor = Colors.blue;
                        statusIcon = Icons.schedule;
                    }
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Icon(
                          statusIcon,
                          color: statusColor,
                          size: 28,
                        ),
                        title: Text(
                          tarea.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(tarea.detalle),
                            const SizedBox(height: 4),
                            Chip(
                              label: Text(
                                tarea.estado,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: statusColor.withOpacity(0.1),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () => Get.to(() => TareaFormPage(tarea: tarea)),
                              tooltip: 'Editar tarea',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                // Diálogo de confirmación
                                Get.defaultDialog(
                                  title: '¿Eliminar tarea?',
                                  content: Text(
                                    '¿Estás seguro que deseas eliminar la tarea "${tarea.nombre}"?',
                                    textAlign: TextAlign.center,
                                  ),
                                  confirm: ElevatedButton(
                                    onPressed: () {
                                      tareaController.deleteTarea(tarea.id);
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Eliminar'),
                                  ),
                                  cancel: TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancelar'),
                                  ),
                                );
                              },
                              tooltip: 'Eliminar tarea',
                            ),
                          ],
                        ),
                        onTap: () {
                          // Mostrar detalles de la tarea
                          Get.bottomSheet(
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(statusIcon, color: statusColor),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          tarea.nombre,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  const Text(
                                    'Detalles:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    tarea.detalle.isEmpty
                                        ? 'Sin detalles'
                                        : tarea.detalle,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Chip(
                                        label: Text(
                                          tarea.estado,
                                          style: TextStyle(color: statusColor),
                                        ),
                                        backgroundColor: statusColor.withOpacity(0.1),
                                      ),
                                      Row(
                                        children: [
                                          TextButton.icon(
                                            icon: const Icon(Icons.edit),
                                            label: const Text('Editar'),
                                            onPressed: () {
                                              Get.back();
                                              Get.to(() => TareaFormPage(tarea: tarea));
                                            },
                                          ),
                                          TextButton.icon(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                            onPressed: () {
                                              Get.back();
                                              // Diálogo de confirmación
                                              Get.defaultDialog(
                                                title: '¿Eliminar tarea?',
                                                content: Text(
                                                  '¿Estás seguro que deseas eliminar la tarea "${tarea.nombre}"?',
                                                  textAlign: TextAlign.center,
                                                ),
                                                confirm: ElevatedButton(
                                                  onPressed: () {
                                                    tareaController.deleteTarea(tarea.id);
                                                    Get.back();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  child: const Text('Eliminar'),
                                                ),
                                                cancel: TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text('Cancelar'),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => TareaFormPage()),
        child: const Icon(Icons.add),
        tooltip: 'Añadir nueva tarea',
      ),
    );
  }
}

