
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/utils/sizes.dart';
import 'package:flutter/material.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({
    super.key,
    required this.itemLength,
    required int activePage,
  }) : _activePage = activePage;

  final int itemLength;
  final int _activePage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: screenWidth,
        height: 8,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
                ...List.generate(itemLength, (index) {
                  return Container(
                alignment: Alignment.center,
                height: 8,
                width: 8,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration:  BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: index == _activePage ? primaryColor : grayColor),
              );
                }),
            ],),
      ),
    );
  }
}
