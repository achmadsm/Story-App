import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/story.dart';
import '../provider/story_provider.dart';
import '../utils/result_state.dart';

class StoryDetailScreen extends StatefulWidget {
  const StoryDetailScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  String token = '';
  late Story story;

  @override
  void initState() {
    super.initState();
    getToken();
    Future.microtask(() => Provider.of<StoryProvider>(context, listen: false)
        .fetchDetailStory(widget.id));
  }

  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StoryProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == ResultState.hasData) {
            return Column(
              children: [
                Image.network(story.photoUrl),
              ],
            );
          } else if (state.state == ResultState.error) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text(''),
            );
          }
        },
      ),
    );
  }
}
