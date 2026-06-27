import 'package:flutter/foundation.dart';

import '../models/feed_post.dart';
import '../models/post.dart';
import '../models/post_statistic.dart';
import '../store/post_statistic_store.dart';

/// Keeps a local feed list in sync with a shared [PostStatisticStore].
class FeedListController extends ChangeNotifier {
  FeedListController(this.store) {
    store.addListener(_onStoreChanged);
  }

  final PostStatisticStore store;
  List<Post> _posts = [];

  List<Post> get posts => List.unmodifiable(_posts);

  /// Feed items paired with their shared statistics from [store].
  List<FeedPost> get items {
    final result = <FeedPost>[];
    for (final post in _posts) {
      final statistic = store.statisticFor(post.id);
      if (statistic != null) {
        result.add(FeedPost(post: post, statistic: statistic));
      }
    }
    return List.unmodifiable(result);
  }

  PostStatistic? statisticFor(int postId) => store.statisticFor(postId);

  /// Replaces the feed items and seeds missing statistics in the store.
  void setPosts(List<Post> posts) {
    _posts = List<Post>.from(posts);
    store.mergePosts(_posts, notify: false);
    notifyListeners();
  }

  /// Optimistically toggles the like state for [id] via [store].
  Future<void> likePost(
    int id, {
    LikePostAction? action,
    VoidCallback? onFailure,
  }) {
    return store.likePost(id, action: action, onFailure: onFailure);
  }

  void _onStoreChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    store.removeListener(_onStoreChanged);
    super.dispose();
  }
}
