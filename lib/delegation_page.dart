import 'package:flutter/material.dart';

class DelegationPage extends StatefulWidget {
  @override
  _DelegationPageState createState() => _DelegationPageState();
}

class _DelegationPageState extends State<DelegationPage> {
  final String name = "강채희";
  final String major = "소프트웨어전공";
  final String studentId = "20220031";
  final String grade = "4학년";
  final String reason =
      "너무 재밌을 것 같아서 신청합니다.\n저는 진짜 이런게 너무 맘에 들거든요?\n저 좀 붙여주세요;;";
  final String activities = "랩, 댄스, 노래, 기선제압하기";

  bool _isChecked = false;  // 상태 변수로 옮김

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("직무 위임", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            CircleAvatar(radius: 50, backgroundColor: Colors.grey),
            SizedBox(height: 8),
            Text(grade, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(major, style: TextStyle(fontSize: 16, color: Colors.grey)),
            Text(studentId, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "간부",
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 24),

            SizedBox(height: 40),
            Text(
              "위 학생에게 현재 직무를 위임하겠습니까?",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF939393)),
            ),
            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "현재 직무 :",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFB1B1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "회장",
                    style: TextStyle(
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Text(
              "직무를 위임하면, 현 직무의 모든 권한을 잃습니다.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "이에 동의합니다.",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    checkboxTheme: CheckboxThemeData(
                      side: BorderSide(color: Colors.grey, width: 1.5), // 얇은 회색 테두리
                    ),
                  ),
                  child: Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ],
            ),


            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isChecked ? () {
                    // 승인 동작 처리
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isChecked ? Color(0xFF69B36D) : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text("승인", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),

            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 20, color: Colors.green),
            SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(content, style: TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
