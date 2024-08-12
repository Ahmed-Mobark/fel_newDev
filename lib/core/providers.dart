import 'package:football_app/presentation/notifiers/app_settings_notifier.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/notifiers/bottom_nav_notifier.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:football_app/presentation/notifiers/home_notifier.dart';
import 'package:football_app/presentation/notifiers/league_notifier.dart';
import 'package:football_app/presentation/notifiers/register_notifier.dart';
import 'package:football_app/presentation/notifiers/transactions_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../presentation/notifiers/refresh_notifier.dart';
import '../presentation/notifiers/store_notifier.dart';

class Providers {
  static List<SingleChildWidget> providersList = <SingleChildWidget>[
    ChangeNotifierProvider<HomeNotifier>(
      lazy: false,
      create: (_) => HomeNotifier(),
    ),
    ChangeNotifierProvider<LeagueNotifier>(
      lazy: false,
      create: (_) => LeagueNotifier(),
    ),
    ChangeNotifierProvider<BottomNavigationBarNotifier>(
      lazy: false,
      create: (_) => BottomNavigationBarNotifier(),
    ),
    ChangeNotifierProvider<RegisterNotifier>(
      lazy: false,
      create: (_) => RegisterNotifier(),
    ),
    ChangeNotifierProvider<AuthNotifier>(
      lazy: false,
      create: (_) => AuthNotifier(),
    ),
    ChangeNotifierProvider<GroupNotifier>(
      lazy: false,
      create: (_) => GroupNotifier(),
    ),
    ChangeNotifierProvider<RefreshNotifer>(
      lazy: false,
      create: (_) => RefreshNotifer(),
    ),
    ChangeNotifierProvider<StoreNotifier>(
      lazy: false,
      create: (_) => StoreNotifier(),
    ),
    ChangeNotifierProvider<TransactionsNotifier>(
      lazy: false,
      create: (_) => TransactionsNotifier(),
    ),
    ChangeNotifierProvider<AppSettingsNotifier>(
      lazy: false,
      create: (_) => AppSettingsNotifier(),
    ),
  ];
}
