import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';
import 'tasks_screen.dart';
import 'help_screen.dart';
import 'profile_screen.dart';
import 'ar_scan_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const TasksScreen(),
    const HelpScreen(showBackButton: false),
    const ProfileScreen(showBackButton: false),
  ];

  void _navigateToAR() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ARScanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).round()),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
                // Mapkan selected item BottomNavigationBar -> screen index
                // _currentIndex menyimpan screen index (0..3). Karena BottomNavigationBar
                // mempunyai spacer di posisi 2, kita harus memetakan screenIndex->navIndex:
                // screen 0 -> nav 0, screen 1 -> nav 1, screen 2 -> nav 3, screen 3 -> nav 4
                currentIndex: _currentIndex < 2 ? _currentIndex : _currentIndex + 1,
                onTap: (index) {
                  // Jika spacer (index == 2) ditekan, abaikan
                  if (index == 2) return;
                  // Map NavBar index ke screen index (skip spacer di index 2)
                  int screenIndex = index < 2 ? index : index - 1;
                  setState(() {
                    _currentIndex = screenIndex;
                  });
                },
              selectedItemColor: AppColors.primaryDarkBlue,
              unselectedItemColor: Colors.grey[400],
              backgroundColor: Colors.white,
              elevation: 0,
              showUnselectedLabels: true,
              unselectedLabelStyle: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
              ),
              selectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 24),
                  activeIcon: Icon(Icons.home, size: 24),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.task_outlined, size: 24),
                  activeIcon: Icon(Icons.task, size: 24),
                  label: 'Tasks',
                ),
                // Spacer untuk FAB
                BottomNavigationBarItem(
                  icon: SizedBox(width: 60),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.help_outline, size: 24),
                  activeIcon: Icon(Icons.help, size: 24),
                  label: 'Guide',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline, size: 24),
                  activeIcon: Icon(Icons.person, size: 24),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
        // Floating Action Button - Di atas semua untuk tidak tercrop
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _navigateToAR,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryLightBlue,
                      AppColors.secondaryLightBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDarkBlue.withAlpha((0.3 * 255).round()),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _navigateToAR,
                    customBorder: const CircleBorder(),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
