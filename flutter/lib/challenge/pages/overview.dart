import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smusy_v2/app/module.dart';

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Theme(
        data: AppTheme.secondary(context.theme.brightness),
        child: Builder(
          builder: (context) => Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset('assets/images/challenge-bg.svg'),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    RankCard(),
                    SizedBox(height: 16),
                    Statistics(),
                    Spacer(),
                    PlayButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RankCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.primary(context.theme.brightness),
      child: Builder(
        builder: (context) {
          return Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: context.theme.cardColor,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/images/challenge-card-bg.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                _buildContent(context),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Text(
            context.s.challenge_overview_rankCard_current,
            style: context.textTheme.headline6,
          ),
          Text(
            context.s.challenge_overview_rankCard_rank,
            style: context.textTheme.headline4,
          ),
          SizedBox(height: 8),
          _buildCurrentRankCard(context),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentRankCard(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '7209',
              style: context.textTheme.headline3
                  .copyWith(color: Colors.green, fontWeight: FontWeight.w600),
            ),
            Icon(
              Icons.trending_up,
              size: 36,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildEntry(context, context.s.challenge_overview_statistics_level, 20),
        Spacer(),
        _buildEntry(
          context,
          context.s.challenge_overview_statistics_points,
          12345,
        ),
        Spacer(),
        _buildEntry(
          context,
          context.s.challenge_overview_statistics_correct,
          '68.2 %',
        ),
      ],
    );
  }

  Widget _buildEntry(BuildContext context, String title, dynamic content) {
    return Column(
      children: [
        FancyText(
          title,
          style: context.textTheme.subtitle1,
          emphasis: TextEmphasis.medium,
        ),
        FancyText(
          content.toString(),
          style:
              context.textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class PlayButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildButton(
          context,
          icon: Icons.videogame_asset,
          title: context.s.challenge_overview_mode_quickplay,
          onTap: () => context.rootNavigator.pushNamed('/challenges/quickplay'),
          backgroundColors: [Color(0xFF0094D4), Color(0xFF00B2FF)],
        ),
        SizedBox(height: 8),
        _buildButton(
          context,
          icon: Icons.school,
          title: context.s.challenge_overview_mode_schoolDuel,
          onTap: () =>
              context.rootNavigator.pushNamed('/challenges/schoolDuel'),
          backgroundColors: [Color(0xFF18AC00), Color(0xFF41CB00)],
        ),
        SizedBox(height: 8),
        _buildButton(
          context,
          icon: Icons.category,
          title: context.s.challenge_overview_mode_topics,
          onTap: () => context.navigator.pushNamed('/challenges/topics'),
          backgroundColors: [Color(0xFFFFA800), Color(0xFFEDBA05)],
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    @required IconData icon,
    @required String title,
    @required VoidCallback onTap,
    @required List<Color> backgroundColors,
  }) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: Ink(
        decoration:
            BoxDecoration(gradient: LinearGradient(colors: backgroundColors)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.textTheme.headline5.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Icon(icon, size: 48, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
