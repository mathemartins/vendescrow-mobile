import 'package:crypto_v2/component/News/NewsModel.dart';
import 'package:flutter/material.dart';

class headerSliderDetail extends StatefulWidget {
  News item;

  headerSliderDetail({Key key, this.item}) : super(key: key);

  _headerSliderDetailState createState() => _headerSliderDetailState(item);
}

class _headerSliderDetailState extends State<headerSliderDetail> {
  News item;
  _headerSliderDetailState(this.item);

  @override
  Widget build(BuildContext context) {
    double _fullHeight = MediaQuery.of(context).size.height;

    /// Hero animation for image
    final hero = Hero(
      tag: 'hero-tag-${item.url}',
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new NetworkImage(item.image),
          ),
          shape: BoxShape.rectangle,
        ),
        child: Container(
          margin: EdgeInsets.only(top: 130.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: [
                const Color(0xFF000000),
                const Color(0x00000000),
              ],
            ),
          ),
        ),
      ),
    );

    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: MySliverAppBar(
                  expandedHeight: _height - 30.0,
                  img: item.image,
                  id: item.url,
                  title: item.title,
                  category: "Blockchain"),
              pinned: true,
            ),

            /// Appbar Custom using a SliverAppBar
            // SliverAppBar(
            //   centerTitle: true,
            //   backgroundColor: Color(0xFF172E4D),
            //   iconTheme: IconThemeData(color: Colors.white),
            //   expandedHeight: _fullHeight - 20,
            //   elevation: 0.1,
            //   pinned: true,
            //   flexibleSpace: FlexibleSpaceBar(
            //       centerTitle: true,
            //       title: Container(
            //         width: 220.0,
            //         child: Padding(
            //           padding: const EdgeInsets.only(top: 50.0),
            //           child: Text(
            //             item.title,
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 16.5,
            //                 fontFamily: "Popins",
            //                 fontWeight: FontWeight.w700),
            //             maxLines: 3,
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         ),
            //       ),
            //       background: Stack(
            //         children: <Widget>[
            //           Material(
            //             child: hero,
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.only(top: 540.0, left: 20.0),
            //             child: Text(
            //               item.category,
            //               style: TextStyle(
            //                   color: Colors.white54,
            //                   fontSize: 16.0,
            //                   fontFamily: "Popins",
            //                   fontWeight: FontWeight.w400),
            //               maxLines: 2,
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //           )
            //         ],
            //       )),
            // ),

            SliverToBoxAdapter(
                child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                child: Text(
                  item.content,
                  style: TextStyle(
                      fontFamily: "avenir",
                      color: Theme.of(context).textSelectionColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 50.0,
              )
            ])),
          ],
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  String img, id, title, category;

  MySliverAppBar(
      {@required this.expandedHeight,
      this.img,
      this.id,
      this.title,
      this.category});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.clip,
      children: [
        Container(
          height: 50.0,
          width: double.infinity,
          color: Color(0xFF172E4D),
        ),
        Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: Hero(
            transitionOnUserGestures: true,
            tag: 'hero-tag-${id}',
            child: new DecoratedBox(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage(img),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                margin: EdgeInsets.only(top: 130.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                    colors: <Color>[
                      const Color(0xFF000000),
                      const Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        //  Positioned(
        //     top: expandedHeight / 2 - shrinkOffset,
        //     left: MediaQuery.of(context).size.width / 4,
        //     child: Opacity(
        //       opacity: (1 - shrinkOffset / expandedHeight),
        //       child: Card(
        //         elevation: 10,
        //         child: SizedBox(
        //           height: expandedHeight,
        //           width: MediaQuery.of(context).size.width / 2,
        //           child: Container(
        //               width: 220.0,
        //               child: Padding(
        //                 padding: const EdgeInsets.only(top: 50.0),
        //                 child: Text(
        //                   title,
        //                   style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 16.5,
        //                       fontFamily: "Popins",
        //                       fontWeight: FontWeight.w700),
        //                   maxLines: 3,
        //                   overflow: TextOverflow.ellipsis,
        //                 ),
        //               ),
        //         ),
        //       ),
        //     ),),),

        Align(
          alignment: Alignment.bottomLeft,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.5,
                          fontFamily: "avenir",
                          fontWeight: FontWeight.w700),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    child: Text(
                      category,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.5,
                          fontFamily: "avenir",
                          fontWeight: FontWeight.w400),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Icon(Icons.arrow_back),
                    ))),
            Align(
              alignment: Alignment.center,
              child: Text(
                "News",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "avenir",
                  fontWeight: FontWeight.w700,
                  fontSize: (expandedHeight / 40) - (shrinkOffset / 40) + 18,
                ),
              ),
            ),
            SizedBox(
              width: 36.0,
            )
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
