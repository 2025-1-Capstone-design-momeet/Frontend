import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class FileRow extends StatelessWidget {
  final File? file;
  final String? downloadUrl;

  const FileRow({super.key, required this.file, this.downloadUrl});

  @override
  Widget build(BuildContext context) {
    if (downloadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ 다운로드 URL이 없습니다")),
      );
      return const SizedBox.shrink();
    }

    launchUrl(Uri.parse(downloadUrl!), mode: LaunchMode.externalApplication);

    return const SizedBox.shrink(); // 시각적으로 보이지 않게
  }
}
