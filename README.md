# social_feed_kit

Minimal Flutter SDK for optimistic likes and shared post statistics across multiple feed lists.

## Features

- **PostStatistic** — shared counters and like state (`id`, `likesCount`, `commentsCount`, `isLiked`)
- **PostStatisticStore** — `ChangeNotifier` with `Map<int, PostStatistic>`, optimistic `likePost`, `updateComments`, and `mergePosts`
- **FeedListController** — keeps a feed list in sync when the store changes
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

store.likePost(1); // updates every list listening to the store
```

Wrap UI with `ListenableBuilder` (or `AnimatedBuilder`) on `store` or `FeedListController` and render `PostCard` widgets.

## Example

Run the bundled example app with two tabs that share one `PostStatisticStore`:

```bash
cd example
flutter run
```

## License

MIT — see [LICENSE](LICENSE).
