import 'package:flutter/material.dart';

class InTransitDeliveryDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> task;
  final String driverCode;

  InTransitDeliveryDetailsScreen(
      {required this.task, required this.driverCode});

  @override
  State<InTransitDeliveryDetailsScreen> createState() =>
      _InTransitDeliveryDetailsScreenState();
}

class _InTransitDeliveryDetailsScreenState
    extends State<InTransitDeliveryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
