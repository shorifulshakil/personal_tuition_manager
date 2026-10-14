import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../providers/major/student_provider.dart';
import '../../models/student_update.dart';
import '../../utils/handle_errors.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_form_text_field.dart';
import '../../widgets/custom_snackbar.dart';

class StudentForm extends StatefulWidget {
  final StudentUpdate? student;

  const StudentForm({super.key, this.student});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _addressController;
  late TextEditingController _fatherNameController;
  late TextEditingController _fatherMobileController;
  late TextEditingController _batchTimeController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.student?.name ?? '',
    );
    _mobileController = TextEditingController(
      text: widget.student?.mobile ?? '',
    );
    _addressController = TextEditingController(
      text: widget.student?.address ?? '',
    );
    _fatherNameController = TextEditingController(
      text: widget.student?.fatherName ?? '',
    );
    _fatherMobileController = TextEditingController(
      text: widget.student?.fatherMobile ?? '',
    );
    _batchTimeController = TextEditingController(
      text: widget.student?.batchTime ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _fatherNameController.dispose();
    _fatherMobileController.dispose();
    _batchTimeController.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    return _nameController.text != (widget.student?.name ?? '') ||
        _mobileController.text != (widget.student?.mobile ?? '') ||
        _addressController.text != (widget.student?.address ?? '') ||
        _fatherNameController.text != (widget.student?.fatherName ?? '') ||
        _fatherMobileController.text != (widget.student?.fatherMobile ?? '') ||
        _batchTimeController.text != (widget.student?.batchTime ?? '');
  }

  Future<void> _saveForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (!_hasChanges()) {
        Navigator.of(context).pop(false);
        return;
      }

      final student = StudentUpdate(
        id: widget.student?.id,
        name: _nameController.text.trim(),
        mobile: _mobileController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        fatherName: _fatherNameController.text.trim().isEmpty ? null : _fatherNameController.text.trim(),
        fatherMobile: _fatherMobileController.text.trim().isEmpty ? null : _fatherMobileController.text.trim(),
        batchTime: _batchTimeController.text.trim().isEmpty ? null : _batchTimeController.text.trim(),
      );

      final studentProvider = Provider.of<StudentProvider>(context, listen: false);
      final nav = Navigator.of(context);

      try {
        if (widget.student != null) {
          await studentProvider.updateStudent(student);
          if (mounted) {
            showCustomSnackBar(context, 'Student updated successfully!');
            nav.pop(true);
          }
        } else {
          await studentProvider.createStudent(student);
          if (mounted) {
            showCustomSnackBar(context, 'Student added successfully!');
            nav.pop(true);
          }
        }
      } catch (e) {
        if (mounted) {
          handleErrors(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPaddings.mediumPadding),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16.0),
              Text(widget.student != null ? 'Edit Student' : 'Add Student',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16.0),
              CustomFormTextField(
                controller: _nameController,
                labelText: 'Name',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter student name';
                  }
                  if (!RegularExpressions.nameRegex.hasMatch(value.trim())) {
                    return 'Name must be at least 3 characters and contain letters only';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomFormTextField(
                controller: _mobileController,
                labelText: 'Mobile Number (11 digits)',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty || value.trim().length != 11) {
                    return 'Enter a valid 11-digit mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomFormTextField(
                controller: _batchTimeController,
                labelText: 'Batch Time (e.g. 10:00 AM)',
                prefixIcon: Icons.access_time,
              ),
              const SizedBox(height: 16),
              CustomFormTextField(
                controller: _addressController,
                labelText: 'Address',
                prefixIcon: Icons.location_on,
              ),
              const SizedBox(height: 16),
              CustomFormTextField(
                controller: _fatherNameController,
                labelText: "Father's Name",
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomFormTextField(
                controller: _fatherMobileController,
                labelText: "Father's Mobile (11 digits)",
                prefixIcon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty && value.trim().length != 11) {
                    return 'Enter a valid 11-digit mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  text: widget.student != null ? 'Update' : 'Add',
                  onPressed: () async {
                    await _saveForm(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
