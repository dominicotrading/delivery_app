import 'package:flutter/material.dart';

class DashedSeparator extends StatelessWidget {
  const DashedSeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: List.generate(
          30,
          (index) => Expanded(
            child: Container(
              height: 1,
              color: index % 2 == 0 ? Colors.transparent : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
