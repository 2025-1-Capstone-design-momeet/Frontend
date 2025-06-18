import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // 추가
import 'dart:io';  // 파일 처리를 위해 추가

import 'package:momeet/board_page.dart';
import 'package:momeet/main_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'meeting_page.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // inputFormatters를 위해 필요



class WritePromotionPostPage extends StatefulWidget {

  final String clubId;

  WritePromotionPostPage({Key? key, required this.clubId}) : super(key: key);
  // const WritePromotionPostPage({super.key});

  @override
  State<WritePromotionPostPage> createState() => _WritePromotionPostPageState();
}

class _WritePromotionPostPageState extends State<WritePromotionPostPage> {
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _duesController = TextEditingController();


  bool showScript = false; // 스크립트 박스 표시 여부
  bool _isLargeSize = true; // 기본값 210x297
  File? _selectedImage; // 선택한 이미지 파일

  String target = '';
  bool interview = false;
  DateTime? endDate;
  bool isRecruiting = false;
  int? dues;


  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;


  final TextEditingController _controller = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();

  late String date;
  String? _userId;

  final DateTime now = DateTime.now();

  void _updateEndDate() {
    if (selectedYear != null && selectedMonth != null && selectedDay != null) {
      endDate = DateTime(selectedYear!, selectedMonth!, selectedDay!);
    } else {
      endDate = null;
    }
  }

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




  Future<void> uploadPost() async {
    final uri = Uri.parse("http://momeet.meowning.kr/api/club/promotion/write");

    // 보낼 데이터 JSON으로 만듦
    final body = jsonEncode({
      "clubId": widget.clubId,
      "target": target,
      "dues": dues ?? 0,
      "interview": interview,
      "endDate": endDate?.toIso8601String(),
      "isRecruiting": isRecruiting,
    });

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body, // JSON 인코딩해서 문자열로 보냄
      );

      if (response.statusCode >= 200 || response.statusCode < 200 ) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        print("✅ 업로드 성공: $decoded");
      } else {
        final decoded = utf8.decode(response.bodyBytes);
        print("❌ 업로드 실패: ${response.statusCode} $decoded");
        print(body);
      }
    } catch (e) {
      print("🚨 에러 발생: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
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
                              MaterialPageRoute(builder: (context) => MainPage()),
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
                      '모집 게시글 작성',
                      style: TextStyle(
                        fontSize: screenSize.width > 600 ? 30 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),
                    TextButton(
                      onPressed: () async {
                        if (target.isEmpty || dues == null || endDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('모든 필드를 정확히 입력해주세요')),
                          );
                          return;
                        }
                        await uploadPost();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                      ),
                      child: const Text(
                        '완료',
                        style: TextStyle(
                            color: Color(0xFF858585),
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
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
                  // GestureDetector(
                  //   onTap: _pickImage,
                  //   child: Container(
                  //     width: 240, // 720:1080 비율을 유지 (비율만 같으면 됨)
                  //     height: 360,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: const Color(0xFFA9A9A9)),
                  //       borderRadius: BorderRadius.circular(8),
                  //       color: Colors.white,
                  //     ),
                  //     child: _selectedImage != null
                  //         ? ClipRRect(
                  //       borderRadius: BorderRadius.circular(8),
                  //       child: Image.file(
                  //         _selectedImage!,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     )
                  //         : const Center(
                  //       child: Icon(
                  //         Icons.photo,
                  //         size: 50,
                  //         color: Color(0xFFA9A9A9),
                  //       ),
                  //     ),
                  //   ),
                  // ),



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
                          '대상자',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _targetController,  // 컨트롤러 연결
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFFD9D9D9),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF69B36D),
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        hintText: '대상자를 입력하세요',
                        hintStyle: const TextStyle(color: Color(0xFFA9A9A9)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          target = value;  // 입력값을 target에 저장
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),

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
                          '가입비',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFFD9D9D9),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF69B36D),
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        hintText: '가입비를 입력하세요',
                        hintStyle: const TextStyle(color: Color(0xFFA9A9A9)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          dues = int.tryParse(value);
                        });
                      },
                    ),
                  ),


                  const SizedBox(height: 20), // 스크롤 하단 여백

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 3,
                          height: 20,
                          color: const Color(0xFF68B26C),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '면접 여부',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 4), // 글자와 체크박스 사이 약간의 간격
                        Checkbox(
                          value: interview,
                          onChanged: (bool? newValue) {
                            setState(() {
                              interview = newValue ?? false;
                            });
                          },
                          activeColor: const Color(0xFF68B26C),
                        ),
                      ],
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
                            _updateEndDate();
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
                            _updateEndDate();
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
                            _updateEndDate();
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
