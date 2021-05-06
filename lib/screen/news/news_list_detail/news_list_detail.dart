import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/component/News/NewsModel.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/LiveCrypto.dart';
import 'package:flutter/material.dart';

import '../../../progressHUD.dart';

class newsListDetail extends StatefulWidget {
  final String imageUrl;

  newsListDetail({Key key, this.imageUrl}) : super(key: key);

  _newsListDetailState createState() => _newsListDetailState();
}

class _newsListDetailState extends State<newsListDetail> {
  List<LiveCrypto> _liveCrypto = List<LiveCrypto>();
  APIService apiService = new APIService();
  News news = new News();
  User user = new User();
  bool loadData = true;

  @override
  void initState() {
    super.initState();
    fetchPageContent(widget.imageUrl);
  }

  void fetchPageContent(String imageUrl) async {
    var responseNewsDetail = await apiService
        .postNewsImageData('posts/post-details/', {"imageUrl": imageUrl});
    setState(() {
      news = News.fromJson(responseNewsDetail);
      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: loadData,
      opacity: 0.3,
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    double _fullHeight = MediaQuery.of(context).size.height;

    /// Hero animation for image
    Hero(
      tag: 'hero-tag-list-${news.url}',
      child: new DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(news.image.toString()), fit: BoxFit.cover)),
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

    return loadData
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  SliverPersistentHeader(
                    delegate: MySliverAppBar(
                        expandedHeight: _height - 0.0,
                        img: news.image,
                        id: news.url),
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
                  //             news.title,
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 16.5,
                  //                 fontFamily: "avenir",
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
                  //               "VendEscrow",
                  //               style: TextStyle(
                  //                   color: Colors.white54,
                  //                   fontSize: 16.0,
                  //                   fontFamily: "avenir",
                  //                   fontWeight: FontWeight.w400),
                  //               maxLines: 2,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //           )
                  //         ],
                  //       )),
                  // ),

                  /// Container for description to Sort and Refine
                  SliverToBoxAdapter(
                      child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      child: Text(
                        news.title,
                        style: TextStyle(
                            fontFamily: "avenir",
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      child: Text(
                        news.content,
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

  String img, id;

  MySliverAppBar({@required this.expandedHeight, this.img, this.id});

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
            tag: 'hero-tag-list-${id}',
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
