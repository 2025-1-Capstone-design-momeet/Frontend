import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SummaryDialog {
  static Future<void> show(BuildContext context,
      {required File recordFile, required String clubId}) async {
    final TextEditingController participantController = TextEditingController();
    int? memberCount;

    Future<void> sendSummaryRequest(File file, String clubId, int memberCount) async {
      var uri = Uri.parse('http://momeet.meowning.kr/api/minute/create');

      var request = http.MultipartRequest('POST', uri);
      request.fields['clubId'] = clubId;
      request.fields['num_speakers'] = memberCount.toString();
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          print('✅ 요청 성공 ${response.body}');
        } else {
          print('❌ 요청 실패: ${response.statusCode}');
        }
      } catch (e) {
        print('🔥 요청 중 에러 발생: $e');
      }
    }

    await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("요약"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "현재 파일을 AI요약 하시겠습니까?\n\n요약의 정확도를 높이기 위해, 회의에 참가한 인원을 작성해주세요",
            ),
            const SizedBox(height: 12),
            TextField(
              controller: participantController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '참가 인원 수 입력',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text("취소"),
          ),
          ElevatedButton(
            onPressed: () async {
              final participants = participantController.text.trim();
              final count = int.tryParse(participants);

              if (count == null || count <= 0) {
                // 원래 context를 사용하여 SnackBar 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("참가 인원을 올바르게 입력해주세요.")),
                );
                return;
              }

              memberCount = count;

              await sendSummaryRequest(recordFile, clubId, memberCount!);

              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text("요약하기"),
          ),
        ],
      );
    },
    );

    participantController.dispose();

    print("Dialog 종료 후 참가 인원: $memberCount");
  }
}