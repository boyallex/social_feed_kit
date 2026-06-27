import 'post.dart';
import 'post_statistic.dart';

/// A feed item paired with its shared [PostStatistic] from the store.
class FeedPost {
  const FeedPost({
    required this.post,
    required this.statistic,
  });

  final Post post;
  final PostStatistic statistic;
}
