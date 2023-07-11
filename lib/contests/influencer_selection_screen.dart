import 'package:fantasyapp/contests/create_team.dart';
import 'package:flutter/material.dart';

import '../models/influencer.dart';
import '../widgets/app_text.dart';


class InfluencerScreen extends StatefulWidget {
  const InfluencerScreen({super.key});

  @override
  State<InfluencerScreen> createState() => _InfluencerScreenState();
}

class _InfluencerScreenState extends State<InfluencerScreen> {
  List<Influencer> filteredInfluencers = [];

  String searchText = '';
  String selectedSortBy = 'Follower Count';

  void pushToCreateTeam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTeam(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    filteredInfluencers = influencers;
  }

  void searchInfluencers(String? query) {
    setState(() {
      searchText = query ?? '';
      filteredInfluencers = influencers.where((influencer) {
        final nameLower = influencer.name.toLowerCase();
        final usernameLower = influencer.username.toLowerCase();
        final queryLower = searchText.toLowerCase();

        return nameLower.contains(queryLower) ||
            usernameLower.contains(queryLower);
      }).toList();
    });
  }

  void sortInfluencers(String? sortBy) {
    setState(() {
      selectedSortBy = sortBy ?? 'Follower Count';

      filteredInfluencers.sort((a, b) {
        switch (selectedSortBy) {
          case 'Follower Count':
            return b.followerCount.compareTo(a.followerCount);
          case 'Niche':
            return a.niche.compareTo(b.niche);
          case 'Engagement Rate':
            return b.engagementRate.compareTo(a.engagementRate);
          default:
            return 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Influencers'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pushToCreateTeam,
        label: const Text('Create Team'),
        icon: const Icon(Icons.edit),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: searchInfluencers,
              decoration: const InputDecoration(
                labelText: 'Search Influencers',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                const AppText(
                  text: 'Sort by : ',
                  size: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 15),
                DropdownButton<String>(
                  value: selectedSortBy,
                  onChanged: sortInfluencers,
                  items: ['Follower Count', 'Niche', 'Engagement Rate']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),//fekm
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredInfluencers.length,
              itemBuilder: (context, index) {
                final influencer = filteredInfluencers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(influencer.profilePicture),
                  ),
                  title: AppText(
                      text: influencer.name, fontWeight: FontWeight.bold),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(influencer.username),
                      Text(
                        'Followers: ${influencer.followerCount}',
                      ),
                    ],
                  ),
                  trailing: AppText(
                    text: 'Engagement Rate: ${influencer.engagementRate}%',
                    size: 13,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
