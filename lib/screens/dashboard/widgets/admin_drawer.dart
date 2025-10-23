import 'package:admin/blocs/auth/auth_bloc.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin/blocs/dashboard/dashboard_bloc.dart';
import 'package:admin/blocs/dashboard/dashboard_event.dart';
import 'package:admin/screens/login_screen.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out successfully")),
    );

    final HttpLink httpLink = HttpLink('http://10.0.2.2:4000/graphql/admin');
    final client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );

    final authRepository = AuthRepository(client);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AuthBloc(authRepository),
          child: const LoginScreen(),
        ),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.watch<DashboardBloc>().state.selectedTab;

    return Drawer(
      width: 270,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7FC), // ✅ Updated background color
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFB38728),
                      Color(0xFFF7EF8A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/icon.jpg'),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Admin Panel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "VKS Jewellers",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Menu
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8),
                  children: [
                    _menuItem(
                      context,
                      icon: Icons.dashboard_rounded,
                      title: "Overview",
                      tabName: "Overview",
                      selected: selectedTab == "Overview",
                    ),
                    _menuItem(
                      context,
                      icon: Icons.layers_rounded,
                      title: "Schemes",
                      tabName: "Schemes",
                      selected: selectedTab == "Schemes",
                    ),
                    _menuItem(
                      context,
                      icon: Icons.attach_money_rounded,
                      title: "Gold Rate",
                      tabName: "GoldAdd",
                      selected: selectedTab == "GoldAdd",
                    ),
                    _menuItem(
                      context,
                      icon: Icons.notifications_rounded,
                      title: "Notifications",
                      tabName: "Notifications",
                      selected: selectedTab == "Notifications",
                    ),
                  ],
                ),
              ),

              // Divider removed + Logout hidden
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String tabName,
        required bool selected,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        context.read<DashboardBloc>().add(ChangeDashboardTab(tabName));
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF3C1) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.amber.shade100,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? const Color(0xFFB38B00) : Colors.black87,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: selected ? const Color(0xFFB38B00) : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
