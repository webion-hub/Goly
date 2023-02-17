import 'package:goly/models/step.dart';

class GoalModel {
  String name;
  String? description;
  String? reward;
  bool completed;
  bool privateGoal;
  bool privateDescription;
  bool privateReward;
  List<StepModel>? steps;

  GoalModel({
    required this.name,
    this.description,
    this.steps,
    this.reward,
    this.completed = false,
    this.privateGoal = true,
    this.privateDescription = true,
    this.privateReward = true,
  });

  GoalModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        completed = json['completed'],
        privateGoal = json['privateGoal'],
        privateDescription = json['privateDescription'],
        privateReward = json['privateReward'] ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['completed'] = completed;
    data['privateGoal'] = privateGoal;
    data['privateDescription'] = privateDescription;
    return data;
  }
}
