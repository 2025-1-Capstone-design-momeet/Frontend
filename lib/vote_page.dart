import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:momeet/clubMain_page.dart';
import 'package:momeet/http_service.dart';
import 'package:momeet/vote_create_page.dart';
import 'package:momeet/vote_provider.dart';

class VotePage extends StatefulWidget {
  const VotePage({super.key});

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  Set<int> expandedIndexes = {};
  bool isApproved = true;
  List<Vote> votes = [];
  Map<int, int?> selectedOptionIndexes = {};
  String? clubId = "7163f660e44a4a398b28e4653fe35507"; // 나중에 지우삼 ㅇㅇ
  //String? clubId

  @override
  void initState() {
    super.initState();
    fetchVotes();
  }

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndexes.contains(index)) {
        expandedIndexes.remove(index);
      } else {
        expandedIndexes.add(index);
      }
    });
  }

  Future<void> fetchVotes() async {
    final clubData = {
      "clubId": "7163f660e44a4a398b28e4653fe35507"
    };

    try {
      final response = await HttpService().postRequest("vote/getClubVoteList", clubData);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse['success'] == "true") {
          final List data = jsonResponse['data'];
          setState(() {
            votes = data.map((item) => Vote.fromJson(item)).toList();
          });
        } else {
          print("서버 오류: ${jsonResponse['message']}");
        }
      } else {
        print("HTTP 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("예외 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const clubMainPage()),
              );
            },
          ),
        ),
        actions: [
          Row(
            children: [
              const Text(
                '불모지대',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isApproved) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Colors.green, size: 20),
              ],
              const SizedBox(width: 12),
            ],
          )
        ],
        title: const Text(
          "mo.meet",
          style: TextStyle(
            fontFamily: '런드리고딕',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: Text(
                    '투표',
                    style: TextStyle(
                      fontFamily: 'jamsil',
                      fontWeight: FontWeight.w200,
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateVotePage(clubId: clubId!)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black26, thickness: 0.7),
          Expanded(
            child: ListView.builder(
              itemCount: votes.length,
              itemBuilder: (context, index) {
                final vote = votes[index];
                final isExpanded = expandedIndexes.contains(index);

                return GestureDetector(
                  onTap: () => toggleExpanded(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                vote.title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  vote.end ? '마감' : '진행중',
                                  style: TextStyle(
                                    color: vote.end ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down),
                              ],
                            ),
                          ],
                        ),
                        if (isExpanded) const SizedBox(height: 10),
                        if (isExpanded)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vote.content),
                              const SizedBox(height: 10),

                              // payed가 true면 메시지 표시
                              if (vote.payed)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    '정산이 이미 생성되었습니다.',
                                    style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ),

                              if (vote.anonymous)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    '익명 투표입니다. 정산이 불가능합니다.',
                                    style: TextStyle(color: Colors.red, fontSize: 13),
                                  ),
                                ),

                              Column(
                                children: List.generate(vote.voteContents.length, (i) {
                                  final selected = selectedOptionIndexes[index];
                                  final isSelected = selected != null && selected == i;

                                  return GestureDetector(
                                    // payed나 anonymous면 선택 불가
                                    onTap: (vote.anonymous || vote.payed)
                                        ? null
                                        : () {
                                      setState(() {
                                        selectedOptionIndexes[index] = i;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.green[200] : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected ? Colors.green : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(vote.voteContents[i].field),
                                          Row(
                                            children: [
                                              const Icon(Icons.person),
                                              const SizedBox(width: 4),
                                              Text("${vote.voteContents[i].voteNum ?? 0}"),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              if (!vote.anonymous && !vote.payed) ...[
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[200],
                                    ),
                                    onPressed: () {
                                      final selectedIndex = selectedOptionIndexes[index];
                                      if (selectedIndex != null &&
                                          selectedIndex < vote.voteContents.length) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("선택된 항목: ${vote.voteContents[selectedIndex].field}"),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text("정산 하기"),
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    "정산 리스트에 넣을 항목을 선택해주세요",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
