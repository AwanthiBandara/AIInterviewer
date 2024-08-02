import 'package:aiinterviewer/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class ProgressView extends StatefulWidget {
  final _ProgressViewState _progressViewState = _ProgressViewState();
  final bool small;
  final bool showBg;
  final Color ?color;

  ProgressView({super.key, this.small = false, this.showBg = true,this.color});

  @override
  State<StatefulWidget> createState() {
    return _progressViewState;
  }
}

class _ProgressViewState extends State<ProgressView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: Container(
        width: widget.small ? 40 : 70,
        height: widget.small ? 40 : 70,
        color: widget.showBg ? Colors.transparent : Colors.white,
        child: SizedBox(
          width: widget.small ? 30 : 60,
          height: widget.small ? 30 : 60,
          child: SpinKitThreeBounce(
              color: secondaryColor, size: widget.small ? 8 : 25),
        ),
      ),
    );
  }
}
