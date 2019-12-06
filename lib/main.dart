import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: IPod(),
    );
  }
}

class IPod extends StatefulWidget {
  @override
  _IPodState createState() => _IPodState();
}

class _IPodState extends State<IPod> {
  final PageController _pageController = PageController(
    viewportFraction: 0.6,
  );

  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => currentPage = _pageController.page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            height: 350,
            color: Colors.black,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              itemBuilder: (context, int index) => SongCard(
                color: Colors.accents[index],
                currentIndex: index,
                currentPage: currentPage,
              ),
            ),
          ),
          Spacer(),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GestureDetector(
                  onPanUpdate: _panHandler,
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'MENU',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 35.0),
                        ),
                        Container(
                          child: Material(
                            child: IconButton(
                              icon: Icon(Icons.fast_forward),
                              iconSize: 40.0,
                              onPressed: () => _pageController.animateToPage(
                                (_pageController.page + 1).toInt(),
                                duration: Duration(seconds: 1),
                                curve: Curves.easeIn,
                              ),
                            ),
                          ),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 30.0),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _panHandler(DragUpdateDetails details) {
    double radius = 150.0;

    // location of the wheel
    bool onTop = details.localPosition.dy <= radius;
    bool onLeft = details.localPosition.dx <= radius;
    bool onBottom = !onTop;
    bool onRight = !onLeft;

    // pan moves
    bool panUp = details.delta.dy <= 0.0;
    bool panLeft = details.delta.dx <= 0.0;
    bool panDown = !panUp;
    bool panRight = !panLeft;

    // abs change on axis
    double yChange = details.delta.dy.abs();
    double xChange = details.delta.dx.abs();

    // directional change of the wheel
    double verticalRotation =
        (onRight && panDown) || (onLeft && panUp) ? yChange : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    // total change
    double rotationalChange = (verticalRotation + horizontalRotation) *
        (details.delta.distance * 0.2);

    // move the page controller
    _pageController.jumpTo(_pageController.offset + rotationalChange);
  }
}

class SongCard extends StatelessWidget {
  final Color color;
  final int currentIndex;
  final double currentPage;

  SongCard({
    this.color,
    this.currentIndex,
    this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    double relativePosition = currentIndex - currentPage;

    return Container(
      width: 250,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003)
          ..scale((1 - relativePosition.abs()).clamp(0.2, 0.6) + 0.4)
          ..rotateY(relativePosition),
        alignment: relativePosition >= 0
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: color,
          ),
        ),
      ),
    );
  }
}
