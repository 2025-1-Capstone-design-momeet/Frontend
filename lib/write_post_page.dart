import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:momeet/write_promotion_post_page.dart';
import 'meeting_page.dart';

void main() {
  runApp(MaterialApp(home: WritePostPage()));
}

class WritePostPage extends StatefulWidget {
  WritePostPage({super.key});

  @override
  State<WritePostPage> createState() => _WritePostPageState();
  String? selectedFileName; // 이걸 State 클래스 안에 추가해야 함 (예: _WritePostPageState 안)

}

class _WritePostPageState extends State<WritePostPage> {
  bool showScript = false;
  bool isChecked = false;

  String? selectedFileName;
  final TextEditingController fileNameController = TextEditingController();

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
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        // padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
                    child: TextField(
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
                          setState(() {
                            selectedFileName = result.files.first.name;
                            fileNameController.text = selectedFileName!;
                          });
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
                            overflow: TextOverflow.ellipsis, // 말줄임 설정
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
                      maxLines: null, // 여러 줄 입력 가능하게
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top, // 텍스트 시작 위치를 위쪽으로
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // 너무 크던 세로 패딩 줄임
                        hintText: '내용을 입력하세요',
                        hintStyle: const TextStyle(color: Color(0xFFA9A9A9)),
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
