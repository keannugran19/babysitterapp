import 'package:babysitterapp/pages/location/location_page.dart';
import 'package:babysitterapp/pages/requirement/requirement_page.dart';
import 'package:babysitterapp/services/current_user_service.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../models/user_model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // call firestore service
  CurrentUserService firestoreService = CurrentUserService();
  // get data from firestore using the model
  UserModel? currentUser;
  // location variable for Geopointing
  double longitude = 0;
  double latitude = 0;
  // selected user gender
  String? selectedGender;
  // form key
  final formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  File? _profileImage;

  // load user data
  Future<void> _loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
      selectedGender = currentUser?.gender;
    });
  }

  // initiate load
  @override
  void initState() {
    super.initState();
    _loadUserData();
    selectedGender = currentUser?.gender;
  }

  // save new data when save is clicked
  Future<void> _saveUserData() async {
    if (formKey.currentState!.validate() && currentUser != null) {
      formKey.currentState!.save();

      try {
        await firestoreService.saveUserData(currentUser!);

        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  // pick image for profile
  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // divider
  Padding get _buildDivider => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Divider(
          color: secondaryColor,
        ),
      );

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: primaryColor,
        actions: [
          TextButton(
            onPressed: _isEditing ? _saveUserData : _toggleEditMode,
            child: Text(
              _isEditing ? 'Save' : 'Edit',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : AssetImage(currentUser!.img!) as ImageProvider,
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: const CircleAvatar(
                                radius: 18,
                                child: Icon(Icons.edit,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // role
                    _buildProfileField(
                      label: 'Role',
                      initialValue: currentUser!.role,
                      onSaved: (value) => currentUser!.role = value,
                      validator: null,
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    // add logic to differentiate current users
                    currentUser != null &&
                            currentUser?.role.toLowerCase() != 'babysitter'
                        ?
                        // if current user is a parent, they will get this form field
                        _buildAgeInputField(
                            label: "Child Age",
                            initialValue: currentUser!.childAge,
                            onSaved: (value) => currentUser!.childAge = value,
                            validator: null,
                          )
                        :
                        // if current user is a babysitter, they will get this form field

                        _buildRateField(
                            enabled: _isEditing,
                            label: "Rate",
                            initialValue: currentUser!.rate.toString(),
                            onSaved: (value) {
                              // Safely parse the value to double
                              if (value != null && value.isNotEmpty) {
                                currentUser!.rate = double.tryParse(value);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please set your rate';
                              }
                              final rate = double.tryParse(value);
                              if (rate == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),

                    // divider
                    _buildDivider,

                    _buildProfileField(
                      label: 'Full Name',
                      initialValue: currentUser!.name,
                      onSaved: (value) => currentUser!.name = value,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter a name' : null,
                      enabled: _isEditing,
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

                    Row(
                      children: [
                        // Profile field takes majority of the space
                        Expanded(
                          child: _buildProfileField(
                              label: "Address",
                              initialValue: currentUser!.address,
                              onSaved: (value) => currentUser!.address = value,
                              validator: (value) => value == null
                                  ? 'Please set your address'
                                  : null,
                              enabled: _isEditing),
                        ),
                        const SizedBox(
                            width:
                                8), // Add spacing between the field and the button
                        // Location button with intrinsic size
                        _buildLocationButton(),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // select gender
                    _buildGenderDropdown(),
                    const SizedBox(height: 20),
                    // select date of birth
                    _buildDatePickerField(
                      label: 'Date of Birth',
                      initialValue: currentUser!.age,
                      onDateChanged: (value) => currentUser?.age = value,
                      validator: (value) =>
                          value == null ? 'Please select a date' : null,
                    ),
                    const SizedBox(height: 20),
                    // phone number
                    _buildPhoneNumberField(),
                    const SizedBox(height: 20),
                    _buildProfileField(
                      initialValue: currentUser!.information,
                      onSaved: (value) => currentUser!.information = value,
                      validator: null,
                      label: 'Bio',
                      enabled: _isEditing,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  //* Widgets used for building

  Widget _buildVerifyAccount() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.black),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "You need to verify your account.",
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Reqpage(),
                ),
              );
            },
            child: const Text(
              "Verify Now",
              style: TextStyle(color: primaryColor),
            ),
          ),
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

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: _defaultInputDecoration.copyWith(
        enabled: _isEditing,
        labelText: 'Gender',
      ),
      value: selectedGender,
      items: const [
        DropdownMenuItem(
          value: 'Select Gender',
          child: Text('Select Gender'),
        ),
        DropdownMenuItem(
          value: 'Male',
          child: Text('Male'),
        ),
        DropdownMenuItem(
          value: 'Female',
          child: Text('Female'),
        ),
      ],
      onChanged: _isEditing
          ? (value) {
              if (value != 'Select Gender') {
                setState(() => selectedGender = value);
              }
            }
          : null,
      validator: (value) => value == null || value == 'Select Gender'
          ? 'Please select a gender'
          : null,
      onSaved: (value) {
        if (value != null && value != 'Select Gender') {
          currentUser?.gender = value;
        }
      },
    );
  }

  Widget _buildLocationButton() {
    return IconButton(
      icon: const Icon(
        Icons.edit_location_alt_outlined,
        size: 30,
      ),
      onPressed: _isEditing
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Location()),
              );
            }
          : null, // Disables the button when _isEditing is false
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      enabled: _isEditing,
      initialValue: currentUser!.phone,
      keyboardType: TextInputType.number,
      maxLength: 11,
      validator: _validatePhoneNumber,
      onSaved: (value) => currentUser!.phone = value!,
      decoration: _defaultInputDecoration.copyWith(
        label: const Text("Phone Number"),
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
      return 'Phone number must be 11 digits';
    }
    return null;
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime? initialValue,
    required void Function(DateTime?)
        onDateChanged, // New callback for date selection
    required String? Function(String?) validator,
  }) {
    final TextEditingController dateController = TextEditingController(
      text: initialValue != null
          ? DateFormat('yyyy-MM-dd').format(initialValue)
          : '',
    );

    return TextFormField(
      controller: dateController,
      enabled: _isEditing,
      readOnly: true,
      onTap: _isEditing
          ? () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: initialValue ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  dateController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                });
                // Update the date immediately in the user model
                onDateChanged(pickedDate);
              }
            }
          : null,
      validator: validator,
      decoration: _defaultInputDecoration.copyWith(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildAgeInputField({
    required String label,
    required String? initialValue,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    String dropdownValue = "years"; // Default dropdown value
    TextEditingController ageController = TextEditingController();

    if (initialValue != null && initialValue.isNotEmpty) {
      // Split the initialValue into age and unit if it exists
      final parts = initialValue.split(" ");
      if (parts.length == 2) {
        ageController.text = parts[0];
        dropdownValue = parts[1];
      }
    }

    return FormField<String>(
      initialValue: initialValue,
      validator: validator,
      onSaved: (value) {
        final concatenatedValue = "${ageController.text} $dropdownValue";
        onSaved(concatenatedValue);
      },
      builder: (field) {
        return TextFormField(
          enabled: _isEditing,
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: _defaultInputDecoration.copyWith(
            labelText: label,
            errorText: field.errorText,
            suffixIcon: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: dropdownValue,
                items: const [
                  DropdownMenuItem(value: "months", child: Text("months")),
                  DropdownMenuItem(value: "years", child: Text("years")),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    dropdownValue = newValue;
                    field.didChange("${ageController.text} $dropdownValue");
                  }
                },
              ),
            ),
          ),
          onChanged: (value) {
            field.didChange("${value.isNotEmpty ? value : ""} $dropdownValue");
          },
        );
      },
    );
  }

  Widget _buildRateField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    bool enabled = false,
  }) {
    return TextFormField(
      enabled: enabled,
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
      ],
      decoration: _defaultInputDecoration.copyWith(
        labelText: label,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 15, right: 10, top: 12),
          child: Text(
            'PHP',
            style: TextStyle(
                color: secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        suffixText: '/hr',
        suffixStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(textBaseline: TextBaseline.alphabetic),
    );
  }
}
