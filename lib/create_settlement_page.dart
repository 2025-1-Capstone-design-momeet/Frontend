import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 금액 포맷용

class CreateSettlementPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedMembers;

  const CreateSettlementPage({
    super.key,
    required this.selectedMembers,
  });

  @override
  State<CreateSettlementPage> createState() => _CreateSettlementPageState();
}

class _CreateSettlementPageState extends State<CreateSettlementPage> {
  int _remainingAmount = 0; // 나머지 금액 변수 추가
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _peopleCountController = TextEditingController();
  int _calculatedAmount = 0;
  bool _isChecked = false;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  // final TextEditingController _amountController = TextEditingController();
  bool _isValid = false;
  bool _isAccountValid = false;
  bool _isAmountValid = false;

  bool _isButtonEnabled = false; // 버튼 활성화 여부


  // 포맷된 문자열을 숫자로 바꾸는 함수
  int _parseFormattedNumber(String formattedText) {
    return int.tryParse(formattedText.replaceAll(',', '')) ?? 0;
  }

  void _calculateSettlement() {
    final total = _parseFormattedNumber(_totalAmountController.text);
    final count = int.tryParse(_peopleCountController.text) ?? 0;

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
  void initState() {
    super.initState();

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

    _peopleCountController.addListener(() {
      _calculateSettlement(); // 인원수 입력 시마다 자동 계산
    });
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _peopleCountController.dispose();
    _controller.dispose();
    _accountController.dispose();
    // _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final formatter = NumberFormat('#,###');

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
                    onChanged: _validateInput,
                    decoration: InputDecoration(
                      hintText: 'ex> 개강 파티, MT 회비',
                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                      suffixIcon: _isValid
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
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
                  const SizedBox(height: 4),

                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _accountController,
                    onChanged: _validateAccountInput,
                    decoration: InputDecoration(
                      hintText: 'ex> 모밋은행 123-4567-8910-11',
                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                      suffixIcon: _isAccountValid
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
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
                      suffixIcon: _isAmountValid
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
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
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(40),
                      // border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.black54),
                            const SizedBox(width: 6),
                            IntrinsicWidth(
                              child: TextField(
                                controller: _peopleCountController,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  hintText: '30',
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
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
                        SizedBox(width: 0)
                      ],
                    ),
                  ),

                  if (_remainingAmount > 0) ...[
                    SizedBox(
                      width: double.infinity,  // 가로 전체 꽉 채우기
                      height: 150,             // 적당한 높이 지정(필요시 조정)
                      child: Center(           // 가로/세로 완전 중앙 정렬
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${_remainingAmount}원이 남게 돼요!',
                              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '남은 $_remainingAmount원은 정산 처리되지 않습니다.',
                              style: const TextStyle(color: Colors.red, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              '(정산자 부담)',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 체크박스 대신 Icon + GestureDetector로 직접 만드는 방법도 있지만
                                // 여기서는 Checkbox 위젯 사용 (원한다면 Icon으로 커스텀 가능)
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
                            // const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                  // const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isChecked
                          ? () {
                        // 정산 요청 처리 로직
                      }
                          : null,  // 체크 안 되면 버튼 비활성화
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _isChecked ? const Color(0xFF69B36D) : Colors.grey[400],
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
