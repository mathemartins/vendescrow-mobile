library navigation_dot_bar;

import 'package:flutter/material.dart';

class BottomNavigationDotBar extends StatefulWidget{

  final List<BottomNavigationDotBarItem> items;
  final Color activeColor;
  final Color color;

  const BottomNavigationDotBar({@required this.items, this.activeColor, this.color, Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigationDotBarState();

}

class _BottomNavigationDotBarState extends State<BottomNavigationDotBar>{

  GlobalKey _keyBottomBar = GlobalKey();
  double _numPositionBase, _numDifferenceBase, _positionLeftIndicatorDot;
  int _indexPageSelected = 0;
  Color _color, _activeColor;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _color = widget.color ?? Theme.of(context).hintColor;
    _activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final sizeBottomBar = (_keyBottomBar.currentContext.findRenderObject() as RenderBox).size;
    _numPositionBase = ((sizeBottomBar.width / widget.items.length));
    _numDifferenceBase = (_numPositionBase - (_numPositionBase / 2) + 2);
    setState(() { _positionLeftIndicatorDot = _numPositionBase - _numDifferenceBase; });
  }

  @override
  Widget build(BuildContext context) => Container (
    padding: EdgeInsets.fromLTRB(2, 3, 2, 0),
    child: Material(
        elevation: 5,
        borderRadius: BorderRadius.only(topRight: Radius.circular(50.0),topLeft: Radius.circular(40.0)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(40.0),topLeft: Radius.circular(40.0)),
         boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                color: Colors.black12.withOpacity(0.1),
                spreadRadius: 5.0
              )
            ]
          ),
          child: Stack(
            key: _keyBottomBar,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8,top: 1),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _createNavigationIconButtonList(widget.items.asMap())
                ),
              ),
              AnimatedPositioned(
                  child: CircleAvatar(radius: 2.5, backgroundColor: _activeColor),
                  duration: Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  left: _positionLeftIndicatorDot,
                  bottom: 0
              ),
            ],
          ),
        )
    ),
  );

  List<_NavigationIconButton> _createNavigationIconButtonList(Map<int, BottomNavigationDotBarItem> mapItem){
    List<_NavigationIconButton> children = List<_NavigationIconButton>();
    mapItem.forEach((index, item) =>
        children.add(_NavigationIconButton(item.icon, (index == _indexPageSelected) ? _activeColor : _color,item.onTap,() { _changeOptionBottomBar(index); }))
    );
    return children;
  }

  void _changeOptionBottomBar(int indexPageSelected){
    if(indexPageSelected != _indexPageSelected){
      setState(() { _positionLeftIndicatorDot = (_numPositionBase * (indexPageSelected+1))-_numDifferenceBase; });
      _indexPageSelected = indexPageSelected;
    }
  }

}

class BottomNavigationDotBarItem{
  final IconData icon;
  final NavigationIconButtonTapCallback onTap;
  const BottomNavigationDotBarItem({@required this.icon, this.onTap}) : assert(icon != null);
}

typedef NavigationIconButtonTapCallback = void Function();

class _NavigationIconButton extends StatefulWidget {

  final IconData _icon;
  final Color _colorIcon;
  final NavigationIconButtonTapCallback _onTapInternalButton;
  final NavigationIconButtonTapCallback _onTapExternalButton;

  const _NavigationIconButton(this._icon, this._colorIcon, this._onTapInternalButton, this._onTapExternalButton, {Key key}): super(key: key);

  @override
  _NavigationIconButtonState createState() => _NavigationIconButtonState();

}

class _NavigationIconButtonState extends State<_NavigationIconButton> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation _scaleAnimation;
  double _opacityIcon = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.93).animate(_controller);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        setState(() { _opacityIcon = 0.7; });
      },
      onTapUp: (_) {
        _controller.reverse();
        setState(() { _opacityIcon = 1; });
      },
      onTapCancel: () {
        _controller.reverse();
        setState(() { _opacityIcon = 1; });
      },
      onTap: () {
        widget._onTapInternalButton();
        widget._onTapExternalButton();
      },
      child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedOpacity(
              opacity: _opacityIcon,
              duration: Duration(milliseconds: 200),
              child: Icon(widget._icon, 
              color: Theme.of(context).hintColor ,
              )
          )
      )
  );
}
