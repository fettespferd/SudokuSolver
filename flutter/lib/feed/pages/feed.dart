import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:smusy_v2/app/module.dart';
import 'package:smusy_v2/content/module.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  final _getContentsCallable =
      services.firebaseFunctions.httpsCallable('getContents');
  final _pagingController = PagingController<int, Id<Content>>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int offset) async {
    try {
      final firebaseResp = await _getContentsCallable
          .call<List<dynamic>>(<String, dynamic>{'offset': offset});
      final newIndices = firebaseResp.data
          .map((dynamic e) => Id<Content>(e as String))
          .toList();
      _pagingController.appendPage(newIndices, offset + newIndices.length);
    } catch (e, st) {
      logger.e('Error while retrieving content IDs.', e, st);
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('smusy.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.rootNavigator.pushNamed('/creation/camera'),
        child: Icon(Icons.add_outlined),
      ),
      body: CustomScrollView(
        scrollDirection: Axis.horizontal,
        physics: PageScrollPhysics(),
        slivers: [
          PagedSliverBuilder(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Id<Content>>(
              itemBuilder: (context, id, _) => _buildContent(id),
            ),
            loadingListingBuilder:
                (context, itemBuilder, itemCount, progressIndicatorBuilder) {
              return SliverFillViewport(
                delegate: AppendedSliverChildBuilderDelegate(
                  builder: itemBuilder,
                  childCount: itemCount,
                  appendixBuilder: progressIndicatorBuilder,
                ),
              );
            },
            errorListingBuilder:
                (context, itemBuilder, itemCount, errorIndicatorBuilder) {
              return SliverFillViewport(
                delegate: AppendedSliverChildBuilderDelegate(
                  builder: itemBuilder,
                  childCount: itemCount,
                  appendixBuilder: errorIndicatorBuilder,
                ),
              );
            },
            completedListingBuilder:
                (context, itemBuilder, itemCount, noMoreItemsIndicatorBuilder) {
              return SliverFillViewport(
                delegate: AppendedSliverChildBuilderDelegate(
                  builder: itemBuilder,
                  childCount: itemCount,
                  appendixBuilder: noMoreItemsIndicatorBuilder,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Id<Content> contentId) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ContentWidget(contentId),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Container(),
          ),
        ),
      ],
    );
  }
}

class InformationWidget extends StatelessWidget {
  const InformationWidget(this.jobId) : assert(jobId != null);
  final Id<Job> jobId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
      stream: Job.collection
          .doc(jobId.value)
          .snapshots()
          .map((snapshot) => Job.fromJson(snapshot.data())),
      builder: (context, snapshot) {
        if (snapshot.hasNoData) {
          return Center(
            child: snapshot.hasError
                ? Text(context.s.app_error_unknown(snapshot.error))
                : CircularProgressIndicator(),
          );
        }
        final job = snapshot.data;
        return Column(
          children: [
            ElevatedButton(
              autofocus: true,
              clipBehavior: Clip.antiAlias,
              onPressed: null,
              child: Text('${job.name}'),
            ),
            SizedBox(height: 50)
          ],
        );
      },
    );
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget(this.contentId) : assert(contentId != null);

  final Id<Content> contentId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Content>(
      stream: Content.collection
          .doc(contentId.value)
          .snapshots()
          .map((snapshot) => Content.fromJson(snapshot.data())),
      builder: (context, snapshot) {
        if (snapshot.hasNoData) {
          return Center(
            child: snapshot.hasError
                ? Text(context.s.app_error_unknown(snapshot.error))
                : CircularProgressIndicator(),
          );
        }

        final content = snapshot.data;
        return Column(
          children: [
            ContentMediaWidget(contentId, content.media),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

class AppendedSliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  AppendedSliverChildBuilderDelegate({
    @required IndexedWidgetBuilder builder,
    @required int childCount,
    WidgetBuilder appendixBuilder,
  })  : assert(builder != null),
        assert(childCount != null),
        super(
          appendixBuilder == null
              ? builder
              : (context, index) {
                  if (index == childCount) return appendixBuilder(context);
                  return builder(context, index);
                },
          childCount: appendixBuilder == null ? childCount : childCount + 1,
        );
}
