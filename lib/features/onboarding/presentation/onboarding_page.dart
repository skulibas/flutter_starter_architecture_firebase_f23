import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../custom_raised_button.dart';
import 'onboarding_view_model.dart';

/// Builds a page explaining the app, and sets onboarding complete once
/// the user clicks the Get Started button.
class OnboardingPage extends ConsumerWidget {
  Future<void> onGetStarted(BuildContext context, WidgetRef ref) async {
    final onboardingViewModel = ref.read(onboardingViewModelProvider.notifier);
    await onboardingViewModel.completeOnboarding();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Track your time.\nBecause time counts.',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: SvgPicture.asset('assets/time-tracking.svg',
                  semanticsLabel: 'Time tracking logo'),
            ),
            CustomRaisedButton(
              onPressed: () => onGetStarted(context, ref),
              color: Colors.indigo,
              borderRadius: 30,
              child: Text(
                'Get Started',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
