import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../models/post_statistic.dart';

/// Central store for post statistics shared across multiple feed lists.
class PostStatisticStore extends ChangeNotifier {
  final Map<int, PostStatistic> _statistics = {};

  /// Unmodifiable view of all known post statistics.
  Map<int, PostStatistic> get statistics => Map.unmodifiable(_statistics);

  PostStatistic? statisticFor(int id) => _statistics[id];

  /// Adds statistics for posts that are not yet tracked.
  void mergePosts(List<Post> posts) {
    var changed = false;

    for (final post in posts) {
      if (_statistics.containsKey(post.id)) {
        continue;
      }

      _statistics[post.id] = post.toStatistic();
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  /// Optimistically toggles the like state for [id].
  void likePost(int id) {
    final current = _statistics[id];
    if (current == null) {
      return;
    }

    final liked = current.isLiked;
    final nextCount = liked
        ? (current.likesCount > 0 ? current.likesCount - 1 : 0)
        : current.likesCount + 1;
    _statistics[id] = current.copyWith(
      isLiked: !liked,
      likesCount: nextCount,
    );
    notifyListeners();
  }

  /// Updates the comment counter for [id].
  void updateComments(int id, int count) {
    final current = _statistics[id];
    if (current == null || current.commentsCount == count) {
      return;
    }

    _statistics[id] = current.copyWith(commentsCount: count);
    notifyListeners();
  }

  /// Replaces statistics for [id], for example after a server refresh.
  void upsertStatistic(PostStatistic statistic) {
    final current = _statistics[statistic.id];
    if (current == statistic) {
      return;
    }

    _statistics[statistic.id] = statistic;
    notifyListeners();
  }
}
