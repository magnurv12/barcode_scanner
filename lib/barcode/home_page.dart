import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mlkit/barcode/barcode_controller.dart';
import 'package:mlkit/barcode/barcode_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final barcode = BarcodeController();

  @override
  void initState() {
    barcode.getAvailableCameras();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode'),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BarcodePage(
                            camera: barcode.cameraController!,
                          )),
                );
              },
              child: const Text('CameraTest'))),
    );
  }
}
