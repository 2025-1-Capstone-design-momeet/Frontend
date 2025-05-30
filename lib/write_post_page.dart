import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:momeet/write_promotion_post_page.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';


import 'meeting_page.dart';

void main() {
  runApp(MaterialApp(home: WritePostPage()));
}

class WritePostPage extends StatefulWidget {
  WritePostPage({super.key});
  late String date;

  @override
  State<WritePostPage> createState() => _WritePostPageState();
  String? selectedFileName; // 이걸 State 클래스 안에 추가해야 함 (예: _WritePostPageState 안)

}

class _WritePostPageState extends State<WritePostPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();

  late String date;

  final DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    date = DateTime.now().toIso8601String().split('.').first; // initState에서 초기화
  }


  bool showScript = false;


  String? _title;
  String? _content;
  File? postFile;
  bool isChecked = false;

  String? selectedFileName;

  @override
  void dispose() {
    _controller.dispose(); // 메모리 누수 방지
    _contentController.dispose();
    fileNameController.dispose();
    super.dispose();
  }



  Future<void> uploadPost(File postFile) async {
    final uri = Uri.parse("http://momeet.meowning.kr/api/post/write");

    final Map<String, dynamic> postWriteDTO = {
      "clubId": "7163f660e44a4a398b28e4653fe35507",
      "userId": "gam1017",
      "title": _title ?? "",
      "content": _content ?? "",
      "type": 0,
      "like": 0,
      "fixation": isChecked ? 1 : 0,
      "date": DateTime.now().toIso8601String().split('.').first
    };

    final request = http.MultipartRequest('POST', uri);

    // 이미지 파일 추가
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        postFile.path,
        filename: basename(postFile.path),
      ),
    );

    // JSON 데이터 MultipartFile로 추가하면서 content-type 지정
    request.files.add(
      http.MultipartFile.fromString(
        'postWriteDTO',
        jsonEncode(postWriteDTO),
        contentType: MediaType('application', 'json'),
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("✅ 업로드 성공: ${response.body}");
      } else {
        print("❌ 업로드 실패: ${response.statusCode} ${response.body}");
        print(postWriteDTO);
      }
    } catch (e) {
      print("🚨 에러 발생: $e");
    }
  }






  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(

      backgroundColor: const Color(0xFFFFFFFF),
      appBar: null,

      body: Column(
        children: [
          // 상단 고정 헤더


          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WritePromotionPostPage()),
                            );
                          },
                        ),
                        const SizedBox(width: 0),
                        Text(
                          'mo.meet',
                          style: TextStyle(
                            fontSize: screenSize.width > 600 ? 30 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'C.O.K',
                          style: TextStyle(fontSize: 18, color: Color(0xFF68B26C)),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.check_box),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 0),
                Row(
                  children: [
                    const SizedBox(width: 130),
                    Text(
                      '게시글 작성',
                      style: TextStyle(
                        // color: Color(0xFF69B36D),
                        fontSize: screenSize.width > 600 ? 30 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 60),
                    TextButton(
                      onPressed: () {
                        if (postFile != null) {
                          uploadPost(postFile!);
                        } else {
                          print("❗ 첨부파일이 없습니다.");
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('첨부파일을 선택해주세요')));
                        }
                      },
                      child: const Text(
                        '완료',
                        style: TextStyle(
                          color: Color(0xFF858585),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: const Color(0xFFE0E0E0),
          ),

          // Container(height: 1, color: const Color(0xFFE0E0E0)),

          // 스크롤 영역
          Expanded(

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(-15, -10), // 왼쪽(-X)으로 4, 위쪽(-Y)으로 4픽셀 이동
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isChecked = newValue ?? false;
                            });
                          },
                          activeColor: Color(0xFF69B36D),
                        ),
                        const Text(
                          '핀 고정',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF777777)),
                        ),
                      ],
                    ),
                  ),



                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 3,
                        height: 20,
                        color: const Color(0xFF68B26C),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '제목',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child:  TextField(
                      controller: _controller,
                      onChanged: (value) {
                        setState(() {
                          _title = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFFA9A9A9), // 테두리 색상
                            width: 5.0, // 테두리 두께
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        hintText: '제목을 입력하세요',
                        hintStyle: const TextStyle(color: Color(0xFFA9A9A9)),
                      ),
                    ),
                  ),


                  const SizedBox(height: 15),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 3,
                        height: 20,
                        color: const Color(0xFF68B26C),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '파일',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();

                        if (result != null && result.files.isNotEmpty) {
                          String? path = result.files.first.path;
                          if (path != null) {
                            setState(() {
                              selectedFileName = result.files.first.name;
                              fileNameController.text = selectedFileName!;
                              postFile = File(path); // 📌 실제 File 객체 저장
                            });
                          }
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          readOnly: true,
                          controller: fileNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            hintText: '첨부파일 없음',
                            hintStyle: const TextStyle(color: Color(0xFFA9A9A9)),
                            suffixIcon: const Icon(Icons.attach_file),
                          ),
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 3,
                        height: 20,
                        color: const Color(0xFF68B26C),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '내용',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _contentController,
                      onChanged: (value) {
                        setState(() {
                          _content = value;
                        });
                      },
                      maxLines: null, // 여러 줄 입력 가능하게
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top, // 텍스트 시작 위치를 위쪽으로
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        hintText: '내용을 입력하세요',
                        hintStyle: TextStyle(color: Color(0xFFA9A9A9)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
