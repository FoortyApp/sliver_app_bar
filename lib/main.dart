import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(key: UniqueKey(), title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  var _scrollController, _tabController, _tabController1, _pageController;
  late int _currentIndex;
  @override
  void initState() {
    _currentIndex = 0;
    _scrollController = ScrollController();
    _pageController = PageController(initialPage: _currentIndex);
    //_tabController = TabController(initialIndex: 0, vsync: this, length: 10);
    _tabController1 = TabController(initialIndex: _currentIndex, vsync: this, length: 2);
    super.initState();

    _tabController1.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _pageController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: PersistantHeader(title: 'My app'),
            ),
          ];
        },
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            _pageView(),
            _pageView(),
          ],
        ),
      ),
    );
  }

  _pageView() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Text('List Item $index'),
          ),
        );
      },
    );
  }
}

class PersistantHeader extends SliverPersistentHeaderDelegate {
  final double minTopBarHeight = 100;
  final double maxTopBarHeight = 200;
  final String title;
  final IconData? icon;

  PersistantHeader({
    required this.title,
    this.icon,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    var shrinkFactor = min(1, shrinkOffset / (maxExtent - minExtent));
    var vleft = MediaQuery.of(context).size.width;
    print(shrinkFactor);
    var topBar = Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        height: max(maxTopBarHeight * (1 - shrinkFactor * 0.7), minTopBarHeight),
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            )),
      ),
    );
    return Stack(
      fit: StackFit.loose,
      children: [
        topBar,
        Positioned(
          right: (vleft - (vleft * 0.8)) / 2 ,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            child: Container(
              alignment: Alignment.center,
              width: max(MediaQuery.of(context).size.width * 0.8 - shrinkOffset, minExtent - shrinkOffset),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 230;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
