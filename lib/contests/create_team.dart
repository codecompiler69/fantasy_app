import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Widget buildInfluencerCard(DocumentSnapshot document) {
    final influencerData = document.data() as Map<String, dynamic>;
    final String influencerId = document.id;

    bool isSelected = selectedInfluencers.contains(influencerId);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          setState(() {
            selectedInfluencers.remove(influencerId);
            availableCredits +=
                influencerData['creditPoints']?.toDouble() ?? 0.0;
          });
        } else {
          double influencerCreditPoints =
              influencerData['creditPoints']?.toDouble() ?? 0.0;
          if (availableCredits >= influencerCreditPoints) {
            setState(() {
              selectedInfluencers.add(influencerId);
              availableCredits -= influencerCreditPoints;
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
                backgroundImage: AssetImage(influencerData['profilePicture']),
              ),
              title: Text(influencerData['username']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Followers: ${influencerData['followerCount']}'),
                  Text('Engagement Rate: ${influencerData['engagementRate']}%'),
                  Text('Credit Value: ${influencerData['creditPoints']}'),
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
    List<String> selectedInfluencerIds = List<String>.from(selectedInfluencers);

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('influencers')
        .where(FieldPath.documentId, whereIn: selectedInfluencerIds)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final List<Influencer> influencers = querySnapshot.docs.map((doc) {
        final influencerData = doc.data() as Map<String, dynamic>;
        return Influencer(
          username: influencerData['username'] ?? '',
          profilePicture: 'assets/images/dummy.jpg',
          followerCount: influencerData['followerCount'] ?? 0,
          engagementRate: influencerData['engagementRate']?.toDouble() ?? 0.0,
          creditPoints: influencerData['creditPoints']?.toDouble() ?? 0.0,
          name: influencerData['name'] ?? '',
          niche: influencerData['niche'] ?? '',
          shareCount: influencerData['shareCount'],
          likesCount: influencerData['likesCount'],
          commentsCount: influencerData['commentsCount'],
        );
      }).toList();

      setState(() {
        availableCredits = 10.0;

        for (var influencer in influencers) {
          availableCredits -= influencer.creditPoints;
        }
      });
    }
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
                    return buildInfluencerCard(influencerDocs[index]);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: AppText(
              text: 'Selected Influencers',
              size: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              children: selectedInfluencers.map((influencerId) {
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('influencers')
                      .doc(influencerId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      // Handle errors or empty data
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error loading"),
                        ),
                      );
                    }

                    final influencerData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final String influencerUsername =
                        influencerData['username'] ?? '';

                    return Chip(
                      label: Text(influencerUsername),
                      deleteIcon: const Icon(Icons.cancel),
                      onDeleted: () async {
                        final double influencerCreditPoints =
                            influencerData['creditPoints']?.toDouble() ?? 0.0;
                        setState(() {
                          selectedInfluencers.remove(influencerId);
                          availableCredits += influencerCreditPoints;
                        });
                      },
                    );
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
