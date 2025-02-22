import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goly/models/category.dart';
import 'package:goly/models/goal.dart';
import 'package:goly/services/goal_service.dart';
import 'package:goly/utils/constants.dart';
import 'package:goly/utils/utils.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collection = _firestore.collection('goals');

class CategoryService extends Service {
  ///Add a new category to firestore under the collection categories
  static Future addCategory({required CategoryModel category}) async {
    return _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .doc(category.id)
      .set(category.toJson());
  }

  ///Edit a new category to firestore under the collection categories
  static Future editCategory({required CategoryModel category}) async {
    return _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .doc(category.id)
      .update(category.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCategoriesStream({String? userId}) {
    return _collection
      .doc(userId ?? Utils.currentUid())
      .collection('categories')
      .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getCategoryStream({String? userId, required String categoryId}) {
    return _collection
      .doc(userId ?? Utils.currentUid())
      .collection('categories')
      .doc(categoryId)
      .snapshots();
  }

  static Future deleteCategory({required String categoryId}) async {
    await deleteCategoryGoals(categoryId: categoryId);
    return _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .doc(categoryId)
      .delete();
  }

  static Future deleteCategoryGoals({required String categoryId}) async {
    return _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .doc(categoryId)
      .collection('goals')
      .doc()
      .delete();
  }

  static Future<int> getNumberofGoals({required String categoryId}) async {
    return _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .doc(categoryId)
      .collection('goals')
      .get()
      .then((value) => value.size);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCategoryGoalsStream({
    required String categoryId,
    String? uid,
  }) {
    return _collection
      .doc(uid ?? Utils.currentUid())
      .collection('categories')
      .doc(categoryId)
      .collection('goals')
      .orderBy('priority', descending: true)
      .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getCategoryGoals({required String categoryId}) async {
    return _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .doc(categoryId)
      .collection('goals')
      .get();
  }

  static Future getCategoryById({required String categoryId}) async {
    return _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .doc(categoryId)
      .get()
      .then((value) => value);
  }

  static Future<double> getPercentageOfCompletition(CategoryModel category) async {
    final int numberOfGoals = await CategoryService.getNumberofGoals(categoryId: category.id);
    final goalsFuture = await CategoryService.getCategoryGoals(categoryId: category.id);
    
    var completed = 0.0;
    for (var e in goalsFuture.docs) {
      final goal = GoalModel.fromJson(e.data());
      completed += GoalService.getPercentageOfCompletition(goal);
    }
    return numberOfGoals == 0 ? 0 : completed / numberOfGoals;
  }

  static Future setDefaultCategories() async {
    final futures = Constants.defaultCategories.map((element) async {
      await addCategory(category: element);
    });
    return Future.wait(futures);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllCategories() async {
    return _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .get();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getOrderedCategories({String? uid}) {
    return FirebaseFirestore.instance
        .collection('goals')
        .doc(uid ?? Utils.currentUid())
        .collection('categories')
        .orderBy('name')
        .snapshots();
  }
}
