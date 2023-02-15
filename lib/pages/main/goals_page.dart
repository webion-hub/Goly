import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goly/components/app_bars/goals_app_bar.dart';
import 'package:goly/components/cards/action_card.dart';
import 'package:goly/components/list_tile/category_list_tile.dart';
import 'package:goly/components/statistics/goals_per_life_area.dart';
import 'package:goly/models/category.dart';
import 'package:goly/pages/main/goals/handle_category_page.dart';
import 'package:goly/utils/constants.dart';
import 'package:goly/utils/utils.dart';

class GoalsPage extends StatefulWidget {
  static const routeName = '/goals';
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _MainPageState();
}

class _MainPageState extends State<GoalsPage> {
  void addCategory() {
    Navigator.of(context).pushNamed(HandleCategoryPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    //var categories = DummyData.categories;
    List<CategoryModel> categories = List.empty();
    return Scaffold(
        appBar: const GoalsAppBar(),
        body: SingleChildScrollView(
          padding: Constants.pagePadding,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('goals')
                  .doc(Utils.currentUid())
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                snapshot.data?.docs.map((element) {
                  categories.add(CategoryModel.fromJson(element.data()));
                });
                // snapshot.data?.docs.forEach((element) {print(element.data()); });
                // snapshot.data?.docs.toList().map((e) => print(e.toString()));

                return Column(
                  children: [
                    Text(
                      'Life areas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ...categories
                        .map((category) => CategoryCard(category: category)),
                    ...?snapshot.data?.docs.map((e) => CategoryCard(
                        category: CategoryModel.fromJson(e.data()))),
                    ActionCard(
                      text: "Add category",
                      icon: Icons.add,
                      action: addCategory,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const GoalsPerLifeArea(),
                  ],
                );
              }),
        ));
  }
}
