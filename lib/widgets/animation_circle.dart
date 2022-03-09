import 'package:flutter/material.dart';

class AntimationCircle extends StatefulWidget {
  final Widget child;
  final Color firstColor;
  final Color secondColor;
  final double firstSize;
  final double SecondSize;
  const AntimationCircle({
    @required this.child,
    @required this.firstColor,
    @required this.secondColor,
    @required this.firstSize,
    @required this.SecondSize,
  });

  @override
  State<AntimationCircle> createState() => _AntimationCircleState();
}

class _AntimationCircleState extends State<AntimationCircle> {
  double _targetSize; // the width at the beginning
  Color _color; // the height at the beginning

  Future<void> _start() async {
    await Future.delayed(Duration(milliseconds: 100));
    if (!mounted) return;
    setState(() {
      _targetSize = widget.SecondSize;
      _color = widget.secondColor;
    });
  }

  @override
  void initState() {
    _targetSize = widget.firstSize; // the width at the beginning
    _color = widget.firstColor;
    _start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: _targetSize,
      height: _targetSize,
      decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
      curve: Curves.decelerate,
      alignment: Alignment.center,
      child: widget.child,
      onEnd: () {
        if (!mounted) return;

        setState(() {
          _targetSize = _targetSize == widget.firstSize
              ? widget.SecondSize
              : widget.firstSize;
          _color = _color == widget.firstColor
              ? widget.secondColor
              : widget.firstColor;
        });
      },
    );
  }
}
