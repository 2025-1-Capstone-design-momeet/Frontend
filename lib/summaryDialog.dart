import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SummaryDialog {
  static Future<void> show(BuildContext context,
      {required File recordFile, required String clubId}) async {
    final TextEditingController participantController = TextEditingController();
    int? memberCount; // null 허용

    Future<void> sendSummaryRequest(File file, String clubId, int memberCount) async {
      var uri = Uri.parse('http://momeet.meowning.kr/api/minute/create'); // 실제 API 주소로 바꾸세요

      var request = http.MultipartRequest('POST', uri);
      request.fields['clubId'] = clubId;
      request.fields['num_speakers'] = memberCount.toString();
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          print('요청 성공');
        } else {
          print('요청 실패: ${response.statusCode}');
        }
      } catch (e) {
        print('요청 중 에러 발생: $e');
      }
    }

    await showDialog(
      context: context,
      builder: (context) {
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
                Navigator.of(context).pop(); // 닫기
              },
              child: const Text("취소"),
            ),
            ElevatedButton(
              onPressed: () async {
                final participants = participantController.text;
                memberCount = int.tryParse(participants) ?? 0; // 저장
                print("참가 인원: $memberCount");

                // 서버에 POST 요청 보내기
                await sendSummaryRequest(recordFile, clubId, memberCount!);

                Navigator.of(context).pop(memberCount); // 다이얼로그 닫기
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