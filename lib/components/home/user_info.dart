import 'dart:io';
import 'package:dividit/controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _controller = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: _controller.name.value);
    _emailController = TextEditingController(text: _controller.email.value);
    _phoneController = TextEditingController(text: _controller.phone.value);
    _dobController = TextEditingController(
      text: _dateFormat.format(_controller.dob.value),
    );

    ever(_controller.name, (val) => _nameController.text = val);
    ever(_controller.email, (val) => _emailController.text = val);
    ever(_controller.phone, (val) => _phoneController.text = val);
    ever(_controller.dob, (val) {
      _dobController.text = _dateFormat.format(val);
    });
  }

  @override
  void dispose() {
    // _nameController.dispose();
    // _emailController.dispose();
    // _phoneController.dispose();
    // _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _controller.imageUrl.value = file.path;
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _controller.dob.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _controller.dob.value = picked;
      _dobController.text = _dateFormat.format(picked);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }

  void completeProfileSave() async {
    if (_formKey.currentState!.validate()) {
      final result = await _controller.updateProfile(
        name: _controller.name.value,
        email: _controller.email.value,
        phone: _controller.phone.value,
        imageUrl: _controller.imageUrl.value,
        dob: _controller.dob.value,
      );

      if (result.success == 1) {
        Get.snackbar("✅ Success", "Profile updated");

        // Clear form fields
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _dobController.clear();

        // Reset controller variables
        _controller.name.value = '';
        _controller.email.value = '';
        _controller.phone.value = '';
        _controller.imageUrl.value = '';
        _controller.dob.value = DateTime.now();

        // Optional: Reset DOB text to current date
        _dobController.text = _dateFormat.format(DateTime.now());
      } else {
        Get.snackbar("❌ Error", result.error ?? "Update failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete your profile")),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Obx(() {
                    final imageUrl = _controller.imageUrl.value;

                    ImageProvider? imageProvider;
                    if (imageUrl.isNotEmpty) {
                      if (imageUrl.startsWith('http')) {
                        imageProvider = NetworkImage(imageUrl);
                      } else {
                        imageProvider = FileImage(File(imageUrl));
                      }
                    }

                    return CircleAvatar(
                      radius: 150,
                      backgroundImage: imageProvider,
                    );
                  }),
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Name"),
                  onChanged: (val) => _controller.name.value = val,
                  validator:
                      (val) =>
                          val == null || val.isEmpty ? "Name required" : null,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration("Email"),
                  onChanged: (val) => _controller.email.value = val,
                  validator:
                      (val) =>
                          val == null || !val.contains('@')
                              ? "Valid email required"
                              : null,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration("Phone"),
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => _controller.phone.value = val,
                  validator:
                      (val) =>
                          val == null || val.length < 10
                              ? "Valid phone required"
                              : null,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: _inputDecoration(
                    "Date of Birth",
                  ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                  onTap: () => _pickDate(context),
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    completeProfileSave();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
