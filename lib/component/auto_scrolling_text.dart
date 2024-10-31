
import 'package:flutter/material.dart';

class AutoScrollingText extends StatefulWidget {
  final String text;
  final double textWidth;
  const AutoScrollingText({
    super.key,
    required this.text,
    required this.textWidth,
  });
  @override
  AutoScrollingTextState createState() => AutoScrollingTextState();
}

class AutoScrollingTextState extends State<AutoScrollingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: false);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 24,
        child: OverflowBox(
          minWidth: 0.0,
          maxWidth: double.infinity,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double offset =
                  MediaQuery.of(context).size.width * _animation.value;
              return Transform.translate(
                offset: Offset(-offset, 0),
                child: Row(
                  children: [
                    Container(
                      width: widget.textWidth, // Set width from the parameter
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        '📰 ${widget.text}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: widget.textWidth, // Set width from the parameter
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        '📰 ${widget.text}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
