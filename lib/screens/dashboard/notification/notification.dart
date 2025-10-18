import 'package:admin/blocs/notification/notification_bloc.dart';
import 'package:admin/blocs/notification/notification_event.dart';
import 'package:admin/blocs/notification/notification_state.dart';
import 'package:admin/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  final TextEditingController headerCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();

  int contentLength = 0;
  List<Map<String, String>> todayNotifications = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSavedNotifications();

    contentCtrl.addListener(() {
      setState(() {
        contentLength = contentCtrl.text.length;
      });
    });
  }

  // 🔹 Load saved messages from SharedPreferences
  Future<void> _loadSavedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('todayNotifications');
    if (savedData != null) {
      final List decoded = jsonDecode(savedData);
      setState(() {
        todayNotifications =
            decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    }
  }

  // 🔹 Save messages to SharedPreferences
  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('todayNotifications', jsonEncode(todayNotifications));
  }

  @override
  void dispose() {
    _tabController.dispose();
    headerCtrl.dispose();
    contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FD),
      appBar: AppBar(
        title: const Text("Notifications", style: ThemeText.titleLarge),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Appcolors.buttoncolor,
          indicatorWeight: 3,
          labelColor: Appcolors.buttoncolor,
          unselectedLabelColor: Colors.black54,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "Send All"),
            //  Tab(text: "Send Specific"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSendAll(), _buildSendSpecific()],
      ),
    );
  }

  /// -------------------- SEND ALL TAB --------------------
  Widget _buildSendAll() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _messageCard(),
          const SizedBox(height: 24),
          const Text(
            "Today Notification",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          Column(
            children:
                todayNotifications
                    .map(
                      (n) => notificationItem(
                        title: n["title"]!,
                        subtitle: n["subtitle"]!,
                        time: n["time"]!,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  /// -------------------- SEND SPECIFIC TAB --------------------
  Widget _buildSendSpecific() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _messageCard(),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              "Here you can send notifications to specific users.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------- MESSAGE INPUT CARD --------------------
  Widget _messageCard() {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Notification Sent Successfully!")),
          );
          setState(() {
            final now = TimeOfDay.now();
            final formattedTime =
                "${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}";

            todayNotifications.insert(0, {
              "title": headerCtrl.text,
              "subtitle": contentCtrl.text,
              "time": formattedTime,
            });

            if (todayNotifications.length > 3) {
              todayNotifications.removeLast();
            }

            contentLength = 0;
          });

          _saveNotifications(); // 🔹 save locally

          headerCtrl.clear();
          contentCtrl.clear();
        } else if (state is NotificationFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(" ${state.error}")));
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: headerCtrl,
                decoration: InputDecoration(
                  hintText: "Title",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Content",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentCtrl,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: "Content",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  counterText: "$contentLength/200",
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed:
                        state is NotificationLoading
                            ? null
                            : () {
                              if (headerCtrl.text.isNotEmpty &&
                                  contentCtrl.text.isNotEmpty) {
                                context.read<NotificationBloc>().add(
                                  SendNotificationEvent(
                                    cHeader: headerCtrl.text,
                                    cDescription: contentCtrl.text,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please enter title & content",
                                    ),
                                  ),
                                );
                              }
                            },
                    icon:
                        state is NotificationLoading
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Icon(
                              Icons.send,
                              size: 16,
                              color: Colors.white,
                            ),
                    label:
                        state is NotificationLoading
                            ? const SizedBox.shrink()
                            : const Text("Send"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.buttoncolor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// -------------------- NOTIFICATION ITEM --------------------
  Widget notificationItem({
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              color: Color(0xFF34D399),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "($time)",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
