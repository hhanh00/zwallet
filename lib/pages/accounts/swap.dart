import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../generated/intl/messages.dart';

class SwapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.swapProviders),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => GoRouter.of(context).push('/account/swap/stealthex'),
              child: Image.asset('assets/stealthex.png'),
            ),
          ],
        ),
      ),
    );
  }
}
