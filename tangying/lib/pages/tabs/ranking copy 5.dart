import 'package:flutter/material.dart';
import '../../common/request.dart';
import 'package:photo_view/photo_view_gallery.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final ApiService apiService = ApiService();
  ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _list = [];
  int _index = 0;
  int _page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this._getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        print('滑动到了最底部');
        _getData();
      }
    });
  }

  _getData() async {
    var response = await apiService.postRequest('/user/list', {'page': _page});
    print('Response: $response');
    if (response['code'] == 1) {
      dynamic result = response['data']['list'];
      print('result type: ${result.runtimeType}');
      setState(() {
        List<Map<String, dynamic>> newList =
            (result as List).asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;
          return {
            'rank': _page * 2 - result.length + index + 1,
            'avatar': item['avatar'],
            'nickname': item['nickname'],
            'score': item['score'],
          };
        }).toList();
        _list.addAll(newList);
        _page++;
      });
    }
  }

  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    print('执行刷新');
    // this._getData();
    await Future.delayed(Duration(seconds: 3), () {
      print('refresh');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/beijing.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () {
                        print('去分享被点击');
                      },
                      child: const Text(
                        "去分享",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "点击去分享，分享人提现\n",
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: "您将得到",
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: "10%",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "的分润哦！",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      body: this._list.length > 0
          ? RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: this._list.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = _list[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: item['avatar'] != null &&
                                  item['avatar'].startsWith('http')
                              ? NetworkImage(item['avatar'])
                              : const AssetImage('default_avatar.png'),
                        ),
                        title: Text('${item['rank']}'),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['nickname']),
                            Text('积分: ${item['score']}'),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            )
          : _getMoreWidget(),
    );
  }
}
