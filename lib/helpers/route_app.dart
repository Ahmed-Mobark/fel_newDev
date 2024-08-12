part of 'helpers.dart';

Route routesApp(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (_) => const VideoSplashPage(),
      );
    case '/welcome':
      return MaterialPageRoute(
        builder: (_) => ShowCaseWidget(
          builder: Builder(builder: (context) => const WelcomeScreen()),
        ),
      );
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case '/register':
      return MaterialPageRoute(builder: (_) => const RegisterScreen());
    case '/registerSecondScreen':
      return MaterialPageRoute(builder: (_) => const RegisterSecondScreen());
    case '/groups':
      return MaterialPageRoute(builder: (_) => GroupsScreen());
    case '/verify':
      return MaterialPageRoute(builder: (_) => const VerificationScreen());
    case '/challenges':
      return MaterialPageRoute(builder: (_) => const ChallengesScreen());
    case '/CoinShop':
      return MaterialPageRoute(builder: (_) => const CoinPurchase());
    case '/PurchasedProducts':
      return MaterialPageRoute(builder: (_) => const PurchasedProducts());

    default:
      throw "no route Page found";
  }
}
