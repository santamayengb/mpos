import 'package:flutter/material.dart';

class AvatarStackDemo extends StatelessWidget {
  final List<String> avatarUrls = [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
    'https://i.pravatar.cc/150?img=6',
    'https://i.pravatar.cc/150?img=7',
    'https://i.pravatar.cc/150?img=8',
    'https://i.pravatar.cc/150?img=9',
    'https://i.pravatar.cc/150?img=10',
    'https://i.pravatar.cc/150?img=11',
    'https://i.pravatar.cc/150?img=12',
    'https://i.pravatar.cc/150?img=13',
    'https://i.pravatar.cc/150?img=14',
    'https://i.pravatar.cc/150?img=15',
    'https://i.pravatar.cc/150?img=16',
    'https://i.pravatar.cc/150?img=17',
  ];

  final int visibleCount = 10;

  AvatarStackDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleAvatars = avatarUrls.take(visibleCount).toList();
    final remaining = avatarUrls.length - visibleCount;

    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          for (int i = 0; i < visibleAvatars.length; i++)
            Positioned(
              left: i * 30.0,
              child: HoverAvatar(imageUrl: visibleAvatars[i]),
            ),
          if (remaining > 0)
            Positioned(
              left: visibleAvatars.length * 30.0,
              child: MoreAvatar(count: remaining),
            ),
        ],
      ),
    );
  }
}

class HoverAvatar extends StatefulWidget {
  final String imageUrl;
  const HoverAvatar({super.key, required this.imageUrl});

  @override
  State<HoverAvatar> createState() => _HoverAvatarState();
}

class _HoverAvatarState extends State<HoverAvatar> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        duration: Duration(milliseconds: 350),
        scale: _hovering ? 5 : 1.0,
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(widget.imageUrl),
        ),
      ),
    );
  }
}

class MoreAvatar extends StatelessWidget {
  final int count;
  const MoreAvatar({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.blue,
      child: Text(
        '+$count',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
