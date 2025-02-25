import 'package:flutter/material.dart';
import 'package:my_app/theme/theme.dart';
import 'package:my_app/widgets/actions/bla_button.dart';


class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlaButton(
                label: 'Content Volodia',
                style: BlaButtonStyle.outlined,
                icon: const Icon(Icons.messenger_outline),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              BlaButton(
                label: 'Request to book',
                style: BlaButtonStyle.filled,
                icon: const Icon(Icons.calendar_month_outlined),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
