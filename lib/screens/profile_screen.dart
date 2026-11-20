import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:card_insiderapp/widgets/bottom_navigaiton_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color darkBlue = Color(0xFF123B70);
  static const Color lightBlue = Color(0xFFEAF4FF);
  static const Color pageBackground = Color(0xFFF3F8FF);
  static const Color activeBlue = Color(0xFF168FF0);

  // PROFILE DETAILS
  final nameController = TextEditingController(text: 'Your Name');
  final emailController = TextEditingController(text: 'your.email@example.com');
  final mobileController = TextEditingController(text: '9876543210');

  // EDIT PROFILE STATE
  bool isEditing = false;

  String oldName = '';
  String oldEmail = '';
  String oldMobile = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  // START EDITING
  void _editProfile() {
    oldName = nameController.text;
    oldEmail = emailController.text;
    oldMobile = mobileController.text;

    setState(() {
      isEditing = true;
    });
  }

  // SAVE PROFILE
  void _saveProfile() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        mobileController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    // Connect Update Profile API here.
  }

  // CANCEL EDITING
  void _cancelEdit() {
    nameController.text = oldName;
    emailController.text = oldEmail;
    mobileController.text = oldMobile;

    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        return isMobile ? _mobileLayout(context) : _webLayout(context);
      },
    );
  }

  // MOBILE LAYOUT

  Widget _mobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: _appBar(),
      body: _profileBody(context),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: 2,
        onTabSelected: (index) {
          _navigate(context, index);
        },
      ),
    );
  }

  // WEB / DESKTOP LAYOUT

  Widget _webLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: Row(
        children: [
          _desktopSidebar(context),
          Expanded(
            child: Column(
              children: [
                _appBar(),
                Expanded(child: _profileBody(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // APP BAR

  PreferredSizeWidget _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: pageBackground,
      elevation: 0,
      title: Text(
        isEditing ? 'Edit Profile' : 'Profile',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: darkBlue,
        ),
      ),
      actions: [
        if (isEditing)
          TextButton(
            onPressed: _cancelEdit,
            child: const Text('Cancel', style: TextStyle(color: darkBlue)),
          ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
          color: darkBlue,
        ),
        SizedBox(width: 12.w),
      ],
    );
  }

  // DESKTOP SIDEBAR

  Widget _desktopSidebar(BuildContext context) {
    return Container(
      width: 240,
      height: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CARD INSIDER',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 35),

          _sidebarItem(context, Icons.home_outlined, 'Home', 0),

          _sidebarItem(context, Icons.credit_card_outlined, 'My Cards', 1),

          _sidebarItem(context, Icons.person_outline, 'Profile', 2),

          const Spacer(),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    final bool selected = index == 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFD9EDFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? activeBlue : Colors.blueGrey),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? activeBlue : darkBlue,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () => _navigate(context, index),
      ),
    );
  }

  // NAVIGATION

  void _navigate(BuildContext context, int index) {
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
  }

  // PROFILE BODY

  Widget _profileBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              if (isEditing)
                _editProfileForm()
              else ...[
                _profileHeader(context),

                SizedBox(height: 20.h),

                // PROFILE MENU
                _menuCard([
                  _menuItem(context, Icons.help_outline, 'Help & Support'),
                  _menuItem(
                    context,
                    Icons.description_outlined,
                    'Terms & Conditions',
                  ),
                  _menuItem(context, Icons.info_outline, 'About Card Insider'),
                ]),

                SizedBox(height: 25.h),

                // LOGOUT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // PROFILE HEADER

  Widget _profileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2366C9), Color(0xFF16A1D5)],
        ),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12.w,
        runSpacing: 15.h,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 38.r,
                backgroundColor: Colors.white,
                child: Text(
                  nameController.text.isNotEmpty
                      ? nameController.text[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(width: 15.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameController.text,
                    style: TextStyle(
                      fontSize: 19.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    emailController.text,
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    mobileController.text,
                    style: TextStyle(fontSize: 13.sp, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),

          ElevatedButton.icon(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit, size: 17),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              foregroundColor: darkBlue,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // EDIT PROFILE FORM

  Widget _editProfileForm() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Your Details',
            style: TextStyle(
              fontSize: 21.sp,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),

          SizedBox(height: 25.h),

          // FULL NAME
          _fieldLabel('Full Name'),
          SizedBox(height: 8.h),
          TextField(
            controller: nameController,
            decoration: _inputDecoration(
              'Enter your full name',
              Icons.person_outline,
            ),
          ),

          SizedBox(height: 20.h),

          // EMAIL
          _fieldLabel('Email Address'),
          SizedBox(height: 8.h),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(
              'Enter your email address',
              Icons.email_outlined,
            ),
          ),

          SizedBox(height: 20.h),

          // MOBILE
          _fieldLabel('Mobile Number'),
          SizedBox(height: 8.h),
          TextField(
            controller: mobileController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration(
              'Enter your mobile number',
              Icons.phone_outlined,
            ),
          ),

          SizedBox(height: 30.h),

          // BUTTONS
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: SizedBox(
                  height: 52.h,
                  child: OutlinedButton(
                    onPressed: _cancelEdit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: darkBlue,
                      side: const BorderSide(color: activeBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // FIELD LABEL

  Widget _fieldLabel(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: darkBlue,
      ),
    );
  }

  // TEXT FIELD DECORATION

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: activeBlue),
      filled: true,
      fillColor: pageBackground,
      contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: Color(0xFFE0EAF5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: activeBlue),
      ),
    );
  }

  // MENU CARD

  Widget _menuCard(List<Widget> items) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: items),
    );
  }

  // MENU ITEM

  Widget _menuItem(BuildContext context, IconData icon, String title) {
    return InkWell(
      onTap: () {
        _showMessage(context, title);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              height: 48.r,
              width: 48.r,
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: activeBlue, size: 25.sp),
            ),

            SizedBox(width: 15.w),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 16.sp, color: darkBlue),
          ],
        ),
      ),
    );
  }

  // SNACKBAR

  void _showMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title selected')));
  }

  // LOGOUT

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showMessage(context, 'Connect your logout API here');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
