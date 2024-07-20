import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:snap_app/edit_snap_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as image_lib;

class ImageSelectScreen extends StatefulWidget {
  const ImageSelectScreen({super.key});

  @override
  State<ImageSelectScreen> createState() => _ImageSelectScreenState();
}

class _ImageSelectScreenState extends State<ImageSelectScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBitmap;

  Future<void> _selectImage() async {
    // XFile = ファイルの抽象化を提供するクラス, 画像を選択する
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    // ファイルオブジェクトから画像データを読み込む ?でnullの場合はnullを返す
    final imageBitmap = await imageFile?.readAsBytes();
    // nullじゃないことの確認 デバッグ用
    assert(imageBitmap != null);
    if (imageBitmap == null) return;

    // 画像データをデコードする
    final image = image_lib.decodeImage(imageBitmap);
    assert(image != null);
    if (image == null) return;

    // 画像データとメタデータを内包したクラス もとの画像はサイズが大きく表示に時間がかかるためリサイズする
    final image_lib.Image resizedImage;
    if (image.width > image.height) {
      // 横長の画像なら幅を500にリサイズ
      resizedImage = image_lib.copyResize(image, width: 500);
    } else {
      // 縦長の画像なら高さを500にリサイズ
      resizedImage = image_lib.copyResize(image, height: 500);
    }

    setState(() {
      _imageBitmap = image_lib.encodeBmp(resizedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final imageBitmap = _imageBitmap;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(l10n.imageSelectScreenTitle),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (imageBitmap != null) Image.memory(imageBitmap),
              ElevatedButton(
                onPressed: () => _selectImage(),
                child: Text(l10n.imageSelect),
              ),
              if (imageBitmap != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ImageEditScreen(imageBitmap: imageBitmap)));
                    // Add image selection logic here
                  },
                  child: Text(l10n.imageEdit),
                ),
            ],
          ),
        ));
  }
}
