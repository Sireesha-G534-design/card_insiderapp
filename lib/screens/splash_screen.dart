import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// StatefulWidget is used because this screen contains animations.
// Animation values change over time, so we need a StatefulWidget.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  // Creates the State object for this widget.
  @override
  State<SplashScreen> createState() => _SplashState();
}

// SingleTickerProviderStateMixin provides a ticker for one animation controller.
// A ticker generates frame updates to run animations smoothly.
class _SplashState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // AnimationController controls the animation.
  // late means it will be initialized later in initState().
  // final means it will be assigned only once.
  late final AnimationController _controller;

  // initState() executes only once when the widget is inserted
  // into the widget tree.
  @override
  void initState() {
    super.initState();

    // Creates the animation controller.
    _controller = AnimationController(
      vsync: this, // Uses the current State as the ticker provider.
      duration: const Duration(seconds: 3),

      // Total animation duration: 3 seconds.
    );
    // Add this listener after controller initialization.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;

        context.push('/Dashboard');
      }
    });

    // forward() starts the animation from 0.0 to 1.0.
    _controller.forward();
  }

  // dispose() is called when the widget is permanently removed.
  // It releases the animation controller resources.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Create each animated card.
  //
  // color  = Card background color.
  // start  = Animation starting point (0.0 to 1.0).
  // end    = Animation ending point (0.0 to 1.0).
  // offset = Position of the card relative to its original position.
  Widget card(Color color, double start, double end, Offset offset) {
    // ScaleTransition increases or decreases the size of the card
    // according to the animation value.
    return ScaleTransition(
      // CurvedAnimation controls the speed and movement style.
      scale: CurvedAnimation(
        parent: _controller, // Uses the main animation controller.
        // Interval defines when this particular card animates.
        // For example, 0.0 to 0.35 means the card animates
        // during the first 35% of the total animation.
        curve: Interval(
          start,
          end,
          curve: Curves.easeOutBack, // Creates a slight overshoot effect.
        ),
      ),

      // Transform.translate moves the card from its original position.
      child: Transform.translate(
        offset: offset, // Horizontal and vertical movement.
        // Container creates the card design.
        child: Container(
          width: 100, // Card width.
          height: 64, // Card height.
          // BoxDecoration controls the card appearance.
          decoration: BoxDecoration(
            color: color, // Card background color.
            // Rounds the card corners.
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // build() creates the splash screen UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color of the splash screen.
      backgroundColor: const Color(0xFFF7FBFF),

      // Center places the complete splash content
      // in the middle of the screen.
      body: Center(
        // Column arranges widgets vertically.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // SizedBox provides a fixed area for the card animation.
            SizedBox(
              width: 150,
              height: 100,

              // Stack places the three cards on top of each other.
              child: Stack(
                alignment: Alignment.center,

                children: [
                  // First dark blue card.
                  // Animation starts at 0% and ends at 35%.
                  // Moves slightly towards the top-left.
                  card(
                    const Color(0xFF092E70),
                    0.0,
                    0.35,
                    const Offset(-12, -10),
                  ),

                  // Second bright blue card.
                  // Animation starts at 30% and ends at 65%.
                  // Remains at the center.
                  card(const Color(0xFF168FF0), 0.30, 0.65, Offset.zero),

                  // Third light blue card.
                  // Animation starts at 60% and ends at 90%.
                  // Moves slightly towards the bottom-right.
                  card(
                    const Color(0xFF80D9F5),
                    0.60,
                    0.90,
                    const Offset(12, 10),
                  ),
                ],
              ),
            ),

            // Adds 25 logical pixels of vertical space
            // between the cards and the app name.
            const SizedBox(height: 25),

            // FadeTransition gradually makes the app name visible.
            FadeTransition(
              // Controls the opacity animation.
              opacity: CurvedAnimation(
                parent: _controller,

                // App name fades in during the last 15%
                // of the total animation.
                curve: const Interval(0.85, 1.0),
              ),

              // Text.rich allows multiple text styles
              // inside a single text widget.
              child: const Text.rich(
                TextSpan(
                  children: [
                    // First part of the app name.
                    TextSpan(
                      text: 'CARD ',
                      style: TextStyle(color: Color(0xFF092E70)),
                    ),

                    // Second part of the app name.
                    TextSpan(
                      text: 'INSIDER',
                      style: TextStyle(color: Color(0xFF168FF0)),
                    ),
                  ],
                ),

                // Common text styling.
                style: TextStyle(
                  fontSize: 27, // Text size.
                  fontWeight: FontWeight.w800, // Extra bold text.
                  letterSpacing: -0.5, // Slightly reduces letter spacing.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
