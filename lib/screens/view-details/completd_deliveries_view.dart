import 'package:flutter/material.dart';

class CompletedDeliveryDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  final String driverCode;

  CompletedDeliveryDetailsScreen(
      {required this.task, required this.driverCode});

  @override
  State<CompletedDeliveryDetailsScreen> createState() =>
      _CompletedDeliveryDetailsScreenState();
}

class _CompletedDeliveryDetailsScreenState
    extends State<CompletedDeliveryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
