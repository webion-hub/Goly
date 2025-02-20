import 'package:flutter/material.dart';
import 'package:goly/models/user.dart';
import 'package:goly/providers/user_provider.dart';
import 'package:goly/utils/validators.dart';
import 'package:goly/widgets/form/buttons/main_button.dart';
import 'package:goly/widgets/form/input/text_field_input.dart';
import 'package:goly/widgets/settings/settings_switcher_list_tile.dart';
import 'package:goly/models/category.dart';
import 'package:goly/services/category_service.dart';
import 'package:goly/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HandleCategoryScreen extends StatefulWidget {
  static const String routeNameEdit = "/handle-category";
  static const String routeNameAdd = "/add-category";
  final CategoryModel? category;
  const HandleCategoryScreen({super.key, this.category});

  @override
  State<HandleCategoryScreen> createState() => _HandleCategoryScreenState();
}

class _HandleCategoryScreenState extends State<HandleCategoryScreen> {
  final formKey = GlobalKey<FormState>();
  late UserModel user = Provider.of<UserProvider>(context).getUser;
  late bool privateCategory = widget.category?.private ?? false;
  late bool privateDescription = widget.category?.privateDescription ?? user.settings.privateDescriptionsByDefault;

  late final categoryName = TextEditingController(text: widget.category?.name ?? '');
  late final description = TextEditingController(text: widget.category?.description ?? '');

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
    void handleCategory() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      CategoryModel c = CategoryModel(
        id: widget.category?.id ?? const Uuid().v1(),
        name: categoryName.text,
        private: privateCategory,
        description: description.text,
        privateDescription: privateDescription,
      );

      widget.category == null ? CategoryService.addCategory(category: c) : CategoryService.editCategory(category: c);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.category != null ? 'Edit category' : 'Add category')),
      body: SingleChildScrollView(
        child: Column(children: [
          Center(
            child: Container(
              padding: Constants.pagePadding,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFieldInput(
                      textEditingController: categoryName,
                      hintText: 'Name',
                      textInputType: TextInputType.text,
                      label: 'Name',
                      validation: Validations.validateNotEmpty,
                    ),
                    TextFieldInput(
                      textEditingController: description,
                      hintText: 'Description',
                      textInputType: TextInputType.multiline,
                      maxLines: 5,
                      label: 'Description',
                    ),
                    SettingsSwitcherListTile(
                      initialValue: privateCategory,
                      icon: Icons.lock,
                      text: "Private category",
                      subtitle: "Makes private the description and all the goals inside it",
                      onChanged: privateCategoryChange
                    ),
                    const SizedBox(height: 20.0),
                    SettingsSwitcherListTile(
                      inactive: privateCategory,
                      initialValue: privateCategory ? true : privateDescription,
                      icon: Icons.lock,
                      text: "Private description",
                      subtitle: "Makes private description",
                      onChanged: privateDescriptionChange
                    ),
                    const SizedBox(height: 20.0),
                    MainButton(
                      text: widget.category != null ? 'Update category' : 'Add category',
                      onPressed: handleCategory,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
