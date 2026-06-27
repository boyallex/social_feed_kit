# social_feed_kit

Minimal Flutter SDK for optimistic likes and shared post statistics across multiple feed lists.

## Features

- **PostStatistic** — shared counters and like state (`id`, `likesCount`, `commentsCount`, `isLiked`)
- **PostStatisticStore** — `ChangeNotifier` with `Map<int, PostStatistic>`, optimistic `likePost`, `updateComments`, and `mergePosts`
- **FeedListController** — keeps a feed list in sync when the store changes; exposes [FeedPost] items
- **PostCard** — simple card with title, like button, and comment count

## Quick start

```dart
import 'package:social_feed_kit/social_feed_kit.dart';

final store = PostStatisticStore();
final globalFeed = FeedListController(store);
final personalFeed = FeedListController(store);

globalFeed.setPosts([
  Post(id: 1, title: 'Hello', likesCount: 3, commentsCount: 1),
]);

// Local-only optimistic toggle:
await store.likePost(1);

// With a remote action and rollback on failure:
await store.likePost(
  1,
  action: (id) => api.toggleLike(id),
  onFailure: () => showSnackBar('Like failed'),
);
```

Wrap UI with `ListenableBuilder` on `FeedListController` and render `PostCard` from `controller.items`:

```dart
ListenableBuilder(
  listenable: globalFeed,
  builder: (context, _) {
    return ListView.builder(
      itemCount: globalFeed.items.length,
      itemBuilder: (context, index) {
        final item = globalFeed.items[index];
        return PostCard(
          post: item.post,
          statistic: item.statistic,
          onLike: () => globalFeed.likePost(item.post.id),
        );
      },
    );
  },
);
```

