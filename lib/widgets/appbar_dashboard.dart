import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../const/const.dart';

class AppbarDashboard extends StatelessWidget {
  const AppbarDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white, // fond général
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: Const.screenWidth(context) * 0.23,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Icon(Icons.search, size: 20, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: Theme.of(context).textTheme.labelSmall,
                    decoration: InputDecoration(
                      hintText: 'Search anything...',
                      hintStyle: Theme.of(context).textTheme.labelSmall,
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Container(
          //   height: 40,
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   decoration: BoxDecoration(
          //     color: Colors.black,
          //     borderRadius: BorderRadius.circular(25),
          //   ),
          //   alignment: Alignment.center,
          //   child: const Text(
          //     'Create',
          //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          //   ),
          // ),

          const SizedBox(width: 15),

          // 🔔 Notification
          _iconCircle(Icons.notifications_none_rounded),

          const SizedBox(width: 10),

          // // 💬 Message
          // _iconCircle(Icons.chat_bubble_outline_rounded),

          const SizedBox(width: 10),

          CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 18,
              child: Image.asset(
                "assets/images/user.png",
                width: 20,
                height: 20,
              )),
        ],
      ),
    );
  }

  // Widget réutilisable pour les cercles d'icônes
  Widget _iconCircle(IconData icon) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: Icon(icon, size: 20, color: Colors.black54),
    );
  }
}
