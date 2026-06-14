import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class FAQItem {
  final String title;
  final String content;
  final IconData icon;

  FAQItem({
    required this.title,
    required this.content,
    required this.icon,
  });
}

class FAQItemWidget extends StatefulWidget {
  final FAQItem faqItem;

  const FAQItemWidget({
    super.key,
    required this.faqItem,
  });

  @override
  State<FAQItemWidget> createState() => _FAQItemWidgetState();
}

class _FAQItemWidgetState extends State<FAQItemWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _isExpanded
              ? AppColors.primaryLightBlue.withAlpha((0.3 * 255).round())
              : Colors.grey[200]!,
          width: _isExpanded ? 1.5 : 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryLightBlue.withAlpha((0.15 * 255).round()),
                  AppColors.secondaryLightBlue.withAlpha((0.15 * 255).round()),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.faqItem.icon,
              color: AppColors.primaryDarkBlue,
              size: 22,
            ),
          ),
          title: Text(
            widget.faqItem.title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDarkBlue,
            ),
          ),
          trailing: RotationTransition(
            turns: _iconRotation,
            child: const Icon(
              Icons.expand_more_rounded,
              color: AppColors.primaryLightBlue,
              size: 24,
            ),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
            if (expanded) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[200],
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                  Text(
                    widget.faqItem.content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
