import 'package:meine_essens_app/models/category.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meine_essens_app/models/http_exception.dart';
import 'package:meine_essens_app/models/meal.dart';

class Categories with ChangeNotifier {
  List<Category> DUMMY_CATEGORIES = [];
  List<Meal> DUMMY_MEALS = [];
  Category findByIdd(String id) {
    return DUMMY_CATEGORIES.firstWhere((cat) => cat.id == id);
  }

  List<Category> get itemsCat {
    return [...DUMMY_CATEGORIES];
  }

  // Future<void> fetchAndSetCategories() async {
  //   const url =
  //       'https://meine-app-4cc52-default-rtdb.firebaseio.com/Categories.json';
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Category> loadedCategories = [];
  //     extractedData.forEach((catId, catData) {
  //       loadedCategories.add(Category(id: catId, title: catData['title']));
  //     });

  //     print(json.decode(response.body));
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Future<void> updateCatgories(String id, Category newCategory) async {
    final prodIndex = itemsCat.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://meine-app-4cc52-default-rtdb.firebaseio.com/Categories/$id.json';
      await http.patch(Uri.parse(Uri.encodeFull(url)),
          body: json.encode({
            'category': newCategory.title,
          }));
      DUMMY_CATEGORIES[prodIndex] = newCategory;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteCategorie(String id) async {
    final url =
        'https://meine-app-4cc52-default-rtdb.firebaseio.com/Categories/$id.json';
    final existingCategoriesIndex =
        DUMMY_CATEGORIES.indexWhere((cat) => cat.id == id);
    var existingCategorie = DUMMY_CATEGORIES[existingCategoriesIndex];
    DUMMY_CATEGORIES.removeAt(existingCategoriesIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(Uri.encodeFull(url)));
    print(response.statusCode);
    if (response.statusCode >= 400) {
      DUMMY_CATEGORIES.insert(existingCategoriesIndex, existingCategorie);
      notifyListeners();
      throw HttpException('could not delete categorie.');
    }
    existingCategorie = null;
  }

  Future<void> addCategories(Category cat) async {
    const url =
        'https://meine-app-4cc52-default-rtdb.firebaseio.com/Categories.json';
    try {
      final response = await http.post(
        Uri.parse(Uri.encodeFull(url)),
        body: json.encode({
          'title': cat.title,
        }),
      );
      final newCategories = Category(
        id: json.decode(response.body)['name'],
        title: cat.title,
      );
      DUMMY_CATEGORIES.add(newCategories);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  notifyListeners();
  Future<void> categoryList() async {
    final url =
        'https://meine-app-4cc52-default-rtdb.firebaseio.com/Categories.json';
    //'https://meine-app-4cc52-default-rtdb.firebaseio.com/Categories.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(Uri.encodeFull(url)));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Category> loadedCategories = [];
      extractedData.forEach((catId, catData) {
        loadedCategories.add(Category(id: catId, title: catData['title']));
        print(catData['title']);
      });
      DUMMY_CATEGORIES = loadedCategories;
      notifyListeners();
    } catch (error) {}
    DUMMY_CATEGORIES.map((category) => Text('test'));
  }

  final String authToken;
  Categories(this.authToken, this.DUMMY_CATEGORIES);

/*const url = 'https://inventurapp-2c89b-default-rtdb.firebaseio.com/Categories';
  try{
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Category> loadedCategories = [];
    extractedData.forEach((catId, catData) { 
      loadedCategories.add(Category(
        id: catId,
        title: catData['title']
      ));
    });
    DUMMY_CATEGORIES = loadedCategories;
  }catch(error){
    throw error;
  }*/

}
