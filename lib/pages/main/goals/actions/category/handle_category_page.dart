import 'package:flutter/material.dart';
import 'package:goly/components/buttons/main_button.dart';
import 'package:goly/components/settings/settings_switcher.dart';
import 'package:goly/models/category.dart';
import 'package:goly/services/category_service.dart';
import 'package:goly/utils/constants.dart';

class HandleCategoryPage extends StatefulWidget {
  static String routeName = "add-category";
  final CategoryModel? category;
  const HandleCategoryPage({super.key, this.category});

  @override
  State<HandleCategoryPage> createState() => _HandleCategoryPageState();
}

class _HandleCategoryPageState extends State<HandleCategoryPage> {
  bool privateCategory = false;
  bool privateDescription = false;

  late TextEditingController categoryName =
      TextEditingController(text: widget.category?.name ?? '');

  late TextEditingController description =
      TextEditingController(text: widget.category?.description ?? '');

  void privateCategoryChange(bool value) {
    setState(() {
      privateCategory = value;
    });
  }

  void privateDescriptionChange(bool value) {
    setState(() {
      privateDescription = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    void addCategory() async {
      CategoryModel c = CategoryModel(
          name: categoryName.text,
          private: privateCategory,
          description: description.text,
          goals: widget.category?.goals,
          privateDescription: privateDescription);

      widget.category == null
          ? CategoryService.addCategory(category: c)
          : CategoryService.editCategory(category: c);
    }

    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.category != null ? 'Edit category' : 'Add category')),
      body: Column(children: [
        Center(
          child: Container(
            padding: Constants.pagePadding,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: categoryName,
                    decoration: const InputDecoration(labelText: 'Name'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: description,
                    decoration: const InputDecoration(labelText: 'Description'),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20.0),
                  SettingsSwitcher(
                      initialValue: privateCategory,
                      icon: Icons.lock,
                      text: "Private category",
                      subtitle: "Makes private all the goals inside it",
                      onChanged: privateCategoryChange),
                  const SizedBox(height: 20.0),
                  SettingsSwitcher(
                      initialValue: privateDescription,
                      icon: Icons.lock,
                      text: "Private description",
                      subtitle: "Makes private description",
                      onChanged: privateDescriptionChange),
                  const SizedBox(height: 20.0),
                  MainButton(
                    text: widget.category != null
                        ? 'Update category'
                        : 'Add category',
                    onPressed: addCategory,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
