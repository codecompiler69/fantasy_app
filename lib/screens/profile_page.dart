
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late DateTime selectedDate;
  TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  
  late TextEditingController _usernameController;
  bool _isEditingEnabled = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _usernameController.text = 'Initial Username'; 
  }

  @override
  void dispose() {
    dateController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditingEnabled = !_isEditingEnabled;
      if (!_isEditingEnabled) {
        
        String newUsername = _usernameController.text;
        print('New Username: $newUsername');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 176, 144, 229),
          title: const Text(
            'My Profile',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          leading: const Icon(Icons.arrow_back_sharp),
          actions: [const Icon(Icons.edit_note)],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
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
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: NetworkImage(
                          "https://pps.whatsapp.net/v/t61.24694-24/319929991_1197153464280348_9111461515577510123_n.jpg?ccb=11-4&oh=01_AdRxwpFyYkszPWgz2Fid74g2ECpLiy5rVeJHTzgTSwgm-g&oe=64B43776",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  const Column(
                    children: [
                      Text(
                        'Andrew Tate',
                        style: TextStyle(fontWeight: FontWeight.w800),
                        textScaleFactor: 1.25,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 40),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Personal Information',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.person_pin_circle),
                title: const Text(
                  'Username',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                subtitle: TextField(
                  style: const TextStyle(color: Colors.black),
                  enabled: _isEditingEnabled,
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter username',
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(_isEditingEnabled ? Icons.save : Icons.edit),
                  onPressed: _toggleEditing,
                ),
              ),
              const Divider(
                color: Colors.black,
                indent: 40,
                endIndent: 40,
                thickness: 0.6,
              ),
              const ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  'Email',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                subtitle: Text(
                  'email',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Divider(
                color: Colors.black,
                indent: 40,
                endIndent: 40,
                thickness: 0.6,
              ),
              const ListTile(
                leading: Icon(Icons.phone_android_outlined),
                title: Text(
                  'Phone number',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                subtitle: Text(
                  'phone no',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Divider(
                color: Colors.black,
                indent: 40,
                endIndent: 40,
                thickness: 0.6,
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text(
                  'Date Of Birth',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                subtitle: InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: TextFormField(
                    controller: dateController,
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: 'Select date',
                      hintStyle: TextStyle(fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
