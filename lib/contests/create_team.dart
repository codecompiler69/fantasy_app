import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/influencer.dart';
import '../widgets/app_text.dart';
import '../contests/team_management.dart';

class CreateTeam extends StatefulWidget {
  final Map<String, dynamic> contestData;
  const CreateTeam({Key? key, required this.contestData}) : super(key: key);

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  List<String> selectedInfluencers = [];
  double availableCredits = 10.0;

  Widget buildInfluencerCard(Influencer influencer) {
    bool isSelected = selectedInfluencers.contains(influencer.username);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          setState(() {
            selectedInfluencers.remove(influencer.username);
            availableCredits += influencer.creditPoints;
          });
        } else {
          if (availableCredits >= influencer.creditPoints) {
            setState(() {
              selectedInfluencers.add(influencer.username);
              availableCredits -= influencer.creditPoints;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("You don't have enough credits!"),
              ),
            );
          }
        }
      },
      child: Builder(
        builder: (context) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(influencer.profilePicture),
              ),
              title: Text(influencer.username),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Followers: ${influencer.followerCount}'),
                  Text('Engagement Rate: ${influencer.engagementRate}%'),
                  Text('Credit Value: ${influencer.creditPoints}'),
                ],
              ),
              trailing: Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              ),
            ),
          );
        },
      ),
    );
  }

  void moveToTeamManagement() {
    if (selectedInfluencers.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeamManagementScreen(
            contestData: widget.contestData,
            selectedInfluencers: selectedInfluencers,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have not selected any influencers'),
        ),
      );
    }
  }

  void updateCreditPoints() async {
    List<Influencer> influencers = [];

    final List<String> usernames = selectedInfluencers.toList();

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('influencers')
        .where('username', whereIn: usernames)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      influencers = querySnapshot.docs.map((doc) {
        final influencerData = doc.data() as Map<String, dynamic>;
        return Influencer(
          username: influencerData['username'] ?? '',
          profilePicture: influencerData['profilePicture'] ?? '',
          followerCount: influencerData['followerCount'] ?? 0,
          engagementRate: influencerData['engagementRate']?.toDouble() ?? 0.0,
          creditPoints: influencerData['creditPoints']?.toDouble() ?? 0.0,
          name: influencerData['name'] ?? '',
          niche: influencerData['niche'] ?? '',
        );
      }).toList();
    }

    setState(() {
      availableCredits = 10.0;

      for (var influencer in influencers) {
        availableCredits -= influencer.creditPoints;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 50, 0, 16),
            child: Text(
              'Create a Team',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 5),
            child: Text(
              'Available Credits: $availableCredits',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('influencers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: AppText(
                      text: 'Error: ${snapshot.error}',
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final influencerDocs = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: influencerDocs.length,
                  itemBuilder: (context, index) {
                    final influencerData =
                        influencerDocs[index].data() as Map<String, dynamic>;
                    final influencer = Influencer(
                      username: influencerData['username'],
                      profilePicture: influencerData['profilePicture'],
                      followerCount: influencerData['followerCount'],
                      engagementRate:
                          influencerData['engagementRate'].toDouble(),
                      creditPoints: influencerData['creditPoints'].toDouble(),
                      name: influencerData['name'],
                      niche: influencerData['niche'],
                    );

                    return buildInfluencerCard(influencer);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Selected Influencers:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              children: selectedInfluencers.map((influencer) {
                return Chip(
                  label: Text(influencer),
                  deleteIcon: const Icon(Icons.cancel),
                  onDeleted: () async {
                    final influencerDocument = await FirebaseFirestore.instance
                        .collection('influencers')
                        .where('username', isEqualTo: influencer)
                        .get();

                    if (influencerDocument.docs.isNotEmpty) {
                      final influencerData =
                          influencerDocument.docs.first.data();
                      final double influencerCreditPoints =
                          influencerData['creditPoints']?.toDouble() ?? 0.0;
                      setState(() {
                        selectedInfluencers.remove(influencer);
                        availableCredits += influencerCreditPoints;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: moveToTeamManagement,
              child: const AppText(
                text: 'Team Management',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
