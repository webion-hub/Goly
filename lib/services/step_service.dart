import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goly/models/goal.dart';
import 'package:goly/models/step.dart';
import 'package:goly/services/goal_service.dart';
import 'package:goly/utils/utils.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collection = _firestore.collection('goals');

class StepService extends Service {
  static Future addStepToGoal({required String categoryId, required int goalId, required StepModel step}) async {
    /// Set goal as not completed if we add a step
    GoalModel? goal;
    await GoalService.getGoalFromId(
      categoryId: categoryId,
      goalId: goalId,
    ).then((value) {
      goal = GoalModel.fromJson(value.data()!);
    });

    if (goal == null) {
      return;
    }
    await GoalService.toggleGoalCompleted(categoryId: categoryId, goal: goal!, value: false);
    return await _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .doc(categoryId)
      .collection('goals')
      .doc(goalId.toString())
      .update({
        'steps': FieldValue.arrayUnion([step.toJson()])
      });
  }

  static Future editStep({
    required String categoryId,
    required int goalId,
    required StepModel step,
  }) async {
    final docref =
        _collection.doc(Utils.currentUid()).collection('categories').doc(categoryId).collection('goals').doc(goalId.toString());
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docref);
      final goal = GoalModel.fromJson(snapshot.data()!);
      goal.steps?[step.id] = step;
      transaction.update(docref, goal.toJson());
    });
  }

  static Future deleteStep({
    required String categoryId,
    required int goalId,
    required int stepId,
    required StepModel step,
  }) async {
    return await _collection
      .doc(Utils.currentUid())
      .collection('categories')
      .doc(categoryId)
      .collection('goals')
      .doc(goalId.toString())
      .update({
        'steps': FieldValue.arrayRemove([step.toJson()])
      });
  }
}
