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
    _currentIndex = 0 ;
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
            SliverAppBar(
              title: Text(widget.title),
              pinned: true,
              floating: true,
              snap: false,
              forceElevated: innerBoxIsScrolled,
             /* bottom: TabBar(
                isScrollable: true,
                tabs: const <Tab>[
                  Tab(text: "Page 1"),
                  Tab(text: "Page 2"),
                  Tab(text: "Page 1"),
                  Tab(text: "Page 2"),
                  Tab(text: "Page 1"),
                  Tab(text: "Page 2"),
                  Tab(text: "Page 1"),
                  Tab(text: "Page 2"),
                  Tab(text: "Page 1"),
                  Tab(text: "Page 2"),
                ],
                controller: _tabController,
              ),*/
            ),
            SliverToBoxAdapter(
              child: TabBar(
                tabs: const <Tab>[
                  Tab(text: "Page 1"),
                  Tab(text: "Page 2"),
                ],
                controller: _tabController1,
              ),
            )
          ];
        },
        body:
        NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Text('test'),)
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
