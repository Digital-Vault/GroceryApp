import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class CustomLocalizations {
  CustomLocalizations(this.localeName);

  static Future<CustomLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return CustomLocalizations(localeName);
    });
  }

  static CustomLocalizations of(BuildContext context) {
    return Localizations.of<CustomLocalizations>(context, CustomLocalizations);
  }

  final String localeName;

  String get title {
    return Intl.message(
      'Grocery App',
      name: 'title',
      desc: 'Title for the application',
      locale: localeName,
    );
  }

  String get navbarHome {
    return Intl.message(
      'Grocery List',
      name: 'navbarHome',
      desc: "Title of the home page",
      locale: localeName,
    );
  }

  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: "Home button in the bottom navigation",
      locale: localeName,
    );
  }

  String get navbarFridge {
    return Intl.message(
      'My Fridge',
      name: 'navbarFridge',
      desc: "My Fridge button in the bottom navigation",
      locale: localeName,
    );
  }

  String get fridgeTitle {
    return Intl.message(
      'My Fridge',
      name: 'fridgeTitle',
      desc: "Tile of my fridge page",
      locale: localeName,
    );
  }

  String get addItemNewTile {
    return Intl.message(
      'Add New Item',
      name: 'addItemNewTile',
      desc: 'Tile of adding new grocery item',
      locale: localeName,
    );
  }

  String get addItemExistingTile {
    return Intl.message(
      'Edit',
      name: 'addItemExistingTile',
      desc: 'Tile of updating existing grocery item',
      locale: localeName,
    );
  }

  String get addItemNameLabel {
    return Intl.message(
      'Name',
      name: 'addItemNameLabel',
      desc: 'Name field label',
      locale: localeName,
    );
  }

  String get addItemNameHint {
    return Intl.message(
      'Milk',
      name: 'addItemNameHint',
      desc: 'Name field hint',
      locale: localeName,
    );
  }

  String get addItemQuantityLabel {
    return Intl.message(
      'Quantity',
      name: 'addItemQuantityLabel',
      desc: 'Quantity field label',
      locale: localeName,
    );
  }

  String get addItemQuantityHint {
    return Intl.message(
      '5',
      name: 'addItemQuantityHint',
      desc: 'Quantity field hint',
      locale: localeName,
    );
  }

  String get addItemSave {
    return Intl.message(
      'Save',
      name: 'addItemSave',
      desc: 'Save button in add new item',
      locale: localeName,
    );
  }

  String get addItemQuantityEmpty {
    return Intl.message(
      'Quantity cannot be empty',
      name: 'addItemQuantityEmpty',
      desc: 'Quantity field empty error',
      locale: localeName,
    );
  }

  String get addItemQuantityZero {
    return Intl.message(
      'Quantity has to be more than 0',
      name: 'addItemQuantityZero',
      desc: 'Quantity field zero error',
      locale: localeName,
    );
  }

  String get addItemNotification {
    return Intl.message(
      'Notify Days Before Expiry',
      name: 'addItemNotification',
      desc: 'Notification field on item add.',
      locale: localeName,
    );
  }

  String get addItemExpiry {
    return Intl.message(
      'Expiry Date',
      name: 'addItemExpiry',
      desc: 'Expiry date field on item add.',
      locale: localeName,
    );
  }

  String get addItemNameEmpty {
    return Intl.message(
      'Name must be entered',
      name: 'addItemNameEmpty',
      desc: 'Name field empty error',
      locale: localeName,
    );
  }

  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: 'Logout button in menu selection',
      locale: localeName,
    );
  }

  String get sortAlphabetically {
    return Intl.message(
      'Sort Alphabetically',
      name: 'sortAlphabetically',
      desc: 'Sort Alphabetically button in menu selection',
      locale: localeName,
    );
  }

  String get sortExpiry {
    return Intl.message(
      'Sort by Expiry Date',
      name: 'sortExpiry',
      desc: 'Sort by Expiry Date button in menu selection',
      locale: localeName,
    );
  }

  String get loginEmailLabel {
    return Intl.message(
      'Email',
      name: 'loginEmailLabel',
      desc: 'Email field in login page',
      locale: localeName,
    );
  }

  String get loginPasswordLabel {
    return Intl.message(
      'Password',
      name: 'loginPasswordLabel',
      desc: 'Password field in login page',
      locale: localeName,
    );
  }

  String get loginButtonLabel {
    return Intl.message(
      'Login',
      name: 'loginButtonLabel',
      desc: 'Login button in login page',
      locale: localeName,
    );
  }

  String get loginCreateAccount {
    return Intl.message(
      'Create an Account',
      name: 'loginCreateAccount',
      desc: 'Create an account button in login page',
      locale: localeName,
    );
  }

  String get loginPasswordEmpty {
    return Intl.message(
      'Password can\'t be empty',
      name: 'loginPasswordEmpty',
      desc: 'Empty password error',
      locale: localeName,
    );
  }

  String get appItemSearch {
    return Intl.message(
      'Search',
      name: 'appItemSearch',
      desc: 'Search label when searching in home or fridge',
      locale: localeName,
    );
  }
}

class CustomLocalizationsDelegate
    extends LocalizationsDelegate<CustomLocalizations> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'fr', 'zh'].contains(locale.languageCode);

  @override
  Future<CustomLocalizations> load(Locale locale) =>
      CustomLocalizations.load(locale);

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}
