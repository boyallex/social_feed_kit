import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/post_statistic.dart';

/// Simple feed card with optimistic like interaction.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.statistic,
    required this.onLike,
    this.onCommentTap,
  });

  final Post post;
  final PostStatistic statistic;
  final VoidCallback onLike;
  final VoidCallback? onCommentTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: onLike,
                  icon: Icon(
                    statistic.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: statistic.isLiked ? Colors.red : null,
                  ),
                  tooltip: statistic.isLiked ? 'Unlike' : 'Like',
                ),
                Text('${statistic.likesCount}'),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: onCommentTap,
                  icon: const Icon(Icons.comment_outlined),
                  tooltip: 'Comments',
                ),
                Text('${statistic.commentsCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
