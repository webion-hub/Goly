import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goly/models/category.dart';
import 'package:goly/utils/utils.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collection = _firestore.collection('goals');

class CategoryService extends Service {
  static Future addCategory({required CategoryModel category}) async {
    return await _collection
      .doc(Utils.currentUid()).collection('categories')
      .add(category.toJson(),);
  }

  static Future editCategory({required CategoryModel category}) async {
    return await _collection
      .doc(Utils.currentUid()).collection('categories')
      .doc('eWdXda9XtZ4UlFmfS3DG')
      .update(category.toJson());
  }


}
