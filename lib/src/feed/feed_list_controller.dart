import 'package:flutter/foundation.dart';

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

  PostStatistic? statisticFor(int postId) => store.statisticFor(postId);

  /// Replaces the feed items and seeds missing statistics in the store.
  void setPosts(List<Post> posts) {
    _posts = List<Post>.from(posts);
    store.mergePosts(_posts);
    notifyListeners();
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
