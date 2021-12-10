// @dart=2.9
import 'package:flutter/material.dart';
import 'package:vehicle_care_2/screen/approved_appointment_page.dart';
import 'package:vehicle_care_2/screen/closed_appointment_page.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'open_appointment_page.dart';

import 'package:vehicle_care_2/constant/responsive_screen.dart';

class TransactionScreenList extends StatefulWidget {
  final int idFrom, booking;
  final VoidCallback signOut;
//  const TransactionScreenList(this.idFrom);
  const TransactionScreenList(
      {Key key, this.idFrom, this.booking, this.signOut})
      : super(key: key);

  @override
  _TransactionScreenListState createState() => _TransactionScreenListState();
}

class _TransactionScreenListState extends State<TransactionScreenList>
    with TickerProviderStateMixin {
  final double barHeight = 66.0;

  LeftBar leftBar = LeftBar();

  // TickerProviderStateMixin allows the fade out/fade in animation when changing the active button

  // this will control the button clicks and tab changing
  TabController _controller;

  // this will control the animation when a button changes from an off state to an on state
  AnimationController _animationControllerOn;

  // this will control the animation when a button changes from an on state to an off state
  AnimationController _animationControllerOff;

  // this will give the background color values of a button when it changes to an on state
  Animation _colorTweenBackgroundOn;
  Animation _colorTweenBackgroundOff;

  // this will give the foreground color values of a button when it changes to an on state
  Animation _colorTweenForegroundOn;
  Animation _colorTweenForegroundOff;

  // when swiping, the _controller.index value only changes after the animation, therefore, we need this to trigger the animations and save the current index
  int _currentIndex = 0;

  // saves the previous active tab
  int _prevControllerIndex = 0;

  // saves the value of the tab animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
  double _aniValue = 0.0;

  // saves the previous value of the tab animation. It's used to figure the direction of the animation
  double _prevAniValue = 0.0;

  // these will be our tab icons. You can use whatever you like for the content of your buttons
  List<String> _titleTab = [
    // "Doctor's Schedule",
    "Open Appointment",
    "Approved Appointment",
    "Closed Appointment"
  ];

  // active button's foreground color
  Color _foregroundOn = Colors.white;
  Color _foregroundOff = Colors.black;

  // active button's background color
  Color _backgroundOn = Color(0xff008ECC);
  Color _backgroundOff = Color(0xff7d7d7d);

  // scroll controller for the TabBar
  ScrollController _scrollController = new ScrollController();

  // this will save the keys for each Tab in the Tab Bar, so we can retrieve their position and size for the scroll controller
  List _keys = [];

  // regist if the the button was tapped
  bool _buttonTap = false;

  @override
  void initState() {
    super.initState();

    for (int index = 0; index < _titleTab.length; index++) {
      // create a GlobalKey for each Tab
      _keys.add(new GlobalKey());
    }

    // this creates the controller with 6 tabs (in our case)
    _controller = TabController(vsync: this, length: _titleTab.length);

    if (widget.booking != null) {
      _controller =
          TabController(vsync: this, length: _titleTab.length, initialIndex: 0);
      _currentIndex = 0;
    }

    // this will execute the function every time there's a swipe animation
    _controller.animation.addListener(_handleTabAnimation);
    // this will execute the function every time the _controller.index value changes
    _controller.addListener(_handleTabChange);

    _animationControllerOff =
        AnimationController(vsync: this, duration: Duration(milliseconds: 75));
    // so the inactive buttons start in their "final" state (color)
    _animationControllerOff.value = 1.0;
    _colorTweenBackgroundOff =
        ColorTween(begin: _backgroundOn, end: _backgroundOff)
            .animate(_animationControllerOff);
    _colorTweenForegroundOff =
        ColorTween(begin: _foregroundOn, end: _foregroundOff)
            .animate(_animationControllerOff);

    _animationControllerOn =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    // so the inactive buttons start in their "final" state (color)
    _animationControllerOn.value = 1.0;
    _colorTweenBackgroundOn =
        ColorTween(begin: _backgroundOff, end: _backgroundOn)
            .animate(_animationControllerOn);
    _colorTweenForegroundOn =
        ColorTween(begin: _foregroundOff, end: _foregroundOn)
            .animate(_animationControllerOn);
  }

  setIndex() {
    setState(() {
      print("masuk");
      _controller =
          TabController(vsync: this, length: _titleTab.length, initialIndex: 0);
      _currentIndex = 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Screen size;

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      // FindDoctorRoomAvailable(
      //   signOut: widget.signOut,
      // ),
      OpenAppointmentPage(),
      ApprovedAppointmentPage(),
      ClosedAppointmentPage()
    ];

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
        appBar: AppBar(
          title: Text("Transaction List"),
        ),
        drawer: leftBar,
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          // Container(
          //   padding: new EdgeInsets.only(top: statusBarHeight),
          //   height: statusBarHeight + barHeight,
          //   child: appBarMethod(),
          //   decoration: new BoxDecoration(
          //     gradient: new LinearGradient(
          //         colors: [const Color(0xFF008ECC), const Color(0xFF2FACFE)],
          //         begin: const FractionalOffset(0.0, 0.0),
          //         end: const FractionalOffset(0.5, 0.0),
          //         stops: [0.0, 0.5],
          //         tileMode: TileMode.clamp),
          //   ),
          // ),
          Container(
              height: 49.0,
              child: ListView.builder(
                  // this gives the TabBar a bounce effect when scrolling farther than it's size
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  // make the list horizontal
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  // number of tabs
                  itemCount: _titleTab.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        // each button's key
                        key: _keys[index],
                        // padding for the buttons
                        padding: EdgeInsets.all(6.0),
                        child: ButtonTheme(
                            child: AnimatedBuilder(
                          animation: _colorTweenBackgroundOn,
                          builder: (context, child) => FlatButton(
                              // get the color of the button's background (dependent of its state)
                              color: Colors.white,
                              // make the button a rectangle with round corners
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                  side: BorderSide(
                                      color: _getBackgroundColor(index))),
                              onPressed: () {
                                setState(() {
                                  _buttonTap = true;
                                  _controller.animateTo(index);
                                  _setCurrentIndex(index);
                                  _scrollTo(index);
                                });
                              },
                              child: Text("${_titleTab[index]}",
                                  style: TextStyle(
                                      color: _getBackgroundColor(index)))),
                        )));
                  })),
          Expanded(
              // this will host our Tab Views
              child: TabBarView(
                  // and it is controlled by the controller
                  controller: _controller,
                  children: _widgetOptions
                  // our Tab Views

                  )),
        ]));
  }

  // runs during the switching tabs animation
  _handleTabAnimation() {
    // gets the value of the animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
    _aniValue = _controller.animation.value;

    // if the button wasn't pressed, which means the user is swiping, and the amount swipped is less than 1 (this means that we're swiping through neighbor Tab Views)
    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      // set the current tab index
      _setCurrentIndex(_aniValue.round());
    }

    // save the previous Animation Value
    _prevAniValue = _aniValue;
  }

  // runs when the displayed tab changes
  _handleTabChange() {
    // if a button was tapped, change the current index
    if (_buttonTap) _setCurrentIndex(_controller.index);

    // this resets the button tap
    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) _buttonTap = false;

    // save the previous controller index
    _prevControllerIndex = _controller.index;
  }

  _setCurrentIndex(int index) {
    // if we're actually changing the index
    if (index != _currentIndex) {
      setState(() {
        // change the index
        _currentIndex = index;
      });

      // trigger the button animation
      _triggerAnimation();
      // scroll the TabBar to the correct position (if we have a scrollable bar)
      _scrollTo(index);
    }
  }

  _triggerAnimation() {
    // reset the animations so they're ready to go
    _animationControllerOn.reset();
    _animationControllerOff.reset();

    // run the animations!
    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  _scrollTo(int index) {
    // get the screen width. This is used to check if we have an element off screen
    double screenWidth = MediaQuery.of(context).size.width;

    // get the button we want to scroll to
    RenderBox renderBox = _keys[index].currentContext.findRenderObject();
    // get its size
    double size = renderBox.size.width;
    // and position
    double position = renderBox.localToGlobal(Offset.zero).dx;

    // this is how much the button is away from the center of the screen and how much we must scroll to get it into place
    double offset = (position + size / 2) - screenWidth / 2;

    // if the button is to the left of the middle
    if (offset < 0) {
      // get the first button
      renderBox = _keys[0].currentContext.findRenderObject();
      // get the position of the first button of the TabBar
      position = renderBox.localToGlobal(Offset.zero).dx;

      // if the offset pulls the first button away from the left side, we limit that movement so the first button is stuck to the left side
      if (position > offset) offset = position;
    } else {
      // if the button is to the right of the middle

      // get the last button
      renderBox = _keys[_titleTab.length - 1].currentContext.findRenderObject();
      // get its position
      position = renderBox.localToGlobal(Offset.zero).dx;
      // and size
      size = renderBox.size.width;

      // if the last button doesn't reach the right side, use it's right side as the limit of the screen for the TabBar
      if (position + size < screenWidth) screenWidth = position + size;

      // if the offset pulls the last button away from the right side limit, we reduce that movement so the last button is stuck to the right side limit
      if (position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }

    // scroll the calculated ammount
    _scrollController.animateTo(offset + _scrollController.offset,
        duration: new Duration(milliseconds: 150), curve: Curves.easeInOut);
  }

  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      // if it's active button
      return _colorTweenBackgroundOn.value;
    } else if (index == _prevControllerIndex) {
      // if it's the previous active button
      return _colorTweenBackgroundOff.value;
    } else {
      // if the button is inactive
      return _backgroundOff;
    }
  }

  _getForegroundColor(int index) {
    // the same as the above
    if (index == _currentIndex) {
      return _colorTweenForegroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenForegroundOff.value;
    } else {
      return _foregroundOff;
    }
  }

  Widget appBarMethod() {
    if (widget.idFrom == 1) {
      return Center(
          child: new Text("Transaction List",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
              )));
    } else if (widget.idFrom == 2) {
      return Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: size.wp(8)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Transaction List",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
          child: new Text("Transaction List",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
              )));
    }
  }
}
