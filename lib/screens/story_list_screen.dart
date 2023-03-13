import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/provider/story_provider.dart';

import '../provider/auth_provider.dart';
import '../utils/result_state.dart';

class StoryListScreen extends StatelessWidget {
  const StoryListScreen({
    Key? key,
    required this.onTapped,
    required this.onLogout,
  }) : super(key: key);

  final Function(String) onTapped;
  final Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final authRead = context.read<AuthProvider>();
              final result = await authRead.logout();
              if (result) onLogout();
            },
            icon: authWatch.isLoadingLogout
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(Icons.logout),
          )
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == ResultState.hasData) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              itemCount: state.storiesResponse.story.length,
              separatorBuilder: (_, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                var story = state.storiesResponse.story[index];
                return Text(story.id);
              },
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
