import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../models/post_statistic.dart';

/// Performs the remote like/unlike action for a post [id].
typedef LikePostAction = Future<void> Function(int id);

/// Central store for post statistics shared across multiple feed lists.
class PostStatisticStore extends ChangeNotifier {
  final Map<int, PostStatistic> _statistics = {};

  /// Unmodifiable view of all known post statistics.
  Map<int, PostStatistic> get statistics => Map.unmodifiable(_statistics);

  PostStatistic? statisticFor(int id) => _statistics[id];

  /// Adds statistics for posts that are not yet tracked.
  ///
  /// Set [notify] to `false` when the caller will notify listeners separately.
  void mergePosts(List<Post> posts, {bool notify = true}) {
    var changed = false;

    for (final post in posts) {
      if (_statistics.containsKey(post.id)) {
        continue;
      }

      _statistics[post.id] = post.toStatistic();
      changed = true;
    }

    if (changed && notify) {
      notifyListeners();
    }
  }

  /// Optimistically toggles the like state for [id].
  ///
  /// When [action] is provided, runs it after the optimistic update and rolls
  /// back to the previous [PostStatistic] if it fails. [onFailure] is called
  /// after rollback.
  Future<void> likePost(
    int id, {
    LikePostAction? action,
    VoidCallback? onFailure,
  }) async {
    final current = _statistics[id];
    if (current == null) {
      return;
    }

    final previous = current;
    _statistics[id] = _toggledStatistic(current);
    notifyListeners();

    if (action == null) {
      return;
    }

    try {
      await action(id);
    } catch (_) {
      _statistics[id] = previous;
      notifyListeners();
      onFailure?.call();
    }
  }

  PostStatistic _toggledStatistic(PostStatistic current) {
    final liked = current.isLiked;
    final nextCount = liked
        ? (current.likesCount > 0 ? current.likesCount - 1 : 0)
        : current.likesCount + 1;
    return current.copyWith(
      isLiked: !liked,
      likesCount: nextCount,
    );
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
