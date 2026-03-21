import 'package:flutter/material.dart';
import 'notification_badge.dart';


class FitnessAppBar extends StatelessWidget implements PreferredSizeWidget {
  
  final VoidCallback onProfileTap;
  
  
  final VoidCallback onNotificationsTap;
  
 
  final String notificationCount;

  const FitnessAppBar({
    super.key,
    required this.onProfileTap,
    required this.onNotificationsTap,
    this.notificationCount = '3',
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
     
      backgroundColor: Colors.deepOrange[900],
      
      foregroundColor: Colors.white,
      
      
      title: const Text(
        "Fitness Tracker",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      
      centerTitle: true,
      
      
      leading: Icon(Icons.fitness_center),
      
      
      actions: [
        
        IconButton(
          onPressed: onProfileTap,
          icon: const Icon(Icons.account_circle),
          tooltip: 'Profile',
        ),
        
        
        Stack(
          children: [
            IconButton(
              onPressed: onNotificationsTap,
              icon: const Icon(Icons.notifications),
              tooltip: 'Notifications',
            ),
            
           
            NotificationBadge(count: notificationCount),
          ],
        ),
      ],
    );
  }
}
