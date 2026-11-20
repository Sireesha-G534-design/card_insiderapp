import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  final Color blue = const Color(0xFF168FF0);
  final Color darkBlue = const Color(0xFF092E70);

  @override
  Widget build(BuildContext context) {
    bool web = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      backgroundColor: const Color(0xFFE5F1FF),

      body: SafeArea(
        child: Row(
          children: [
            if (web) _navigation(true),

            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // APP BAR
                    Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Row(
                        children: [
                          Text(
                            'Card Insider',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.notifications_none,
                            color: blue,
                            size: 30.sp,
                          ),
                        ],
                      ),
                    ),

                    // DASHBOARD
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(
                          scrollbars: false,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(20.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (web)
                                Row(
                                  children: [
                                    Expanded(flex: 5, child: _reminder()),
                                    SizedBox(width: 20.w),
                                    Expanded(flex: 4, child: _lounges()),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _reminder(),
                                    SizedBox(height: 20.h),
                                    _lounges(),
                                  ],
                                ),

                              SizedBox(height: 30.h),

                              Text(
                                'Customer Reviews',
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                  color: darkBlue,
                                ),
                              ),

                              SizedBox(height: 15.h),

                              _review('Rahul', 'Very useful app!', 5),
                              SizedBox(height: 12.h),
                              _review('Priya', 'Great card benefits.', 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: web ? null : _navigation(false),
    );
  }

  // NAVIGATION
  Widget _navigation(bool web) {
    final icons = [Icons.home, Icons.credit_card, Icons.person];
    final names = ['Home', 'My Cards', 'Profile'];

    return web
        ? Container(
            width: 110,
            color: Colors.white,
            child: Column(
              children: List.generate(
                3,
                (i) => _navItem(icons[i], names[i], i),
              ),
            ),
          )
        : ClipPath(
            clipper: CurvedBarClipper(),
            child: Container(
              height: 85.h,
              color: Colors.white,
              child: Row(
                children: List.generate(
                  3,
                  (i) => Expanded(child: _navItem(icons[i], names[i], i)),
                ),
              ),
            ),
          );
  }

  Widget _navItem(IconData icon, String title, int index) {
    bool active = selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        switch (index) {
          case 0:
            context.go('/Dashboard');
            break;

          case 1:
            context.go('/my-cards');
            break;

          case 2:
            context.go('/profile');
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 5.w),
        margin: EdgeInsets.all(5.r),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFD5ECFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? blue : Colors.grey),
            SizedBox(height: 5.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                color: active ? blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // REMINDER
  Widget _reminder() {
    return Container(
      height: 350.h,
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6FF),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: const Color(0xFFB8DDFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reminder',
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Icon(Icons.credit_card, size: 55.sp, color: blue),
              ),
              Container(
                width: 2,
                height: 130.h,
                color: const Color(0xFFB8DDFF),
              ),
              SizedBox(width: 15.w),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HDFC Credit Card',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const Text('Bill Date: 05 Dec'),
                    SizedBox(height: 10.h),
                    const Text('Due Date: 20 Dec'),
                    SizedBox(height: 15.h),
                    Text(
                      'Amount: ₹8,500',
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // LOUNGES
  // LOUNGES
  Widget _lounges() {
    return Column(
      children: [
        SizedBox(
          height: 160.h,
          child: _lounge(
            'Airport Lounge',
            Icons.flight,
            Colors.blue,
            const Color(0xFFEAF6FF),
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 160.h,
          child: _lounge(
            'Railway Lounge',
            Icons.train,
            Colors.blue,
            const Color(0xFFEAF6FF),
          ),
        ),
      ],
    );
  }

  Widget _lounge(String title, IconData icon, Color color, Color bg) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 38.sp),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.blue),
        ],
      ),
    );
  }

  // REVIEWS
  Widget _review(String name, String review, int rating) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE5DDF5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEBDDFF),
            child: Icon(Icons.person, color: Colors.deepPurple),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(review),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (i) => Icon(
                i < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CURVED NAVIGATION SHAPE
class CurvedBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 20)
      ..quadraticBezierTo(size.width / 2, -20, size.width, 20)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CurvedBarClipper oldClipper) => false;
}
