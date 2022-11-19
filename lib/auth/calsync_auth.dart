import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provides the `GoogleSignIn` class
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class CalsyncAuth extends StatefulWidget {
  const CalsyncAuth({Key? key}) : super(key: key);

  @override
  State<CalsyncAuth> createState() => _CalsyncAuthState();
}

class _CalsyncAuthState extends State<CalsyncAuth> {
  // FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignInAccount? _currentUser;
  String calList = "Empty Calendar List";
  String userDetails = "user";
  late final GoogleSignIn _googleSignIn; // initialize at runtime

  // String getClientId() {
  //   final response = rootBundle.loadString('assets/client_secret.json')
  //       as String; // load client_secret.json
  //   Map<String, dynamic> clientId =
  //       jsonDecode(response); // Get the client id from json object
  //   print(clientId);
  //   return clientId["client_id"].toString();
  // }

  @override
  void initState() {
    super.initState();

    _googleSignIn = GoogleSignIn(
      scopes: <String>[CalendarApi.calendarScope],
      serverClientId: Platform.isAndroid
          ? "466724563377-lbfuln359gn1fkcnm41vk92fiqmvt825.apps.googleusercontent.com"
          : "466724563377-na4725bb0fmgl93mhrqj60brcbpehqkg.apps.googleusercontent.com", // getClientId(),
    );

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        if (kDebugMode) {
          print("Not signed in");
        }
        getCalendars();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> getCalendars() async {
    // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
    final auth.AuthClient? client = await _googleSignIn
        .authenticatedClient(); // a subscription to when the current user changes

    assert(client != null, 'Authenticated client missing!');

    var gCalAPI = CalendarApi(client!);
    calList = (await gCalAPI.calendarList.list(maxResults: 5))
        .items
        ?.first
        .description as String;
    setState(() {
      if (kDebugMode) {
        // calList = calendarList as String;
        print(calList);
      }
    });
  }

  void listCalendars() {
    getCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ElevatedButton(
        //     onPressed: _handleSignIn, child: Text("Sign in to google")),
        ElevatedButton(onPressed: listCalendars, child: Text("List calendars")),
        Text(calList),
        Text(userDetails)
      ],
    );
  }
}
