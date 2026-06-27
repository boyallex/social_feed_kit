import 'package:flutter_test/flutter_test.dart';
import 'package:social_feed_kit/social_feed_kit.dart';
import 'package:social_feed_kit_example/main.dart';

void main() {
  testWidgets('Example app builds', (tester) async {
    final store = PostStatisticStore();
    final globalFeed = FeedListController(store);
    final personalFeed = FeedListController(store);

    await tester.pumpWidget(
      SocialFeedExampleApp(
        store: store,
        globalFeed: globalFeed,
        personalFeed: personalFeed,
      ),
    );

    expect(find.text('Shared feed statistics'), findsOneWidget);
  });
}
