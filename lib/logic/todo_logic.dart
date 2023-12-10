

import 'package:flutter/cupertino.dart';
import 'package:mars_launcher/services/shared_prefs_manager.dart';

const KEY_TODO_LIST = "todoList";

class TodoLogic {

  ValueNotifier<List<String>> todoListNotifier = ValueNotifier(SharedPrefsManager.readStringList(KEY_TODO_LIST) ?? []);

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
    SharedPrefsManager.saveData(KEY_TODO_LIST, todoListNotifier.value);
  }
}