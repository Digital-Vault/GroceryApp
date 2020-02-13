// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "addItemExistingTile": MessageLookupByLibrary.simpleMessage("Edit"),
        "addItemExpiry": MessageLookupByLibrary.simpleMessage("Expiry Date"),
        "addItemNameEmpty":
            MessageLookupByLibrary.simpleMessage("Name must be entered"),
        "addItemNameHint": MessageLookupByLibrary.simpleMessage("Milk"),
        "addItemNameLabel": MessageLookupByLibrary.simpleMessage("Name"),
        "addItemNewTile": MessageLookupByLibrary.simpleMessage("Add New Item"),
        "addItemNotification":
            MessageLookupByLibrary.simpleMessage("Notify Days Before Expiry"),
        "addItemQuantityEmpty":
            MessageLookupByLibrary.simpleMessage("Quantity cannot be empty"),
        "addItemQuantityHint": MessageLookupByLibrary.simpleMessage("5"),
        "addItemQuantityLabel":
            MessageLookupByLibrary.simpleMessage("Quantity"),
        "addItemQuantityZero": MessageLookupByLibrary.simpleMessage(
            "Quantity has to be more than 0"),
        "addItemSave": MessageLookupByLibrary.simpleMessage("Save"),
        "appItemSearch": MessageLookupByLibrary.simpleMessage("Search"),
        "dateDialogExpiry":
            MessageLookupByLibrary.simpleMessage("Enter in expiry date"),
        "dateDialogNotify": MessageLookupByLibrary.simpleMessage("Notify me"),
        "dateDialogSubmit": MessageLookupByLibrary.simpleMessage("Submit"),
        "dateDialogTitle": MessageLookupByLibrary.simpleMessage(
            "Please enter in expiry date and notification time"),
        "fridgeExpiryDateExpired":
            MessageLookupByLibrary.simpleMessage("has expired"),
        "fridgeExpiryDateFirstPart":
            MessageLookupByLibrary.simpleMessage("expires in"),
        "fridgeExpiryDateNotEntered":
            MessageLookupByLibrary.simpleMessage("Expiry date not entered for"),
        "fridgeExpiryDateSecondPart":
            MessageLookupByLibrary.simpleMessage("days"),
        "fridgeTitle": MessageLookupByLibrary.simpleMessage("My Fridge"),
        "homeTitle": MessageLookupByLibrary.simpleMessage("Home"),
        "loginButtonLabel": MessageLookupByLibrary.simpleMessage("Login"),
        "loginCreateAccount":
            MessageLookupByLibrary.simpleMessage("Create an Account"),
        "loginEmailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "loginPasswordEmpty":
            MessageLookupByLibrary.simpleMessage("Password can\'t be empty"),
        "loginPasswordLabel": MessageLookupByLibrary.simpleMessage("Password"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "navbarFridge": MessageLookupByLibrary.simpleMessage("My Fridge"),
        "navbarHome": MessageLookupByLibrary.simpleMessage("Grocery List"),
        "sortAlphabetically":
            MessageLookupByLibrary.simpleMessage("Sort Alphabetically"),
        "sortExpiry":
            MessageLookupByLibrary.simpleMessage("Sort by Expiry Date"),
        "title": MessageLookupByLibrary.simpleMessage("Grocery App")
      };
}
