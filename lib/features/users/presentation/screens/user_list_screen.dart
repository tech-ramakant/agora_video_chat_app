import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_chat_demo/core/app_string.dart';
import '../../../../core/app_color.dart';
import '../../../../core/di/providers.dart';
import '../../../video_call/presentation/screens/video_call_screen.dart';
import '../../domain/entities/user.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollCtrl.addListener(() {
      if (scrollCtrl.position.pixels >=
          scrollCtrl.position.maxScrollExtent - 200) {
        ref.read(userNotifierProvider.notifier).fetchNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      appBar: AppBar(
        title: Text(AppString.title_users),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VideoCallScreen()),
              );
            },
            icon: Icon(Icons.video_call,color: AppColor.colorToolbarIcon,),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: state.loading && state.users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userNotifierProvider);
        },
        child: ListView.builder(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.users.length + (state.loading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.users.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final user = state.users[index];
            return _userCard(user);
          },
        ),
      ),
    );
  }

  Widget _userCard(User user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade200,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.avatar,
              fit: BoxFit.cover,
              width: 56,
              height: 56,
              placeholder: (context, url) =>
              const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (context, url, error) =>
              const Icon(Icons.person, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${user.email}\n${user.phone}',
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
