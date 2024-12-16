import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../models/user_model.dart';
import '../../services/current_user_service.dart';
import '../../styles/colors.dart';

class Reqpage extends StatefulWidget {
  const Reqpage({super.key});

  @override
  _ReqpageState createState() => _ReqpageState();
}

class _ReqpageState extends State<Reqpage> {
  // call firestore service
  CurrentUserService firestoreService = CurrentUserService();
  // get data from firestore using the model
  UserModel? currentUser;

  // load user data
  Future<void> _loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // initiate load
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  File? _idFrontImage;
  File? _idBackImage;
  bool _isEditing = true;

  final _idNumberController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedBirthdate;
  String? _selectedIDType;

  Future<void> _pickImage(Function(File?) onImagePicked,
      {bool fromCamera = false}) async {
    final pickedImage = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        onImagePicked(File(pickedImage.path));
      });
      // Automatically populate ID field upon successful picture
      if (onImagePicked == (file) => _idFrontImage = file) {
        _idNumberController.text =
            "Auto-generated ID number"; // Placeholder logic
      }
    }
  }

  Future<void> _pickBirthdate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedBirthdate = pickedDate;
      });
    }
  }

  void _saveProfile() {
    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text("Updated successfully"),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Input styling
  InputDecoration get _defaultInputDecoration => InputDecoration(
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.purple),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return currentUser == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Verification',
              ),
              backgroundColor: primaryColor,
              actions: [
                TextButton(
                  onPressed: _saveProfile,
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileField(
                    label: 'Name',
                    initialValue: currentUser!.name,
                    onSaved: (value) => currentUser!.name = value,
                    validator: null,
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  _buildProfileField(
                    label: 'Email',
                    initialValue: currentUser!.email,
                    onSaved: (value) => currentUser!.email = value,
                    validator: null,
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  _buildIDTypeField(),
                  const SizedBox(height: 20),
                  _buildIDNumberField(), // ID number field
                  const SizedBox(height: 20),
                  _buildIDUploadSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
  }

  Widget _buildIDTypeField() {
    return DropdownButtonFormField<String>(
      value: _selectedIDType,
      items: [
        'National ID',
        'Driver\'s License',
        'Passport',
        'SSS ID',
        'PhilHealth ID',
        'Postal ID',
        'Voter\'s ID'
      ]
          .map((idType) => DropdownMenuItem(value: idType, child: Text(idType)))
          .toList(),
      onChanged: _isEditing
          ? (value) => setState(() => _selectedIDType = value)
          : null,
      decoration: InputDecoration(
        labelText: 'Valid ID',
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildIDNumberField() {
    return TextFormField(
      controller: _idNumberController,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: 'ID Number',
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildIDUploadSection() {
    return Column(
      children: [
        const Text('Upload ID',
            style: TextStyle(fontSize: 16, fontFamily: 'Poppins')),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIDImageSection(
              label: 'Front',
              image: _idFrontImage,
              onTap: () =>
                  _pickImage((file) => _idFrontImage = file, fromCamera: true),
            ),
            _buildIDImageSection(
              label: 'Back',
              image: _idBackImage,
              onTap: () =>
                  _pickImage((file) => _idBackImage = file, fromCamera: true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIDImageSection({
    required String label,
    required File? image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              image: image != null
                  ? DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: image == null
                ? const Center(
                    child: Icon(Icons.camera_alt, color: Colors.grey))
                : null,
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required initialValue,
    required onSaved,
    required validator,
    bool enabled = false,
    int maxLines = 1,
  }) {
    return TextFormField(
        enabled: enabled,
        maxLines: maxLines,
        initialValue: initialValue,
        onSaved: onSaved,
        validator: validator,
        decoration: _defaultInputDecoration.copyWith(labelText: label));
  }
}
