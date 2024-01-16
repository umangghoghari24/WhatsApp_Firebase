import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

import '../../../../commen/utils.dart';

Future<GiphyGif?> pickGif(BuildContext context, ) async {
  GiphyGif? gif;
  try {
    gif = await GiphyPicker.pickGif(
      context: context,
      apiKey: 'MOaUYrS28rhoTBmbUg4L0gvz3WgHvBB0'
    );
  } catch (e) {
    showSnackBar(
      context: context,
      message: e.toString(),
    );
  }

  return gif;
}