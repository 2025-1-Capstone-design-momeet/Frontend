import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:momeet/clubMain_page.dart';
import 'package:momeet/meeting_detail_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:momeet/summaryDialog.dart';
import 'package:momeet/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;





class MeetingPage extends StatefulWidget {
  final String clubId;

  MeetingPage({Key? key, required this.clubId}) : super(key: key);

  // const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? recordedFilePath;
  bool isRecording = false;
  String _twoDigits(int n) => n.toString().padLeft(2, '0');
  String? uploadedFileName;
  late File recordFile;

  bool isLoading = true;
  List<Map<String, dynamic>> meetingList = [];





  @override
  void initState() {
    super.initState();
    _initRecorder();
    _loadMeeting();
  }

  Future<void> _loadMeeting() async {
    setState(() {
      isLoading = true;
    });
    final meetings = await fetchMeeting();
    setState(() {
      meetingList = meetings;
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> fetchMeeting() async {
    final url = Uri.parse("http://momeet.meowning.kr/api/minute/clubList");
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Flutter App)',
    };

    final body = jsonEncode({
      "clubId": widget.clubId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse['success'] == "true") {
          final List<dynamic> data = jsonResponse['data'];
          print('🎲🎲🎲data: $data');
          return data.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
        } else {
          print("❌ 서버 실패 fetchMeeting: ${jsonResponse['message']}");
        }
      } else {
        print("❌ HTTP 오류 fetchMeeting: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 에러 발생 fetchMeeting: $e");
    }

    return [];
  }


    final club = Provider.of<ClubProvider>(context, listen: false);
    clubId = club.clubId ?? "";
    clubName = club.clubName ?? "";
    official = club.official ?? false;
  }

  Future<String> getPublicMusicDir() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Music/momeet_recordings');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      return directory.path;
    } else if (Platform.isIOS) {
      // iOS는 앱 전용 저장소 사용 권장
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
    // 기타 플랫폼 처리 필요
    return (await getApplicationDocumentsDirectory()).path;
  }

  Future<void> _simulateUpload(String path) async {
    final fileName = path.split('/').last;
    print('자동 업로드 시작: $fileName');

    // 업로드 완료 후 버튼 텍스트 업데이트
    setState(() {
      uploadedFileName = fileName;  // 2. 업로드 파일명 저장
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('녹음 파일 "$fileName" 자동 업로드 완료')),
    );
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();

    var micStatus = await Permission.microphone.request();
    var storageStatus = await Permission.storage.request();

    if (micStatus != PermissionStatus.granted || storageStatus != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('마이크 및 저장소 권한이 필요합니다. 설정에서 권한을 허용해주세요.')),
      );
      return;
    }

    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }


  Future<void> _toggleRecording() async {
    if (!_recorder.isRecording) {
      final now = DateTime.now();
      final formattedDate = '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}'
          '_${_twoDigits(now.hour)}-${_twoDigits(now.minute)}-${_twoDigits(now.second)}';

      final dirPath = await getPublicMusicDir();  // 공개 폴더 경로 받아오기
      final filePath = '$dirPath/momeet_$formattedDate.aac';

      await _recorder.startRecorder(
        toFile: filePath,
        codec: Codec.aacADTS,
      );

      setState(() {
        isRecording = true;
        recordedFilePath = null;
      });

      print('녹음 시작 (공개 저장소): $filePath');
    } else {
      String? path = await _recorder.stopRecorder();

      setState(() {
        isRecording = false;
        recordedFilePath = path;
      });

      print('녹음 중단');
      print('파일 저장됨: $recordedFilePath');

      if (recordedFilePath != null) {
        recordFile = File(recordedFilePath!);
        _simulateUpload(recordedFilePath!);
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final filteredMeetingList = meetingList.where((meeting) {
      final title = meeting['title']?.toString().toLowerCase() ?? '';
      return title.contains(_searchText.toLowerCase());
    }).toList();


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 고정 헤더
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
              color: Colors.white,
              child: Column(
                children: [
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
                                MaterialPageRoute(builder: (context) => clubMainPage(clubId: widget.clubId)),
                              );
                              // Navigator.pop(context);
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
                            clubName,
                            style: TextStyle(fontSize: 18, color: Color(0xFF68B26C)),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.check_box),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  const Text(
                    '회의장',
                    style: TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Color(0xFFE0E0E0), // 조금 더 연한 회색
            ),

            // 스크롤 가능한 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 0),

                    // 회의 + 녹음중
                    Row(
                      children: [
                        const Text(
                          '회의',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: _toggleRecording,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6), // 크기 조절
                            side: BorderSide(
                              color: isRecording ? Colors.red : const Color(0xFF68B26C),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          icon: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            color: isRecording ? Colors.red : const Color(0xFF68B26C),
                            size: 18, // 아이콘 크기도 살짝 줄임 (선택 사항)
                          ),
                          label: Text(
                            isRecording ? '중단' : '녹음',
                            style: TextStyle(
                              color: isRecording ? Colors.red : const Color(0xFF68B26C),
                              fontSize: 13, // 글자 크기도 조금 축소 (선택 사항)
                            ),
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 24),

                    // 버튼 2개
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // 파일 선택 다이얼로그 열기
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,      // 커스텀 확장자 제한
                                allowedExtensions: ['aac'], // wav 확장자만 허용
                              );


                              if (result != null && result.files.isNotEmpty) {
                                // 선택한 파일의 이름을 저장하는 로직 (setState 필요)
                                setState(() {
                                  uploadedFileName = result.files.single.name;
                                  // 여기서 파일 경로나 데이터도 저장 가능
                                });
                                // 파일 업로드 자동 처리할 함수 호출 가능
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              backgroundColor: const Color(0xFFFBFBFB),
                              elevation: 2,
                              shadowColor: Colors.grey.withOpacity(0.7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (uploadedFileName == null) ...const [
                                  const Icon(Icons.file_upload, color: Color(0xFF9F9F9F)),
                                  const SizedBox(width: 8),
                                ],
                                Flexible(
                                  child: Text(
                                    uploadedFileName ?? '파일 업로드',
                                    style: const TextStyle(color: Color(0xFF9F9F9F)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            if (uploadedFileName == null) {
                              // 파일이 없을 때 메시지 띄우고 동작 중지
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('현재 올라온 파일이 없습니다'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return; // 함수 종료
                            }
                            // 파일이 있을 때만 팝업창 호출
                            SummaryDialog.show(
                                context,
                                recordFile: recordFile,
                                clubId: widget.clubId

                            );
                          },
                          label: const Text('요약', style: TextStyle(color: Color(0xFF68B26C))),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            side: const BorderSide(color: Color(0xFF68B26C)),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 9),
                        const Text('파일 확장자는 wav로 제한되어있습니다.', style: TextStyle(color: Color(0xFFB2B2B2), fontSize: 10)),

                      ],
                    ),
                    const SizedBox(height: 32),



                    // 검색창
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: '회의록 검색',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF69B36D),
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // 3️⃣ 필터링된 리스트로 카드 출력
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredMeetingList.length,
                      itemBuilder: (context, index) {
                        final meeting = filteredMeetingList[index];

                        // 날짜 변환
                        final List<dynamic> dateArray = meeting['date'];
                        final dateTime = DateTime(
                          dateArray[0], dateArray[1], dateArray[2],
                          dateArray[3], dateArray[4], dateArray[5],
                        );
                        final formattedDate = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
                            "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

                        return _buildMemoCard(
                          formattedDate,
                          meeting['title'] ?? '',
                          meeting['minuteId'] ?? '',
                          MediaQuery.of(context).size.width > 600,
                        );
                      },
                    ),


                    const SizedBox(height: 10),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoCard(String date, String content, String meetingId, bool isLargeScreen) {
    print('➡️➡️➡️$meetingId');
    return GestureDetector(
      onTap: () {
        // MemoDetailPage로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeetingDetailPage(meetingId: meetingId,),

          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                content,
                style: TextStyle(
                  fontSize: isLargeScreen ? 20 : 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
