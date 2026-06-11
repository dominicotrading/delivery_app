import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';

class QRScannerScreen extends StatefulWidget {
  final Function(String) onQRCodeScanned;
  
  const QRScannerScreen({super.key, required this.onQRCodeScanned});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool isScanning = true;
  bool isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showLoadingScreen(String qrData) {
    setState(() {
      isLoading = true;
    });
    
    // First, dismiss the QR scanner screen
    Get.back();
    
    // Then show loading overlay on the previous screen
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: successColor,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  'qr_code_scanned'.tr,
                  style: darkTitleStyle(FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'processing_delivery_confirmation'.tr,
                  style: grayNormalTextStyle(FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Loading indicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Processing text
                Text(
                  'please_wait_verification'.tr,
                  style: grayNormalTextStyle(FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
    
    // Simulate a small delay to show the loading screen
    Future.delayed(const Duration(milliseconds: 500), () {
      // Close the loading dialog
      Get.back();
      
      // Call the callback function
      widget.onQRCodeScanned(qrData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('scan_qr_code'.tr, style: subTitleStyle(FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.flashlight_on, color: Colors.white),
            onPressed: () => controller.toggleTorch(),
            tooltip: 'flashlight'.tr,
          ),
          IconButton(
            icon: const Icon(Icons.camera_rear, color: Colors.white),
            onPressed: () => controller.switchCamera(),
            tooltip: 'switch_camera'.tr,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (isScanning && capture.barcodes.isNotEmpty) {
                isScanning = false;
                _showLoadingScreen(capture.barcodes.first.rawValue ?? '');
              }
            },
          ),
          // Custom overlay
          CustomPaint(
            painter: ScannerOverlay(),
            child: const SizedBox.expand(),
          ),
          // Instructions
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Position QR code within the frame',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom overlay painter for QR scanner
class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final scanArea = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 250,
      height: 250,
    );

    // Draw the background
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(scanArea, const Radius.circular(10))),
      ),
      paint,
    );

    // Draw the corner borders
    final borderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const cornerLength = 30.0;
    const cornerRadius = 10.0;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left, scanArea.top + cornerLength)
        ..lineTo(scanArea.left, scanArea.top + cornerRadius)
        ..arcToPoint(
          Offset(scanArea.left + cornerRadius, scanArea.top),
          radius: Radius.circular(cornerRadius),
        )
        ..lineTo(scanArea.left + cornerLength, scanArea.top),
      borderPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right - cornerLength, scanArea.top)
        ..lineTo(scanArea.right - cornerRadius, scanArea.top)
        ..arcToPoint(
          Offset(scanArea.right, scanArea.top + cornerRadius),
          radius: Radius.circular(cornerRadius),
        )
        ..lineTo(scanArea.right, scanArea.top + cornerLength),
      borderPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right, scanArea.bottom - cornerLength)
        ..lineTo(scanArea.right, scanArea.bottom - cornerRadius)
        ..arcToPoint(
          Offset(scanArea.right - cornerRadius, scanArea.bottom),
          radius: Radius.circular(cornerRadius),
        )
        ..lineTo(scanArea.right - cornerLength, scanArea.bottom),
      borderPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left + cornerLength, scanArea.bottom)
        ..lineTo(scanArea.left + cornerRadius, scanArea.bottom)
        ..arcToPoint(
          Offset(scanArea.left, scanArea.bottom - cornerRadius),
          radius: Radius.circular(cornerRadius),
        )
        ..lineTo(scanArea.left, scanArea.bottom - cornerLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 