import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/store_model/store_model.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/screens/screens.dart';
import 'package:football_app/presentation/widgets/user_coins.dart';
import 'package:football_app/presentation/widgets/w_feeds.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../notifiers/groups_notifer.dart';
import '../notifiers/store_notifier.dart';
import 'buttons/custom_button.dart';
import 'dialogs/purchase_dialog.dart';

part 'app_loading_indicator.dart';
part 'error_snack_bar.dart';
part 'sheets/filter_search_store.dart';
part 'user_shirt.dart';
part 'w_animated.dart';
part 'w_store.dart';
