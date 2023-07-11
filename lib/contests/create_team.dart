import 'package:fantasyapp/contests/team_management.dart';
import 'package:flutter/material.dart';

import '../models/influencer.dart';
import '../widgets/app_text.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({Key? key}) : super(key: key);

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  List<Influencer> selectedInfluencers = [];
  double availableCredits = 10.0;

  Widget buildInfluencerCard(Influencer influencer) {
    bool isSelected = selectedInfluencers.contains(influencer);

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
        trailing:
            Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank),
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedInfluencers.remove(influencer);
              availableCredits += influencer.creditPoints;
            } else {
              if (availableCredits >= influencer.creditPoints) {
                selectedInfluencers.add(influencer);
                availableCredits -= influencer.creditPoints;
              } else {
                
              }
            }
          });
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
            selectedInfluencers: selectedInfluencers,
          ),
        ),
      );
    } else {
     
    }
  }

  void updateCreditPoints() {
    setState(() {
      for (var influencer in selectedInfluencers) {
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
            child: ListView.builder(
              itemCount: influencers.length,
              itemBuilder: (context, index) {
                return buildInfluencerCard(influencers[index]);
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
                  label: Text(influencer.username),
                  deleteIcon: const Icon(Icons.cancel),
                  onDeleted: () {
                    setState(() {
                      selectedInfluencers.remove(influencer);
                      availableCredits += influencer.creditPoints;
                    });
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
