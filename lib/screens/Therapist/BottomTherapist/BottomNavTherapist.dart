import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Providers/BottomNavProvider.dart';

class TherapistNav extends StatefulWidget {
  const TherapistNav({
    Key? key,
  }) : super(key: key);
  @override
  State<TherapistNav> createState() => _TherapistNavState();
}

class _TherapistNavState extends State<TherapistNav> {
  @override
  Widget build(BuildContext context) {
    final selected = Provider.of<BottomNavProvider>(context).selected;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.black,
      ),
      padding: const EdgeInsets.only(left: 15, right: 15),
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TabItem(
            text: 'Profile',
            active: selected[0],
            touched: () {
              setState(() {
                Provider.of<BottomNavProvider>(context, listen: false)
                    .select(0);
              });
            },
            icon: Icons.home_sharp,
          ),
          const SizedBox(
            width: 20,
          ),
          TabItem(
            text: 'Appointment',
            active: selected[1],
            touched: () {
              setState(() {
                Provider.of<BottomNavProvider>(context, listen: false)
                    .select(1);
              });
            },
            icon: Icons.health_and_safety,
          ),
          const SizedBox(
            width: 20,
          ),
          TabItem(
            text: 'Patients',
            active: selected[2],
            touched: () {
              setState(() {
                Provider.of<BottomNavProvider>(context, listen: false)
                    .select(2);
              });
            },
            icon: Icons.pregnant_woman,
          ),
          const SizedBox(
            width: 20,
          ),
          TabItem(
            text: 'Slots',
            active: selected[3],
            touched: () {
              setState(() {
                Provider.of<BottomNavProvider>(context, listen: false)
                    .select(3);
              });
            },
            icon: Icons.schedule,
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatefulWidget {
  final Function touched;
  final IconData icon;

  final bool active;
  final String text;
  const TabItem({
    Key? key,
    required this.touched,
    required this.active,
    required this.text,
    required this.icon,
  }) : super(key: key);
  @override
  State<TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          widget.touched();
        },
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      widget.icon,
                      size: 22,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    !widget.active
                        ? Text(
                            widget.text,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          )
                        : RotatedBox(
                            quarterTurns: 3,
                            child: AnimatedContainer(
                              transform: Matrix4.rotationZ(0.0174444),
                              duration: const Duration(milliseconds: 100),
                              height: 15.0,
                              width: 2.0,
                              decoration: BoxDecoration(
                                color: widget.active
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
