import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataStateWidget extends StatelessWidget {
  final RxBool isLoading; // Observable loading state
  final RxBool hasError; // Observable error state
  final RxBool isEmpty; // Observable empty data state
  final String errorMessage; // Error message to display
  final String emptyMessage; // Message to display when data is empty
  final VoidCallback onRetry; // Callback for retry action
  final Widget child; // The main content to display when data is available

  const DataStateWidget({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.isEmpty,
    this.errorMessage = 'Something went wrong. Please try again.',
    this.emptyMessage = 'No data available.',
    required this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        print("things are loading................................................................");
        return const Center(child: CircularProgressIndicator());
      }

      if (hasError.value) {
        print("things are errors................................................................");
        return _buildErrorState();
      }

      if (isEmpty.value) {
        print("things are empty................................................................");
        return _buildEmptyState();
      }

      // Ensure child is never null
      return child;
    });
  }

  // Widget to display error state
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Widget to display empty data state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            emptyMessage,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}