import 'package:fantasyapp/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateContest extends StatefulWidget {
  const CreateContest({super.key});

  @override
  State<CreateContest> createState() => _CreateContestState();
}

class _CreateContestState extends State<CreateContest> {
  final TextEditingController contestName = TextEditingController();
  final TextEditingController prizePool = TextEditingController();
  final TextEditingController entryFee = TextEditingController();
  final TextEditingController category = TextEditingController();

  String dropdownValue = 'Live';

  CollectionReference contestsCollection =
      FirebaseFirestore.instance.collection('contests');

  Future<void> addContest() {
    String contestId = contestsCollection.doc().id;

    // Prepare the contest data
    Map<String, dynamic> contestData = {
      'id': contestId,
      'name': contestName.text,
      'prizePool': prizePool.text,
      'entryFee': entryFee.text,
      'category': category.text,
      'status': dropdownValue,
    };

    // Add the contest to Firestore
    return contestsCollection.doc(contestId).set(contestData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: 'Create a new Contest'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              TextFormField(
                controller: contestName,
                decoration: const InputDecoration(
                  label: AppText(text: 'Contest Name'),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: prizePool,
                decoration: const InputDecoration(
                  label: AppText(text: 'Prize Pool'),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: entryFee,
                decoration: const InputDecoration(
                  label: AppText(text: 'Entry Fee'),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: category,
                decoration: const InputDecoration(
                  label: AppText(text: 'Category'),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownButtonFormField<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['Live', 'Upcoming', 'Completed']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 15,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  addContest().then((_) {
                    contestName.clear();
                    prizePool.clear();
                    entryFee.clear();
                    category.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Contest added successfully')),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add contest: $error')),
                    );
                  });
                },
                icon: const Icon(Icons.add),
                label: const AppText(text: 'Add'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
