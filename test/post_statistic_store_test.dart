import 'package:flutter_test/flutter_test.dart';
import 'package:social_feed_kit/social_feed_kit.dart';

void main() {
  group('PostStatisticStore', () {
    late PostStatisticStore store;

    setUp(() {
      store = PostStatisticStore();
    });

    test('mergePosts seeds missing statistics', () {
      store.mergePosts([
        const Post(id: 1, title: 'A', likesCount: 2, commentsCount: 1),
      ]);

      expect(store.statisticFor(1)?.likesCount, 2);
      expect(store.statisticFor(1)?.commentsCount, 1);
    });

    test('likePost toggles optimistically', () {
      store.mergePosts([
        const Post(id: 1, title: 'A', likesCount: 2),
      ]);

      store.likePost(1);

      expect(store.statisticFor(1)?.isLiked, isTrue);
      expect(store.statisticFor(1)?.likesCount, 3);

      store.likePost(1);

      expect(store.statisticFor(1)?.isLiked, isFalse);
      expect(store.statisticFor(1)?.likesCount, 2);
    });

    test('updateComments changes count', () {
      store.mergePosts([
        const Post(id: 1, title: 'A', commentsCount: 0),
      ]);

      store.updateComments(1, 4);

      expect(store.statisticFor(1)?.commentsCount, 4);
    });
  });

  group('FeedListController', () {
    test('notifies when store changes', () {
      final store = PostStatisticStore();
      final controller = FeedListController(store);
      var notifications = 0;

      controller.addListener(() => notifications++);

      controller.setPosts([
        const Post(id: 1, title: 'A', likesCount: 1),
      ]);
      final afterSetPosts = notifications;

      store.likePost(1);

      expect(afterSetPosts, greaterThan(0));
      expect(notifications, greaterThan(afterSetPosts));
      expect(controller.statisticFor(1)?.likesCount, 2);

      controller.dispose();
    });
  });
}
