import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class ListController extends GetxController {
  RxList list = [].obs;

  void add(value) {
    list.add(value);
    update();
  }
}
