import 'package:flutter/material.dart';

class MetricChip extends StatelessWidget {
  const MetricChip({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label  $value'));
  }
}
