import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: 'Journey'),
      body: Center(child: Text('Journey Page')),
    );
  }
}
