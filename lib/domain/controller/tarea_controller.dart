


import 'package:app_clase_juan/data/models/tarea_model.dart';
import 'package:app_clase_juan/data/repositories/tarea_repository.dart';
import 'package:get/get.dart';

class TareaController extends GetxController{

  final TareaRepository repository = TareaRepository();

  RxList tareas = [].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;


  @override
  void onInit(){
    super.onInit();
    fetchTareas();
  }


  Future fetchTareas() async{
    try {
      isLoading.value = true;
      error.value = '';
      
      final fectchTarea = await repository.getTareas();
      tareas.assignAll(fectchTarea);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCompleted(int i){
    final tarea = tareas[i];
    tareas[i] = Tarea(
      nombre: tarea.nombre,
      detalle: tarea.detalle,
      estado: tarea.estado,
      id: tarea.id,
    );
  }

  Future<void> craeteTarea(Tarea tarea) async{
    try {
      isLoading.value = true;
      error.value = '';

      final newTarea = await repository.createTarea(tarea);
      tareas.add(newTarea);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTarea(int id, Tarea updateTarea) async {
    try {
      isLoading.value = true;
      error.value = '';
      final tarea = await repository.updateTarea(id, updateTarea);
      int i = tareas.indexWhere((t) => t.id == id);
      if(i != -1){
        tareas[i] = tarea;
      }
    } catch (e) {
      error.value = e.toString();
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> deleteTarea(int id) async{
    try {
      isLoading.value = true;
      error.value = '';
      await repository.deleteTarea(id);
      tareas.removeWhere((t) => t.id == id);
    } catch (e) {
      error.value = e.toString();
    } finally{
      isLoading.value = false;
    }
  }

}