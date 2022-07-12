import 'package:adscope/core/constants/constants.dart';
import 'package:adscope/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.backAppBar(context, title: 'Terms & Conditions'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(kPadding),
        child: Column(
          children: [
            PrimaryButton(
              label: 'Accept',
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
