import 'package:flutter/material.dart';
import 'package:social_feed_kit/social_feed_kit.dart';

void main() {
  final store = PostStatisticStore();
  final globalFeed = FeedListController(store);
  final personalFeed = FeedListController(store);

  globalFeed.setPosts(const [
    Post(id: 1, title: 'Launch day recap', likesCount: 12, commentsCount: 3),
    Post(id: 2, title: 'Design system update', likesCount: 5, commentsCount: 1),
    Post(id: 3, title: 'Weekly standup notes', likesCount: 2, commentsCount: 0),
  ]);

  personalFeed.setPosts(const [
    Post(id: 1, title: 'Launch day recap', likesCount: 12, commentsCount: 3),
    Post(id: 3, title: 'Weekly standup notes', likesCount: 2, commentsCount: 0),
  ]);

  runApp(
    SocialFeedExampleApp(
      store: store,
      globalFeed: globalFeed,
      personalFeed: personalFeed,
    ),
  );
}

class SocialFeedExampleApp extends StatelessWidget {
  const SocialFeedExampleApp({
    super.key,
    required this.store,
    required this.globalFeed,
    required this.personalFeed,
  });

  final PostStatisticStore store;
  final FeedListController globalFeed;
  final FeedListController personalFeed;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'social_feed_kit example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Shared feed statistics'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Global'),
                Tab(text: 'Personal'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FeedTab(controller: globalFeed, store: store),
              FeedTab(controller: personalFeed, store: store),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedTab extends StatelessWidget {
  const FeedTab({
    super.key,
    required this.controller,
    required this.store,
  });

  final FeedListController controller;
  final PostStatisticStore store;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller, store]),
      builder: (context, _) {
        final posts = controller.posts;

        if (posts.isEmpty) {
          return const Center(child: Text('No posts'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final statistic = store.statisticFor(post.id);

            if (statistic == null) {
              return const SizedBox.shrink();
            }

            return PostCard(
              post: post,
              statistic: statistic,
              onLike: () => store.likePost(post.id),
              onCommentTap: () {
                store.updateComments(post.id, statistic.commentsCount + 1);
              },
            );
          },
        );
      },
    );
  }
}
