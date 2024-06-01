import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Convert path to File
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: _getImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null ? const Icon(Icons.person) : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 140,
                    child: IconButton(
                      onPressed: _getImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),

              const Divider(),

              // Profile Details
              const Text(
                'PROFILE DETAILS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Name
              const Row(
                children: [
                  Text(
                    'Name : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text('Minimal'),
                ],
              ),
              const SizedBox(height: 20),

              // Email Id
              const Row(
                children: [
                  Text(
                    'Email Id : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text('minimal@gmail.com'),
                ],
              ),
              const SizedBox(height: 20),

              // Phone No.
              const Row(
                children: [
                  Text(
                    'Phone No. : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text('738291465'),
                ],
              ),
              const SizedBox(height: 20),

                // Password
              const Row(
                children: [
                  Text(
                    'Password : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text('1234567890'),
                ],
              ),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
