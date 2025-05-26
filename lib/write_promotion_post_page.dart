import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // 추가
import 'dart:io';  // 파일 처리를 위해 추가

import 'package:momeet/board_page.dart';
import 'meeting_page.dart';

void main() {
  runApp(const MaterialApp(home: WritePromotionPostPage()));
}

class WritePromotionPostPage extends StatefulWidget {
  const WritePromotionPostPage({super.key});

  @override
  State<WritePromotionPostPage> createState() => _WritePromotionPostPageState();
}

class _WritePromotionPostPageState extends State<WritePromotionPostPage> {
  bool showScript = false; // 스크립트 박스 표시 여부
  bool _isLargeSize = true; // 기본값 210x297
  File? _selectedImage; // 선택한 이미지 파일

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
                              MaterialPageRoute(builder: (context) => MeetingPage()),
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
                      width: _isLargeSize ? 210 : 240,
                      height: _isLargeSize ? 297 : 160,
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

                  const SizedBox(height: 12),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isLargeSize,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isLargeSize = value ?? true;
                                });
                              },
                              activeColor: Color(0xFF69B36D),
                            ),
                            const Text('210 x 297'),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: !_isLargeSize,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isLargeSize = !(value ?? false);
                                });
                              },
                              activeColor: Color(0xFF69B36D),
                            ),
                            const Text('240 x 160'),
                          ],
                        ),
                      ],
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
