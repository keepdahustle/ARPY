import 'package:flutter/material.dart';

class AppAnimations {
  // 1. FADE PAGE ROUTE
  static PageRouteBuilder fadePageRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  // 2. SLIDE PAGE ROUTE (Original)
  static PageRouteBuilder slidePageRoute({required Widget page, AxisDirection direction = AxisDirection.right}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = direction == AxisDirection.right ? const Offset(-1, 0) : const Offset(0, 1);
        Offset end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  // 3. ZOOM + FADE (Modern Material Design)
  static PageRouteBuilder zoomFadePageRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var scaleAnimation = animation.drive(
          Tween<double>(begin: 0.8, end: 1.0).chain(
            CurveTween(curve: Curves.easeOutCubic),
          ),
        );
        var fadeAnimation = animation.drive(
          Tween<double>(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeOut),
          ),
        );
        
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  // 4. ROTATION + SCALE (Playful, Unique)
  static PageRouteBuilder rotationScalePageRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var rotateAnimation = animation.drive(
          Tween<double>(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeOutCubic),
          ),
        );
        var scaleAnimation = animation.drive(
          Tween<double>(begin: 0.85, end: 1.0).chain(
            CurveTween(curve: Curves.easeOut),
          ),
        );
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(rotateAnimation.value * 0.15),
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 550),
    );
  }

  // 5. DIAGONAL SLIDE (iOS-like)
  static PageRouteBuilder diagonalSlidePageRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var beginOffset = const Offset(1, 1);
        var endOffset = Offset.zero;
        var tween = Tween(begin: beginOffset, end: endOffset);
        var offsetAnimation = animation.drive(
          tween.chain(CurveTween(curve: Curves.easeOutCubic)),
        );
        
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 550),
    );
  }

  // 6. BOUNCE + FADE (Playful)
  static PageRouteBuilder bouncePageRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var scaleAnimation = animation.drive(
          Tween<double>(begin: 0.6, end: 1.0).chain(
            CurveTween(curve: Curves.elasticOut),
          ),
        );
        var fadeAnimation = animation.drive(
          Tween<double>(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeOut),
          ),
        );
        
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 700),
    );
  }

  // 7. SLIDE UP + BLUR (Modern iOS)
  static PageRouteBuilder slideUpBlurPageRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var slideAnimation = animation.drive(
          Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).chain(
            CurveTween(curve: Curves.easeOutCubic),
          ),
        );
        var fadeAnimation = animation.drive(
          Tween<double>(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeOut),
          ),
        );
        
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 450),
    );
  }

  // 8. FLIP CARD (Unique)
  static PageRouteBuilder flipCardPageRoute({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var rotationAnimation = animation.drive(
          Tween<double>(begin: 1.0, end: 0.0).chain(
            CurveTween(curve: Curves.easeInOutCubic),
          ),
        );
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(rotationAnimation.value * 3.14159), // π radians
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  // Button Animations
  static ScaleTransition scaleButton(Animation<double> animation, Widget child) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.elasticOut),
      ),
      child: child,
    );
  }

  // Fade In Animation
  static Future<void> fadeInAnimation(AnimationController controller) async {
    controller.forward();
  }

  // Bounce Animation
  static Widget bounceWidget({
    required Widget child,
    required AnimationController controller,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      ),
      child: child,
    );
  }
}

// Curved Animation Timing
class AppCurves {
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve smoothCurve = Curves.easeOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve sharpCurve = Curves.linear;
}

// Duration Constants
class AppDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration long = Duration(milliseconds: 600);
  static const Duration extraLong = Duration(milliseconds: 800);
}