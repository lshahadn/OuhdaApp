import 'package:bustracking/controllers/admin/admin_controller.dart';
import 'package:bustracking/data/models/body/school_model.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:bustracking/layout/widgets/custom_text_field.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:bustracking/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditSchoolModal extends StatefulWidget {
  SchoolModel model;
  EditSchoolModal({Key? key, required this.model}) : super(key: key);

  @override
  State<EditSchoolModal> createState() => _EditSchoolModalState();
}

class _EditSchoolModalState extends State<EditSchoolModal> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _schoolNameFocus = FocusNode();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _schoolNameController = TextEditingController();

  @override
  void initState() {
    _emailController.text = widget.model.email!;
    _schoolNameController.text = widget.model.schoolName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminController>(builder: (adminController) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsetsDirectional.only(top: 17.0),
                  height: 4,
                  width: 80,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  'Edit School',
                  style: TextStyle(
                      fontSize: 30.0,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.mainColor,
                      fontFamily: 'Cairo'),
                ),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 1,
                        blurRadius: 8)
                  ],
                ),
                child: Column(children: [
                  CustomTextField(
                    hintText: 'Email',
                    controller: _emailController,
                    focusNode: _emailFocus,
                    nextFocus: _emailFocus,
                    inputType: TextInputType.emailAddress,
                    capitalization: TextCapitalization.words,
                    // prefixIcon: Images.user,
                    divider: true,
                  ),
                  CustomTextField(
                    hintText: 'School Name',
                    controller: _schoolNameController,
                    focusNode: _schoolNameFocus,
                    nextFocus: _schoolNameFocus,
                    inputType: TextInputType.text,
                    divider: true,
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              !adminController.isLoading
                  ? Row(children: [
                      Expanded(
                          child: CustomButton(
                        buttonText: 'Update',
                        onPressed: () => _update(adminController),
                      )),
                    ])
                  : Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  void _update(AdminController adminController) async {
    String _email = _emailController.text.trim();
    String _schoolName = _schoolNameController.text.trim();

    if (_email.isEmpty) {
      showCustomSnackBar('Enter email address');
    } else if (_schoolName.isEmpty) {
      showCustomSnackBar('Enter School Name');
    } else {
      adminController
          .updateNewSchool(_email, _schoolName, widget.model.id)
          .then((response) async {
        if (response) {
          Navigator.pop(context);
          showCustomSnackBar("School Updated Successfully!", isError: false);
        } else {
          print(response);
          showCustomSnackBar("Failed to Update School!", isError: true);
        }
      });
    }
  }
}
