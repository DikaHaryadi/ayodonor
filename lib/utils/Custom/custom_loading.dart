import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({Key? key, this.type = 0}) : super(key: key);

  final int type;

  @override
  // ignore: library_private_types_in_public_api
  _CustomLoadingState createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // icon pmi
      Visibility(visible: widget.type == 0, child: _buildLoadingTwo()),
    ]);
  }

  Widget _buildLoadingTwo() {
    return Stack(alignment: Alignment.center, children: [
      Image.asset(
        'images/logo.png',
        height: 60,
        width: 60,
      ),
      RotationTransition(
        alignment: Alignment.center,
        turns: _controller,
        child: Lottie.asset('images/loading.json'),
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
