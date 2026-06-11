import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/theme/colors.dart';
 

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
class DataErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const DataErrorWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}


class EmptyWidget extends StatelessWidget {
  final String emptyMessage;

  const EmptyWidget({
    super.key,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inbox,
              size: 64,
              color: grayColor,
            ),
            const SizedBox(height: 16),
            Text(
              'nothing_found'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: grayColor,
                shadows: [
                  Shadow(
                    color: grayColor,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 16,
                color: grayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
    );
  }
}