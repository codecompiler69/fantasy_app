import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasyapp/widgets/app_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime? selectedDate;
  final TextEditingController _usernameController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = '';
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUser.email);

      final userData = await userDoc.get();

      setState(() {
        _usernameController.text = userData['username'] ?? '';
        selectedDate = (userData['dateOfBirth'] as Timestamp?)?.toDate();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> updateProfile() async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUser.email);

      await userDoc.update({
        'username': _usernameController.text,
        'dateOfBirth': selectedDate,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      setState(() {
        isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (isEditing)
              IconButton(
                onPressed: updateProfile,
                icon: const Icon(Icons.save),
              )
            else
              IconButton(
                onPressed: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                icon: const Icon(Icons.edit),
              )
          ],
          backgroundColor: const Color.fromARGB(255, 176, 144, 229),
          title: const Text(
            'My Profile',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          leading: const Icon(Icons.arrow_back_sharp),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.exists) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              _usernameController.text = userData['username'] ?? '';

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Container(
                          height: 90,
                          width: 90,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Icon(
                              Icons.person,
                              size: 100,
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Column(
                          children: [
                            Text(
                              userData['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                              textScaleFactor: 1.25,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Personal Information',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 17),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text(
                        'Username',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      subtitle: isEditing
                          ? TextField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              controller: _usernameController,
                              style: const TextStyle(fontSize: 18),
                            )
                          : Text(
                              userData['username'],
                              style: const TextStyle(fontSize: 18),
                            ),
                    ),
                    const Divider(
                      color: Colors.black,
                      indent: 40,
                      endIndent: 40,
                      thickness: 0.6,
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text(
                        'Email',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      subtitle: Text(
                        userData['email'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      indent: 40,
                      endIndent: 40,
                      thickness: 0.6,
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_android_outlined),
                      title: const Text(
                        'Phone number',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      subtitle: Text(
                        userData['phoneNo'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      indent: 40,
                      endIndent: 40,
                      thickness: 0.6,
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: const Text(
                        'Date Of Birth',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      subtitle: GestureDetector(
                        onTap: isEditing ? () => _selectDate(context) : null,
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: selectedDate != null
                                ? selectedDate.toString().substring(0, 10)
                                : 'Select date',
                            hintStyle: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: AppText(
                  text: 'Error${snapshot.error}',
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
