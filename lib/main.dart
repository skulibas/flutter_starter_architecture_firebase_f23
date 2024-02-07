import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/app_router.dart';
import 'features/authorization/presentation/auth_widget.dart';
import 'features/authorization/presentation/sign_in/sign_in_page.dart';
import 'features/home/presentation/home_page.dart';
import 'features/onboarding/presentation/onboarding_page.dart';
import 'features/onboarding/presentation/onboarding_view_model.dart';
import 'repositories/firestore/firestore_providers.dart';
import 'repositories/shared_preferences/shared_preferences_database.dart';
import 'repositories/shared_preferences/shared_preferences_providers.dart';

/// Main program initializes [Firebase], obtains the [SharedPreferences],
/// and finally runs [MyApp].
///
/// Access to [SharedPreferences] is controlled by a [SharedPreferencesDatabase]
/// access to which is itself controlled by a [sharedPreferencesDatabaseProvider].
/// The actual service instance is set via an override
/// in the call to [ProviderScope]. This presumably facilitates testing because
/// it simplifies mocking.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesDatabaseProvider.overrideWithValue(
        SharedPreferencesDatabase(sharedPreferences),
      ),
    ],
    child: MyApp(),
  ));
}

/// Builds and returns [AuthWidget], which will display either [SignInPage] or
/// [OnboardingPage] if the user is not signed in, or [HomePage] if the user is signed in.
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: AuthWidget(
        nonSignedInBuilder: (_) => Consumer(
          builder: (context, ref, _) {
            final didCompleteOnboarding =
                ref.watch(onboardingViewModelProvider);
            return didCompleteOnboarding ? SignInPage() : OnboardingPage();
          },
        ),
        signedInBuilder: (_) => HomePage(),
      ),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, firebaseAuth),
    );
  }
}
