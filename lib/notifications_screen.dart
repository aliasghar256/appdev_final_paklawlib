import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// Import your bloc files
import './bloc/notifications_bloc/notifications_bloc.dart';
import './bloc/notifications_bloc/notifications_state.dart'; 
import './bloc/notifications_bloc/notifications_event.dart';
import './models/notifications_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap in a Scaffold with a teal AppBar
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002652),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // go back
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Handle "home" navigation as needed
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationsLoaded) {
            final notifications = state.notifications; // List<NotificationsModel>
            
            if (notifications.isEmpty) {
              return const Center(child: Text('No notifications found.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _buildNotificationItem(item);
              },
            );
          } else if (state is NotificationsError) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          } else {
            // If we encounter an unexpected state
            return const Center(child: Text('Unexpected state.'));
          }
        },
      ),
    );
  }

  /// Builds a single notification row item
  Widget _buildNotificationItem(notification) {
    // You can cast to your NotificationsModel if needed:
    // final noti = notification as NotificationsModel;

    // -------------------------------------------------------------------------
    // COMMENTED OUT all unreadCount logic:
    // final unreadCount = notification.unreadCount ?? 0;
    //
    // COMMENTED OUT all imageUrl logic:
    // CircleAvatar(
    //   radius: 30,
    //   backgroundImage: NetworkImage(notification.imageUrl),
    // ),
    // -------------------------------------------------------------------------

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              // CircleAvatar(
              //   radius: 30,
              //   backgroundImage: NetworkImage(notification.imageUrl),
              // ),
              // if (unreadCount > 0)
              //   Positioned(
              //     top: -4,
              //     left: -4,
              //     child: Container(
              //       width: 24,
              //       height: 24,
              //       decoration: BoxDecoration(
              //         color: const Color(0xFFFF5722), // orange
              //         shape: BoxShape.circle,
              //         border: Border.all(color: Colors.white, width: 1),
              //       ),
              //       alignment: Alignment.center,
              //       child: Text(
              //         '$unreadCount',
              //         style: const TextStyle(
              //           color: Colors.white,
              //           fontSize: 12,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
          const SizedBox(width: 12),

          // Title, description, and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + time in one row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(notification.date),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
