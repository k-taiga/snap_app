import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:snap_app/gen/assets.gen.dart';
import 'package:image/image.dart' as image_lib;

class ImageEditScreen extends StatefulWidget {
  const ImageEditScreen({super.key, required this.imageBitmap});

  final Uint8List imageBitmap;

  @override
  State<ImageEditScreen> createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  late Uint8List _imageBitmap;

  @override
  void initState() {
    super.initState();
    _imageBitmap = widget.imageBitmap;
  }

  void _rotateImage() {
    // 画像データをデコード
    final image = image_lib.decodeImage(_imageBitmap);
    if (image == null) return;
    // 90度回転
    final rotateImage = image_lib.copyRotate(image, angle: 90);
    setState(() {
      _imageBitmap = image_lib.encodeBmp(rotateImage);
    });
  }

  void _flipImage() {
    // 画像データをデコード
    final image = image_lib.decodeImage(_imageBitmap);
    if (image == null) return;
    // 左右反転
    final flipImage = image_lib.copyFlip(image,
        direction: image_lib.FlipDirection.horizontal);
    setState(() {
      _imageBitmap = image_lib.encodeBmp(flipImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(l10n.imageEditScreenTitle),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1, // 正方形のアスペクト比を維持
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.memory(_imageBitmap),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _rotateImage(),
                icon: Assets.rotateIcon.svg(height: 24, width: 24),
              ),
              IconButton(
                onPressed: () => _flipImage(),
                icon: Assets.flipIcon.svg(height: 24, width: 24),
              ),
            ],
          ),
        ));
  }
}
