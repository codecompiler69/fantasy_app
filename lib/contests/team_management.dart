import 'package:flutter/material.dart';

import '../models/influencer.dart';

class TeamManagementScreen extends StatefulWidget {
  final List<Influencer> selectedInfluencers;

  const TeamManagementScreen({
    Key? key,
    required this.selectedInfluencers,
  }) : super(key: key);

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Management'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Team Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Team',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedInfluencers.length,
              itemBuilder: (context, index) {
                return buildInfluencerCard(widget.selectedInfluencers[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                
              },
              child: const Text('Save Changes '),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfluencerCard(Influencer influencer) {
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
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              widget.selectedInfluencers.remove(influencer);
            });
          },
        ),
      ),
    );
  }
}
