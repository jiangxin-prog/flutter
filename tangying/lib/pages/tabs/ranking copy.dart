import 'package:flutter/material.dart';
import '../../common/request.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final ApiService apiService = ApiService();
  int page = 1;
  List<Widget> list = [];

  @override
  void initState() {
    super.initState();
    // 初始加载数据
    loadData();
  }

  Future<void> loadData() async {
    print('Response start:');
    try {
      var response = await apiService
          .postRequest('/user/list', {'page': page, 'limit': 2});
      print('Response: $response');
      if (response['code'] == 1) {
        List<dynamic> dataList = response['data']['list'];
        List<Widget> newData = dataList.map((item) {
          if (item is Map<String, dynamic>) {
            return Center(
              child: Text(
                item['nickname']?.toString() ?? '',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            return Container();
          }
        }).toList();
        setState(() {
          list = newData; // 直接赋值新数据，而不是追加
          page++;
        });
      } else {
        // 处理其他状态码的情况
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content:
                Text('Failed to load data. Status code: ${response['code']}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // 处理异常情况
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Page"),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          if (index + 2 == list.length) {
            loadData();
          }
        },
        children:
            list.isNotEmpty ? list : [const Center(child: Text('Loading...'))],
      ),
    );
  }
}
