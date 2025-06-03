import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:momeet/calculate_member_page.dart';
import 'package:momeet/clubMain_page.dart';
import 'package:momeet/http_service.dart';
import 'package:momeet/user_provider.dart';
import 'package:momeet/vote_create_page.dart';
import 'package:momeet/vote_provider.dart';
import 'package:provider/provider.dart';
import 'package:momeet/club_provider.dart';

class VotePage extends StatefulWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  Set<int> expandedIndexes = {};
  bool isApproved = true;
  List<Vote> votes = [];
  Map<int, int?> selectedOptionIndexes = {};
  String? userId;
  late String clubId;
  late String clubName;
  late bool official;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(
        context, listen: false); // listen: false로 값을 가져옴
    userId = user.userId ?? "";

    final club = Provider.of<ClubProvider>(context, listen: false);
    clubId = club.clubId ?? "";
    clubName = club.clubName ?? "";
    official = club.official ?? false;

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
      "clubId": clubId
    };

    try {
      final response = await HttpService().postRequest("vote/getClubVoteList", clubData);
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse['success'] == "true") {
          final List data = jsonResponse['data'];
          final fetchedVotes = data.map((item) => Vote.fromJson(item)).toList();

          setState(() {
            votes = fetchedVotes;
          });

          // 각 투표에 대해 state() 호출
          for (int i = 0; i < fetchedVotes.length; i++) {
            print("state() 호출: voteID=${fetchedVotes[i].voteID}");
            state(fetchedVotes[i].voteID, i);
          }

        } else {
          print("서버 오류: ${jsonResponse['message']}");
        }
      } else {
        print("HTTP 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("fetch 예외 발생: $e");
    }
  }

  Future<void> submit(String voteID, String voteContentId,int voteNum) async {
    final data = {
      "userId": userId,
      "voteID": voteID,
      "voteContentId": voteContentId,
      "voteNum": voteNum
    };

    print(data);

    try {
      final response = await HttpService().postRequest("vote/vote", data);

      if(response.statusCode == 200) {
        print("투표 완~");
        await fetchVotes();
      }

    } catch (e) {
      print("submit 예외 발생: $e");
    }
  }

  Future<void> state(String voteID, int index) async {
    final data = {
      "userId": userId,
      "voteID": voteID,
      "voteNum": null
    };

    try {
      final response = await HttpService().postRequest("vote/voteState", data);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse["success"] == "true" && jsonResponse["data"] != null) {
          final int voteNum = jsonResponse["data"]["voteNum"];
          setState(() {
            selectedOptionIndexes[index] = voteNum;
          });
        } else {
          // 아직 투표 안 했을 수도 있음, 이 경우 아무것도 안 함
          print("투표 안함 또는 데이터 없음: ${jsonResponse["data"]}");
        }
      }
    } catch (e) {
      print("state 예외 발생: $e");
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
                MaterialPageRoute(builder: (context) => clubMainPage(clubId: clubId,)),
              );
            },
          ),
        ),
        actions: [
          Row(
            children: [
              Text(
                clubName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (official) ...[
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
                        MaterialPageRoute(builder: (context) => CreateVotePage(clubId: clubId)),
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
                final sortedContents = [...vote.voteContents]
                  ..sort((a, b) => (a.voteNum ?? 0).compareTo(b.voteNum ?? 0)); // 내림차순 정렬


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


                              // 투표 항목 리스트
                              Column(
                                children: List.generate(sortedContents.length, (i) {
                                  final selected = selectedOptionIndexes[index];
                                  final isSelected = selected != null && selected == i;

                                  return GestureDetector(
                                    onTap: vote.payed ? null : () {
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
                                          Text(sortedContents[i].field),
                                          Row(
                                            children: [
                                              const Icon(Icons.person),
                                              const SizedBox(width: 4),
                                              Text("${sortedContents[i].voteContentNum ?? 0}"),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              if (!vote.end && !vote.payed) ...[
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      final selectedIndex = selectedOptionIndexes[index];
                                      if (selectedIndex == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("항목을 선택해주세요.")),
                                        );
                                        return;
                                      }
                                      final selectedContent = vote.voteContents[selectedIndex];
                                      submit(vote.voteID, selectedContent.voteContentID,selectedIndex);
                                    },
                                    child: const Text("투표하기", style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],

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
                                      if (selectedIndex != null && selectedIndex < vote.voteContents.length) {
                                        final selectedContent = vote.voteContents[selectedIndex];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) => CalculateMembersPage(
                                              voteID: vote.voteID, // 투표 ID
                                              voteContentId: selectedContent.voteContentID, // 선택된 항목의 ID
                                            ),
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
