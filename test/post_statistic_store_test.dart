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

    test('likePost toggles optimistically', () async {
      store.mergePosts([
        const Post(id: 1, title: 'A', likesCount: 2),
      ]);

      await store.likePost(1);

      expect(store.statisticFor(1)?.isLiked, isTrue);
      expect(store.statisticFor(1)?.likesCount, 3);

      await store.likePost(1);

      expect(store.statisticFor(1)?.isLiked, isFalse);
      expect(store.statisticFor(1)?.likesCount, 2);
    });

    test('likePost rolls back when action fails', () async {
      store.mergePosts([
        const Post(id: 1, title: 'A', likesCount: 2),
      ]);

      var failureCalled = false;
      await store.likePost(
        1,
        action: (_) => Future<void>.error(Exception('network')),
        onFailure: () => failureCalled = true,
      );

      expect(store.statisticFor(1)?.isLiked, isFalse);
      expect(store.statisticFor(1)?.likesCount, 2);
      expect(failureCalled, isTrue);
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
    test('notifies when store changes', () async {
      final store = PostStatisticStore();
      final controller = FeedListController(store);
      var notifications = 0;

      controller.addListener(() => notifications++);

      controller.setPosts([
        const Post(id: 1, title: 'A', likesCount: 1),
      ]);
      final afterSetPosts = notifications;

      await store.likePost(1);

      expect(afterSetPosts, 1);
      expect(notifications, 2);
      expect(controller.statisticFor(1)?.likesCount, 2);

      controller.dispose();
    });

    test('items pairs posts with store statistics', () {
      final store = PostStatisticStore();
      final controller = FeedListController(store);

      controller.setPosts([
        const Post(id: 1, title: 'A', likesCount: 3, commentsCount: 1),
        const Post(id: 2, title: 'B', likesCount: 0),
      ]);

      expect(controller.items, hasLength(2));
      expect(controller.items.first.post.title, 'A');
      expect(controller.items.first.statistic.likesCount, 3);

      controller.dispose();
    });

    test('setPosts notifies listeners once', () {
      final store = PostStatisticStore();
      final controller = FeedListController(store);
      var notifications = 0;

      controller.addListener(() => notifications++);

      controller.setPosts([
        const Post(id: 1, title: 'A', likesCount: 1),
      ]);

      expect(notifications, 1);

      controller.dispose();
    });
  });
}
