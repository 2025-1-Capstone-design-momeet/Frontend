import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momeet/settlement_president_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:momeet/club_provider.dart';
import 'package:momeet/http_service.dart'; // 금액 포맷용

class CreateSettlementPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedMembers;
  final String voteID;

  const CreateSettlementPage({
    super.key,
    required this.selectedMembers,
    required this.voteID,
  });

  @override
  State<CreateSettlementPage> createState() => _CreateSettlementPageState();
}

class _CreateSettlementPageState extends State<CreateSettlementPage> {
  final TextEditingController _memberCountController = TextEditingController();
  int _remainingAmount = 0; // 나머지 금액 변수 추가
  final TextEditingController _totalAmountController = TextEditingController();
  int _calculatedAmount = 0;
  bool _isChecked = false;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  bool _isValid = false;
  bool _isAccountValid = false;
  bool _isAmountValid = false;
  bool _isButtonEnabled = false; // 버튼 활성화 여부

  String? userId;
  String? clubId;

  @override
  void initState() {
    super.initState();

    final user = Provider.of<UserProvider>(context, listen: false);
    userId = user.userId ?? "";

    final club = Provider.of<ClubProvider>(context, listen: false);
    clubId = club.clubId ?? "";

    _memberCountController.text = widget.selectedMembers.length.toString();

    _totalAmountController.addListener(() {
      final text = _totalAmountController.text.replaceAll(',', '');
      if (text.isEmpty) return;

      final number = int.tryParse(text);
      if (number != null) {
        final formatted = NumberFormat('#,###').format(number);
        if (formatted != _totalAmountController.text) {
          _totalAmountController.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
        _calculateSettlement(); // 금액 입력 시마다 자동 계산
      }
    });
  }

  Future<void> create() async {
    final title = _controller.text.trim();
    final amount = _parseFormattedNumber(_totalAmountController.text);
    final account = _accountController.text.trim();
    final paymentMembers = widget.selectedMembers.map((member) => member['userId']).toList();

    final data = {
      "userId": "gam1017",
      "voteID": widget.voteID,
      "clubId": "7163f660e44a4a398b28e4653fe35507",
      "title": title,
      "amount": amount,
      "account": account,
      "paymentMembers": paymentMembers
    };
    print(data);
    try {
      final response = await HttpService().postRequest("pay/write", data);

      final responseData = jsonDecode(response.body);
      if (responseData['success'] == "true") {
        // 성공 처리
        _showDialog("성공", responseData['message']);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SettlementPresidentPage(clubId: "7163f660e44a4a398b28e4653fe35507")),
        );
      } else {
        // 실패 처리
        _showDialog("오류", responseData['message'] ?? "알 수 없는 오류가 발생했습니다.");
      }
    } catch (e) {
      _showDialog("네트워크 오류", "네트워크 오류가 발생했습니다.");
      print("Error: $e");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  // 포맷된 문자열을 숫자로 바꾸는 함수
  int _parseFormattedNumber(String formattedText) {
    return int.tryParse(formattedText.replaceAll(',', '')) ?? 0;
  }

  void _calculateSettlement() {
    final total = _parseFormattedNumber(_totalAmountController.text);
    final count = widget.selectedMembers.length;

    if (total > 0 && count > 0) {
      setState(() {
        _calculatedAmount = total ~/ count;
        _remainingAmount = total % count;
        _isButtonEnabled = _remainingAmount == 0; // 나머지 금액이 0이면 버튼 활성화
      });
    } else {
      setState(() {
        _calculatedAmount = 0;
        _remainingAmount = 0;
        _isButtonEnabled = false;
      });
    }
  }

  void _validateInput(String value) {
    setState(() {
      _isValid = value.trim().isNotEmpty; // 입력이 있으면 true, 없으면 false
    });
  }

  void _validateAccountInput(String value) {
    setState(() {
      _isAccountValid = value.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _controller.dispose();
    _accountController.dispose();
    // _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final formatter = NumberFormat('#,###');

    final showRemainingSection = _remainingAmount > 0;
    final isFormValid = (showRemainingSection ? _isChecked : true) &&
        _isValid &&
        _isAccountValid &&
        _isAmountValid;

    return Scaffold(
      backgroundColor: Colors.white,
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
                            Navigator.pop(context);
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
                Text(
                  '정산 정보 입력',
                  style: TextStyle(
                    fontSize: screenSize.width > 600 ? 30 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: const Color(0xFFE0E0E0)),

          // 본문 스크롤 가능 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  const Text('이번 정산의 제목을 붙여주세요!', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _controller,
                    onChanged: (value) {
                      _validateInput(value);
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'ex> 개강 파티, MT 회비',
                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                      suffixIcon: _isValid ? const Icon(Icons.check, color: Colors.green) : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _isValid ? Colors.green : Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _isValid ? Colors.green : Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('어느 계좌로 정산받으시나요?', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _accountController,
                    onChanged: (value) {
                      _validateAccountInput(value);
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'ex> 모밋은행 123-4567-8910-11',
                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                      suffixIcon: _isAccountValid ? const Icon(Icons.check, color: Colors.green) : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _isAccountValid ? Colors.green : Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _isAccountValid ? Colors.green : Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '현재 작성하신 내용 그대로 전달됩니다. 정확하게 입력해주세요!',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  const Text('전체 금액은 얼마인가요?', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _totalAmountController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        final amount = _parseFormattedNumber(value);
                        _isAmountValid = amount > 0;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '입력 금액은 인원만큼 분배됩니다.',
                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                      suffixIcon: _isAmountValid ? const Icon(Icons.check, color: Colors.green) : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _isAmountValid ? Colors.green : Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _isAmountValid ? Colors.green : Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text('다음과 같이 정산이 요청됩니다.'),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.black54),
                            const SizedBox(width: 6),
                            IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _memberCountController.text,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text('명', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ],
                        ),
                        SizedBox(width: 120),
                        Text(
                          '${formatter.format(_calculatedAmount)} 원',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  if (showRemainingSection)
                    SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_remainingAmount}원이 남게 돼요!',
                              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '남은 $_remainingAmount원은 정산 처리되지 않습니다.',
                              style: const TextStyle(color: Colors.red, fontSize: 14),
                            ),
                            const Text(
                              '(정산자 부담)',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                                const SizedBox(width: 3),
                                const Text('괜찮습니다.'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isFormValid ? create : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormValid ? const Color(0xFF69B36D) : Colors.grey[400],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        '정산 요청하기',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
