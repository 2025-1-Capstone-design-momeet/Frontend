import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // 추가
import 'dart:io';  // 파일 처리를 위해 추가

import 'package:momeet/board_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'meeting_page.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';


class WritePromotionPostPage extends StatefulWidget {

  final String clubId;

  WritePromotionPostPage({Key? key, required this.clubId}) : super(key: key);
  // const WritePromotionPostPage({super.key});

  @override
  State<WritePromotionPostPage> createState() => _WritePromotionPostPageState();
}

class _WritePromotionPostPageState extends State<WritePromotionPostPage> {
  bool showScript = false; // 스크립트 박스 표시 여부
  bool _isLargeSize = true; // 기본값 210x297
  File? _selectedImage; // 선택한 이미지 파일

  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;


  final TextEditingController _controller = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();

  late String date;
  String? _userId;

  final DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    date = DateTime.now().toIso8601String().split('.').first; // initState에서 초기화
    final user = Provider.of<UserProvider>(context, listen: false);
    _userId = user.userId ?? "";

    if (_userId != null && _userId!.isNotEmpty) {
    } else {
      print("⚠️ 사용자 ID가 없습니다.");
    }

  }

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



  final List<int> years = List.generate(10, (index) => DateTime.now().year + index); // 현재 년도부터 10년
  final List<int> months = List.generate(12, (index) => index + 1);
  List<int> days = [];

  void updateDays() {
    if (selectedYear != null && selectedMonth != null) {
      int lastDay = DateTime(selectedYear!, selectedMonth! + 1, 0).day;
      setState(() {
        days = List.generate(lastDay, (index) => index + 1);
        if (selectedDay != null && selectedDay! > lastDay) {
          selectedDay = null; // 유효하지 않으면 초기화
        }
      });
    }
  }




  Future<void> uploadPost(File postFile) async {
    final uri = Uri.parse("http://momeet.meowning.kr/api/post/write");

    final Map<String, dynamic> postWriteDTO = {
      "clubId": widget.clubId,
      "userId": _userId,
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
        filename: path.basename(postFile.path),
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

      // 한글 깨짐 방지: bodyBytes를 utf8.decode로 변환
      final decodedBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        print("✅ 업로드 성공: $decodedBody");
      } else {
        print("❌ 업로드 실패: ${response.statusCode} $decodedBody");
        print(postWriteDTO);
      }
    } catch (e) {
      print("🚨 에러 발생: $e");
    }
  }



  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    // 이미지 선택 (갤러리)
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: null,
      body: Column(
        children: [
          // 상단 고정 헤더 (기존 코드 유지)
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
                              MaterialPageRoute(builder: (context) => MeetingPage(clubId: widget.clubId)),
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
                // const SizedBox(height: 0),
                Row(
                  children: [
                    const SizedBox(width: 110),
                    Text(
                      '홍보 게시글 작성',
                      style: TextStyle(
                        fontSize: screenSize.width > 600 ? 30 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                      ),
                      child: const Text(
                        '완료',
                        style: TextStyle(
                            color: Color(0xFF858585),
                            fontSize: 20,
                            fontWeight: FontWeight.w400
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

          // 스크롤 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 240, // 720:1080 비율을 유지 (비율만 같으면 됨)
                      height: 360,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFA9A9A9)),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Center(
                        child: Icon(
                          Icons.photo,
                          size: 50,
                          color: Color(0xFFA9A9A9),
                        ),
                      ),
                    ),
                  ),



                  const SizedBox(height: 12), // 체크박스와 제목 사이 간격 조절

                  Container(
                    width: double.infinity,  // 화면 가로 전체 영역 차지
                    padding: const EdgeInsets.symmetric(horizontal: 16), // 좌우 여백 조절 가능
                    child: Row(
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
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      maxLines: null, // 여러 줄 입력 가능하게
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top, // 텍스트 시작 위치를 위쪽으로
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFFD9D9D9), // 기본 테두리 색상 (회색)
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF69B36D), // 포커스 시 테두리 색상 (초록)
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        hintText: '제목을 입력하세요',
                        hintStyle: const TextStyle(color: Color(0xFFA9A9A9)),
                      ),
                    ),
                  ),



                  const SizedBox(height: 20), // 스크롤 하단 여백

                  Container(
                    width: double.infinity,  // 화면 가로 전체 영역 차지
                    padding: const EdgeInsets.symmetric(horizontal: 16), // 좌우 여백 조절 가능
                    child: Row(
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
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      maxLines: null, // 여러 줄 입력 가능하게
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top, // 텍스트 시작 위치를 위쪽으로
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFFD9D9D9), // 기본 테두리 색상 (회색)
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF69B36D), // 포커스 시 테두리 색상 (초록)
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        hintText: '내용을 입력하세요',
                        hintStyle: const TextStyle(color: Color(0xFFA9A9A9)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),


                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(width: 3, height: 20, color: const Color(0xFF68B26C)),
                        const SizedBox(width: 8),
                        const Text('마감 날짜', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Dropdown UI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 년
                      DropdownButton<int>(
                        hint: const Text('년'),
                        value: selectedYear,
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value;
                            updateDays();
                          });
                        },
                        items: years.map((year) {
                          return DropdownMenuItem(value: year, child: Text('$year년'));
                        }).toList(),
                      ),

                      // 월
                      DropdownButton<int>(
                        hint: const Text('월'),
                        value: selectedMonth,
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value;
                            updateDays();
                          });
                        },
                        items: months.map((month) {
                          return DropdownMenuItem(value: month, child: Text('$month월'));
                        }).toList(),
                      ),

                      // 일
                      DropdownButton<int>(
                        hint: const Text('일'),
                        value: selectedDay,
                        onChanged: (value) {
                          setState(() {
                            selectedDay = value;
                          });
                        },
                        items: days.map((day) {
                          return DropdownMenuItem(value: day, child: Text('$day일'));
                        }).toList(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50), // 스크롤 하단 여백
                ],
              ),
            ),
          ),



        ],
      ),
    );
  }
}
