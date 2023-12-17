

import 'package:flutter/material.dart';
import 'package:mars_launcher/services/service_locator.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';
import 'package:mars_launcher/strings.dart';



class TodoManager {
  final sharedPrefsManager = getIt<SharedPrefsManager>();
  late ValueNotifier<List<String>> todoListNotifier;

  TodoManager() {
    todoListNotifier = ValueNotifier(sharedPrefsManager.readStringList(Keys.todoList) ?? []);
  }

  addTodo(String todo) {
    var updatedTodoList = List.of(todoListNotifier.value);
    updatedTodoList.add(todo);
    todoListNotifier.value = updatedTodoList;

    saveTodosToSharedPrefs();
  }

  updateTodo(int index, String updatedTodo) {
    var updatedTodoList = List.of(todoListNotifier.value);
    updatedTodoList[index] = updatedTodo;
    todoListNotifier.value = updatedTodoList;

    saveTodosToSharedPrefs();
  }

  removeTodo(int index) {
    var updatedTodoList = List.of(todoListNotifier.value);
    updatedTodoList.removeAt(index);
    todoListNotifier.value = updatedTodoList;

    saveTodosToSharedPrefs();
  }

  clearTodoList() {
    todoListNotifier.value = [];
    saveTodosToSharedPrefs();
  }

  saveTodosToSharedPrefs() {
    sharedPrefsManager.saveData(Keys.todoList, todoListNotifier.value);
  }
}