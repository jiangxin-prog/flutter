import 'package:flutter/material.dart';

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({super.key, this.child, required this.keepAlive});

  final Widget? child;
  final bool keepAlive; //是否缓存
  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  //以前和现在不一样自动更新缓存（仅仅这节课说也可注释掉）
  // @override
  // void didUpdateWidget(covariant KeepAliveWrapper oldWidget) {
  //   if (oldWidget.keepAlive != widget.keepAlive) {
  //     // keepAlive 状态需要更新，实现在 AutomaticKeepAliveClientMixin中
  //     updateKeepAlive();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }
}
