/// Shared counters and like state for a single post.
class PostStatistic {
  const PostStatistic({
    required this.id,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
  });

  final int id;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  PostStatistic copyWith({
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
  }) {
    return PostStatistic(
      id: id,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PostStatistic &&
        other.id == id &&
        other.likesCount == likesCount &&
        other.commentsCount == commentsCount &&
        other.isLiked == isLiked;
  }

  @override
  int get hashCode => Object.hash(id, likesCount, commentsCount, isLiked);
}
