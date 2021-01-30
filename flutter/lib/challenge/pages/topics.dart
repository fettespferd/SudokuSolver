import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smusy_v2/app/module.dart';
import 'package:smusy_v2/content/module.dart';

class TopicsPage extends StatelessWidget {
  static const _horizontalPadding = 32.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA800), Color(0xFFEDBA05)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildSectionHeader(
                  context, context.s.challenge_topics_suggested),
              SliverToBoxAdapter(
                child: _buildHorizontalSection(
                  context,
                  [
                    _TopicCard(Id<Topic>('1XJAVmxYcgvk59C1Mp4W')),
                    _TopicCard(Id<Topic>('7xBVm90td3qbRvrh34Fn')),
                    _TopicCard(Id<Topic>('CMEZtPGmt3rELXVXepDD')),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildSectionHeader(context, context.s.challenge_topics_trending),
              SliverToBoxAdapter(
                child: _buildHorizontalSection(
                  context,
                  [
                    _TopicCard(Id<Topic>('voabK6m4cSkSr876HH86')),
                    _TopicCard(Id<Topic>('mSketzgGMNXUHMmh3TjS')),
                    _TopicCard(Id<Topic>('dCQtvT1fKy3bW3acbBv5')),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16)),
              _buildSectionHeader(context, context.s.challenge_topics_all),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                  vertical: 16,
                ),
                sliver: _buildAllSection(context),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: Text(title, style: context.textTheme.headline5),
      ),
    );
  }

  Widget _buildHorizontalSection(BuildContext context, List<Widget> children) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: 16,
        ),
        itemBuilder: (context, index) => children[index],
        itemCount: children.length,
        separatorBuilder: (context, _) => SizedBox(width: 16),
      ),
    );
  }

  Widget _buildAllSection(BuildContext context) {
    return StreamBuilder<List<Id<Topic>>>(
      stream: Topic.sortedByTitle(context.locale),
      builder: (context, snapshot) {
        if (snapshot.hasNoData) {
          return SliverToBoxAdapter(
            child: Center(
              child: snapshot.hasError
                  ? Text('Es ist ein Fehler aufgetreten:\n${snapshot.error}')
                  : CircularProgressIndicator(),
            ),
          );
        }

        final topicIds = snapshot.data;
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _TopicCard(topicIds[index]),
            childCount: topicIds.length,
          ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 256,
            childAspectRatio: _TopicCard.aspectRatio,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
        );
      },
    );
  }
}

class _TopicCard extends StatelessWidget {
  _TopicCard(this.topicId)
      : assert(topicId != null),
        super(key: ValueKey(topicId));

  static const aspectRatio = 153 / 113;

  final Id<Topic> topicId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Topic>(
      stream: Topic.collection
          .doc(topicId.value)
          .snapshots()
          .map((snapshot) => Topic.fromJson(snapshot.data())),
      builder: (context, snapshot) {
        final topic = snapshot.data;
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: InkWell(
              onTap: () =>
                  context.navigator.pushNamed('/challenges/topics/$topicId'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildPreviewImage()),
                  Expanded(child: _buildText(context, topic)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviewImage() {
    return FutureBuilder<String>(
      future: Topic.getPreviewDownloadUrl(topicId),
      builder: (context, snapshot) {
        final url = snapshot.data;
        if (url == null) return SizedBox();
        return SvgPicture.network(url, fit: BoxFit.cover);
      },
    );
  }

  Widget _buildText(BuildContext context, Topic topic) {
    const color = Colors.white;

    return ColoredBox(
      color:
          topic?.color ?? context.theme.backgroundColor.mediumEmphasisOnColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: FancyText(
                topic?.title?.getValue(context),
                maxLines: 1,
                estimatedWidth: 96,
                style: context.textTheme.subtitle1.copyWith(color: color),
              ),
            ),
            SizedBox(width: 16),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}
