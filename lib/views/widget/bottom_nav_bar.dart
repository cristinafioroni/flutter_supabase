import 'package:flutter/material.dart';
import 'package:flutter_supabase/views/user_profile_view.dart';
import 'package:flutter_supabase/views/home_view.dart';
import 'package:flutter_supabase/views/widget/add_book_view.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomeView();
        break;
      case 1:
        destination = const UserProfileView();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            color: currentIndex == 0
                ? Colors.grey
                : const Color.fromARGB(255, 78, 19, 1),
            onPressed: () => _onTap(context, 0),
          ),
          IconButton(
            icon: const Icon(Icons.add),
          
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBookView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            color: currentIndex == 1
                ? Colors.grey
                : const Color.fromARGB(255, 88, 0, 49),
            onPressed: () => _onTap(context, 1),
          ),
        ],
      ),
    );
  }
}
