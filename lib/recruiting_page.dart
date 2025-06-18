import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:momeet/clubMain_page.dart';
import 'package:momeet/main_page.dart';
import 'package:momeet/recruiting_detail_page.dart';
import 'package:momeet/user_provider.dart';
import 'package:momeet/write_post_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'buildSideMenu.dart';

class RecruitingPage extends StatefulWidget {
  final List<dynamic> promotionClubs;

  const RecruitingPage({Key? key, required this.promotionClubs}) : super(key: key);

  @override
  RecruitingPageState createState() => RecruitingPageState();
}

class RecruitingPageState extends State<RecruitingPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;



    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: null,
      body: Column(
        children: [
          // 상단 고정 헤더
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 20),
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
                  ],
                ),
                const SizedBox(height: 0),
                const Text(
                  '모집 동아리',
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

          Container(height: 1, color: const Color(0xFFE0E0E0)),

          // 스크롤 영역
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.promotionClubs.length,
              itemBuilder: (context, index) {
                final club = widget.promotionClubs[index];

                List<dynamic> date = club['endDate'] as List<dynamic>? ?? [];
                int year = date.length > 0 ? date[0] : 0;
                int month = date.length > 1 ? date[1] : 0;
                int day = date.length > 2 ? date[2] : 0;

                return InkWell(
                  onTap: () {
                    final clubId = club['clubId'];
                    if (club['recruiting'] == true && clubId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecruitingDetailPage(clubId: clubId),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(40), // 터치 반응도 둥글게 맞춰줌
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                club['official'] == true
                                    ? 'https://example.com/default_logo.png'
                                    : 'https://example.com/another_default.png',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  club['category'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  club['clubName'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                year != 0
                                    ? Text(
                                  '마감일: $year년 $month월 $day일',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: club['recruiting'] ? Colors.red : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            club['recruiting'] ? '부원 모집' : '모집 마감',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),


          SizedBox(height: 50),


        ],
      ),
    );
  }
}
