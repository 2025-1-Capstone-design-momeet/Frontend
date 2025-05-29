import 'package:flutter/material.dart';

class CreateVotePage extends StatefulWidget {
  const CreateVotePage({super.key});

  @override
  State<CreateVotePage> createState() => _CreateVotePageState();
}

class _CreateVotePageState extends State<CreateVotePage> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(text: '너가 행복하길 바랬는데'),
    TextEditingController(text: '정작 니가 행복해지니까'),
    TextEditingController(text: '내 기분이 참 이상해지더라'),
  ];

  bool noDeadline = false;
  bool multipleChoice = false;
  bool anonymousVote = false;

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    setState(() {
      _optionControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("투표", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Center(
                child: Text("C.O.K",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold))),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.check_box, color: Colors.green),
          )
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: '투표 내용을 입력해주세요',
                border: OutlineInputBorder(),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text("투표 종료 날짜를 입력해주세요.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Checkbox(
                        value: noDeadline,
                        onChanged: (val) =>
                            setState(() => noDeadline = val ?? false),
                      ),
                      const Text("날짜 없음"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._optionControllers.asMap().entries.map(
                        (entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFEFEFEF),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeOption(index),
                            icon: const Icon(Icons.close),
                          )
                        ],
                      );
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[400]),
                    onPressed: _addOption,
                    child: const Text("+ 항목 추가",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: multipleChoice,
                        onChanged: (val) =>
                            setState(() => multipleChoice = val ?? false),
                      ),
                      const Text("복수 선택"),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: anonymousVote,
                        onChanged: (val) =>
                            setState(() => anonymousVote = val ?? false),
                      ),
                      const Text("익명 투표"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
