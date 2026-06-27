import 'post_statistic.dart';

/// Lightweight feed item used to seed [PostStatistic] entries in the store.
class Post {
  const Post({
    required this.id,
    required this.title,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
  });

  final int id;
  final String title;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  PostStatistic toStatistic() {
    return PostStatistic(
      id: id,
      likesCount: likesCount,
      commentsCount: commentsCount,
      isLiked: isLiked,
    );
  }
}
