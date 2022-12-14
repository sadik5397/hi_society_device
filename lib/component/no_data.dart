import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/padding_margin.dart';

Center noData() {
  return Center(child: Padding(padding: EdgeInsets.all(primaryPaddingValue * 6).copyWith(bottom: primaryPaddingValue * 12), child: Lottie.asset("assets/noData.json", fit: BoxFit.contain)));
}
