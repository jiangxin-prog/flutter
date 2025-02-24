import 'package:flutter/material.dart';
import 'package:tangying/tools/KeepAliveWrapper.dart';
import '../../common/request.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService apiService = ApiService();
  int ipersonalI = 0;
  int promotionI = 0;

  List<Widget> personalList = [];
  bool personalIsLoading = false;

  List<Widget> promotionList = [];
  bool promotionIsLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await fetchInitialPersonalData();
    await fetchInitialPromotionData();
  }

  Future<void> fetchInitialPersonalData() async {
    setState(() {
      personalIsLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    ipersonalI++;
    var response = await apiService.postRequest('/user/list', {'page': ipersonalI});
    print('Response: $response');

    if (response['code'] == 1) {
      var listData = response['data']['list'];
      List<Widget> newPersonalList = listData.map((item) {
        return ListTile(
          title: Text(item['nickname']?? ''),
          subtitle: Text('score: ${item['score']?? 0}'),
          // leading: item['avatar']!= null && item['avatar'].startsWith('http')
          //     ? Image.network(item['avatar']?? '')
          //     : null,
        );
      }).toList();
      setState(() {
        personalList.addAll(newPersonalList);
        personalIsLoading = false;
      });
    }
  }

  Future<void> fetchInitialPromotionData() async {
    setState(() {
      promotionIsLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    promotionI++;
    var response = await apiService.postRequest('/user/list', {'page': promotionI});
    print('Response: $response');

    if (response['code'] == 1) {
      var listData = response['data']['list'];
      List<Widget> newPromotionList = listData.map((item) {
        return ListTile(
          title: Text(item['nickname']?? ''),
          subtitle: Text('score: ${item['score']?? 0}'),
          // leading: item['avatar']!= null && item['avatar'].startsWith('http')
          //     ? Image.network(item['avatar']?? '')
          //     : null,
        );
      }).toList();
      setState(() {
        promotionList.addAll(newPromotionList);
        promotionIsLoading = false;
      });
    }
  }

  Future<void> fetchPersonalData() async {
    if (personalIsLoading) return;

    setState(() {
      personalIsLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    ipersonalI++;
    var response = await apiService.postRequest('/user/list', {'page': ipersonalI});
    print('Response: $response');

    if (response['code'] == 1) {
      var listData = response['data']['list'];
      List<Widget> newPersonalList = listData.map((item) {
        return ListTile(
          title: Text(item['nickname']?? ''),
          subtitle: Text('score: ${item['score']?? 0}'),
          leading: item['avatar']!= null && item['avatar'].startsWith('http')
              ? Image.network(item['avatar']?? '')
              : null,
        );
      }).toList();
      setState(() {
        personalList.addAll(newPersonalList);
        personalIsLoading = false;
      });
    }
  }

  Future<void> fetchPromotionData() async {
    if (promotionIsLoading) return;

    setState(() {
      promotionIsLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    promotionI++;
    var response = await apiService.postRequest('/user/list2', {'page': promotionI});
    print('Response: $response');

    if (response['code'] == 1) {
      var listData = response['data']['list'];
      List<Widget> newPromotionList = listData.map((item) {
        return ListTile(
          title: Text(item['nickname']?? ''),
          subtitle: Text('score: ${item['score']?? 0}'),
          leading: item['avatar']!= null && item['avatar'].startsWith('http')
              ? Image.network(item['avatar']?? '')
              : null,
        );
      }).toList();
      setState(() {
        promotionList.addAll(newPromotionList);
        promotionIsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: SizedBox(
            height: 30,
            child: TabBar(
              isScrollable: false,
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
              tabs: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Tab(
                        child: Text("个人排行"),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Tab(
                        child: Text("推广排行"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          KeepAliveWrapper(
            keepAlive: true,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&!personalIsLoading) {
                  fetchPersonalData();
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                itemCount: personalList.length,
                itemBuilder: (context, index) {
                  return personalList[index];
                },
              ),
            ),
          ),
          KeepAliveWrapper(
            keepAlive: true,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels == notification.metrics.maxScrollExtent &&!promotionIsLoading) {
                  fetchPromotionData();
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                itemCount: promotionList.length,
                itemBuilder: (context, index) {
                  return promotionList[index];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}