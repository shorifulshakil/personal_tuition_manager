import 'package:flutter/material.dart';
import '../../services/course_service.dart';
import '../../models/fetch_payment.dart';
import '../../utils/sms_utils.dart';
import '../../utils/time_ago.dart';
import '../../widgets/custom_swipe_card.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const PaymentCard({
    super.key,
    required this.payment,
    required this.onEdit,
    required this.onDelete,
    required this.onLongPress,
  });

  Color _getColorBasedOnStatus(CourseStatus courseStatus) {
    switch (courseStatus) {
      case CourseStatus.noCourse:
        return Colors.green;
      case CourseStatus.notStarted:
        return Colors.orange;
      case CourseStatus.started:
        return Colors.red;
      case CourseStatus.closed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSwipeCard(
      onSwipeLeft: onDelete,
      onSwipeRight: onEdit,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Status indicator bar
            Container(
              width: 4,
              height: 80,
              decoration: BoxDecoration(
                color: _getColorBasedOnStatus(payment.courseStatus),
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(right: 12),
            ),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row - Amount, SMS Button and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Amount
                      Text(
                        '₹${payment.amount.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Quick SMS Action Button
                          IconButton(
                            icon: const Icon(Icons.message_outlined),
                            color: Colors.blue.shade700,
                            tooltip: 'Send SMS Payment Confirmation',
                            onPressed: () => sendPaymentSms(
                              context: context,
                              mobile: payment.studentFrom.mobile,
                              studentName: payment.studentFrom.name,
                              amount: payment.amount,
                              paymentDate: payment.paymentDate,
                            ),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          ),

                          const SizedBox(width: 4),

                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getColorBasedOnStatus(payment.courseStatus)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(payment.courseStatus),
                              style:
                                  Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: _getColorBasedOnStatus(
                                            payment.courseStatus),
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Second row - Payment ID and Days ago
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ID: ${payment.id}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      Text(
                        timeAgoString(payment.paymentDate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Student name
                  Text(
                    payment.studentFrom.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(CourseStatus status) {
    switch (status) {
      case CourseStatus.noCourse:
        return 'No Course';
      case CourseStatus.notStarted:
        return 'Not Started';
      case CourseStatus.started:
        return 'Ongoing';
      case CourseStatus.closed:
        return 'Completed';
    }
  }
}
