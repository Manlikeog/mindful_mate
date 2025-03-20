import 'package:flutter/material.dart';
import 'package:mindful_mate/screens/chanllenges/chanllenge_screen.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: palette.primaryColor,
          unselectedLabelColor: palette.textColor.withOpacity(0.6),
          tabs: const [
            Tab(text: 'Challenges'),
            Tab(text: 'Relaxation'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ChallengesScreen(),
              RelaxationScreen(),
            ],
          ),
        ),
      ],
    );
  }
}