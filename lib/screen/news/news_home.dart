import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/component/News/NewsModel.dart';
import 'package:crypto_v2/component/News/newsHeaderModel.dart';
import 'package:crypto_v2/component/News/newsListBottom.dart';
import 'package:crypto_v2/screen/news/news_header_slider/intro_page_item.dart';
import 'package:crypto_v2/screen/news/news_header_slider/page_transformer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'news_list_detail/news_list_detail.dart';

class news extends StatefulWidget {
  final Widget child;

  news({Key key, this.child}) : super(key: key);

  _newsState createState() => _newsState();
}

class _newsState extends State<news> {
  List<News> _news = List<News>();
  APIService apiService = new APIService();
  News news = new News();
  bool loadData = true;

  @override
  void initState() {
    super.initState();
    apiService.getNewsData().then((value) {
      setState(() {
        _news.addAll(value);
        loadData = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            ClipPath(
                clipper: new DialogonalClipper(),
                child: Container(
                  height: 230.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          tileMode: TileMode.repeated,
                          colors: [Color(0xFF15EDED), Color(0xFF029CF5)])),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 70.0, left: 20.0),
                  child: Text(
                    "Explore",
                    style: TextStyle(
                        fontFamily: "avenir",
                        fontWeight: FontWeight.w800,
                        fontSize: 25.0,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: loadData
                      ? _loadingDataHeader(context)
                      : _dataLoadedHeader(context, _news),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 30.0),
                  child: Text("Blockchain The Future",
                      style: TextStyle(
                          fontFamily: "avenir",
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700)),
                ),
                loadData
                    ? _loadingDataList(context)
                    : _dataLoadedList(context, _news),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Calling imageLoading animation for set a grid layout
Widget _loadingDataHeader(BuildContext context) {
  return SizedBox.fromSize(
    size: const Size.fromHeight(500.0),
    child: PageTransformer(
      pageViewBuilder: (context, visibilityResolver) {
        return PageView.builder(
          controller: PageController(viewportFraction: 0.87),
          itemCount: 2,
          itemBuilder: (context, index) {
            final item = sampleItems[index];
            final pageVisibility =
                visibilityResolver.resolvePageVisibility(index);
            return cardHeaderLoading(context);
          },
        );
      },
    ),
  );
}

Widget cardHeaderLoading(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 500.0,
      width: 275.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Color(0xFF2C3B4F),
      ),
      child: Shimmer.fromColors(
        baseColor: Color(0xFF3B4659),
        highlightColor: Color(0xFF606B78),
        child: Padding(
          padding: const EdgeInsets.only(top: 320.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 17.0,
                width: 70.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 20.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 250.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Calling ImageLoaded animation for set a grid layout
Widget _dataLoadedHeader(BuildContext context, List<News> news) {
  return SizedBox.fromSize(
    size: const Size.fromHeight(500.0),
    child: PageTransformer(
      pageViewBuilder: (context, visibilityResolver) {
        return PageView.builder(
          controller: PageController(viewportFraction: 0.87),
          itemCount: news.length,
          itemBuilder: (context, index) {
            final item = news[index];
            final pageVisibility =
                visibilityResolver.resolvePageVisibility(index);
            return IntroPageItem(
              item: item,
              pageVisibility: pageVisibility,
            );
          },
        );
      },
    ),
  );
}

/// Calling imageLoading animation for set a list layout
Widget _loadingDataList(BuildContext context) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.only(top: 0.0),
      itemCount: newsList.length,
      itemBuilder: (ctx, i) {
        return loadingCard(ctx, newsList[i]);
      },
    ),
  );
}

Widget loadingCard(BuildContext ctx, newsListBottom item) {
  return Padding(
    padding: const EdgeInsets.only(left: 25.0, top: 20.0, bottom: 0.0),
    child: Shimmer.fromColors(
      baseColor: Color(0xFF3B4659),
      highlightColor: Color(0xFF606B78),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 95.0,
            width: 130.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Theme.of(ctx).hintColor.withAlpha(170),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: 13.0,
                    width: 70.0,
                    color: Theme.of(ctx).hintColor.withAlpha(170),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Container(
                    height: 15.0,
                    width: 170.0,
                    color: Theme.of(ctx).hintColor.withAlpha(170),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Container(
                    height: 15.0,
                    width: 170.0,
                    color: Theme.of(ctx).hintColor.withAlpha(170),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 15.0,
                        color: Theme.of(ctx).hintColor.withAlpha(170),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          height: 12.0,
                          width: 30.0,
                          color: Theme.of(ctx).hintColor.withAlpha(170),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

/// Calling ImageLoaded animation for set a grid layout

Widget _dataLoadedList(BuildContext context, List<News> news) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.only(top: 0.0),
      itemCount: news.length,
      itemBuilder: (ctx, i) {
        return card(news[i], ctx);
      },
    ),
  );
}

Widget card(News item, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 25.0, top: 20.0, bottom: 0.0),
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => new newsListDetail(
                    imageUrl: item.image,
                  ),
              transitionDuration: Duration(milliseconds: 600),
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: child,
                );
              }),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: 'hero-tag-list-${item.url}',
            child: Material(
              child: Container(
                height: 95.0,
                width: 130.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  image: DecorationImage(
                      image: NetworkImage(
                        item.image,
                      ),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "VendEscrow",
                    style: TextStyle(
                        fontFamily: "avenir",
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context)
                            .textSelectionColor
                            .withOpacity(0.3)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Container(
                      width: 180.0,
                      child: Text(
                        item.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 15.0,
                        color: Theme.of(context).hintColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          item.publish,
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontFamily: "Gotik"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path = Path();
    path.lineTo(0.0, size.height * 1.5);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    paint.color = Color(0xFF15EDED);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, 180.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
