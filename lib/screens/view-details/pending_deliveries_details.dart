import 'package:flutter/material.dart';

class PendingDeliveryDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  final String licenceNo;
  final List<dynamic> pendingOrders;
  final List<dynamic> intransitOrders;

  PendingDeliveryDetailsScreen({
    required this.task,
    required this.licenceNo,
    required this.pendingOrders,
    required this.intransitOrders,
  });

  @override
  State<PendingDeliveryDetailsScreen> createState() =>
      _PendingDeliveryDetailsScreenState();
}

class _PendingDeliveryDetailsScreenState
    extends State<PendingDeliveryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
