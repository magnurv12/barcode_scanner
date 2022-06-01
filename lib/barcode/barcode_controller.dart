import 'package:boleto/boleto.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class BarcodeController {
  final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.all]);
  CameraController? cameraController;

  void getAvailableCameras() async {
    try {
      final response = await availableCameras();
      final camera = response.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.back);
      cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await cameraController!.initialize();
      listenCamera();
    } catch (e) {
      print(e);
    }
  }

  Future<void> processImage(InputImage inputImage) async {
    final validator = Boleto();
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);
    Barcode? barcode;
    for (Barcode item in barcodes) {
      barcode = item;
    }

    if (barcode!.displayValue!.length == 44) {
      cameraController!.dispose();
      await barcodeScanner.close();
    }
  }

  void listenCamera() {
    cameraController!.startImageStream((cameraImage) async {
      //print(cameraController!.description.sensorOrientation);
      final camera; // your camera instance
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize =
          Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

      InputImageRotation imageRotation = InputImageRotation.rotation0deg;

      final InputImageFormat inputImageFormat =
          InputImageFormatValue.fromRawValue(cameraImage.format.raw) ??
              InputImageFormat.nv21;

      final planeData = cameraImage.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList();

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );

      final inputImage =
          InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
      processImage(inputImage);
    });
  }

  void dispose() {
    barcodeScanner.close();
    cameraController!.dispose();
  }
}
