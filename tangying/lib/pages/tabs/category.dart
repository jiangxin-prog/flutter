import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tangying/controllers/counter.dart';
import '../../common/request.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ApiService apiService = ApiService();
  // 用户数据列表
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    // 初始加载数据
    fetchData();
  }

  Future<void> fetchData() async {
    print('开始请求');
    var response = await apiService.postRequest('/user/list', {'page': 1});
    print('Response: $response');
    if (response['code'] == 1) {
      var newUsers = response['data']['list'];
      setState(() {
        users.addAll(newUsers);
      });
    }
  }

  double calculateSpacing() {
    double availableWidth = MediaQuery.of(context).size.width;
    int columnCount = 4;
    double totalSpacing = availableWidth * 0.2;
    double singleSpacing = totalSpacing / (columnCount - 1);
    return singleSpacing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户列表',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              // 标题行
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('排序', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(width: calculateSpacing()),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('图像', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(width: calculateSpacing()),
                    Expanded(
                      flex: 4,
                      child: Text('用户名', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(width: calculateSpacing()),
                    Expanded(
                      flex: 1,
                      child: Text('积分', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                IconData trophyIcon;
                switch (users[index]['id']) {
                  case 1:
                    trophyIcon = Icons.search;
                    break;
                  case 2:
                    trophyIcon = Icons.usb_rounded;
                    break;
                  case 3:
                    trophyIcon = Icons.nat;
                    break;
                  default:
                    trophyIcon = Icons.abc;
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: (trophyIcon == Icons.abc)
                              ? Text('${users[index]['id']}',
                                  style: TextStyle(fontSize: 16))
                              : Icon(trophyIcon),
                        ),
                      ),
                      SizedBox(width: calculateSpacing()),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: users[index]['avatar'] != null &&
                                  users[index]['avatar'].startsWith('http')
                              ? CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      NetworkImage(users[index]['avatar']),
                                )
                              : CircleAvatar(
                                  radius: 25,
                                  child: Icon(Icons.person),
                                ),
                        ),
                      ),
                      SizedBox(width: calculateSpacing()),
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text(
                            '${users[index]['nickname'] ?? ''}',
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(width: calculateSpacing()),
                      Expanded(
                        flex: 1,
                        child: Text('${users[index]['score'] ?? 0}',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              },
              childCount: users.length,
            ),
          ),
        ],
      ),
    );
  }
}
