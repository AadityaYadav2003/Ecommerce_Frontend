import 'dart:convert';
import 'dart:io';
import 'package:ecommerce/models/profile.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
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

  Future<Profile?> _fetchProfileDetails(String email) async {
    final response = await http.post(
      Uri.parse('https://ecommercebackend-x2kr.onrender.com/user/profile'),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> rawData = jsonDecode(response.body)['result'][0];
      if (rawData.isNotEmpty) {
        return Profile.fromJson(rawData[0]);
      } else {
        throw Exception('No profile data found');
      }
    } else {
      throw Exception(
          'Failed to fetch profile details. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: FutureBuilder<Profile?>(
        future: _fetchProfileDetails(userProvider.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No profile data found.'));
          } else {
            final profile = snapshot.data!;
            return Padding(
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
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : (profile.image != null
                                    ? NetworkImage(
                                        'http://ecommerce.raviva.in/categoryimage/${profile.image!}')
                                    : null) as ImageProvider?,
                            child: _image == null && profile.image == null
                                ? const Icon(Icons.person)
                                : null,
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
                    const Text(
                      'PROFILE DETAILS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),

                    // Username
                    Row(
                      children: [
                        const Text(
                          'Name : ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(profile.username ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Email Id
                    Row(
                      children: [
                        const Text(
                          'Email Id : ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(profile.email ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Phone No.
                    Row(
                      children: [
                        const Text(
                          'Phone No. : ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(profile.mobile ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
