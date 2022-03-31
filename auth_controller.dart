  Future<void> getInstagramUserId(String code) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var request = await http.post(
        Uri.parse('https://api.instagram.com/oauth/access_token'),
        headers: headers,
        body: {
          'grant_type': 'authorization_code',
          'client_id': 'CLIENT_ID',
          'code': code,
          'client_secret': 'CLIENT_SCRET',
          'redirect_uri': 'redirect_uri'
        });
    if (request.statusCode == 200) {
      var result = jsonDecode(request.body);
      int instaUserID = result['user_id'];
      String token = result['access_token'];
      instUserId = instaUserID;
      signinWithInstagram(instaUserID);
      getInstagramUsername(instaUserID, token);
    } else {
      request.reasonPhrase;
    }
  }

  late String instaUsername;
  Future<void> getInstagramUsername(int userId, String accesToken) async {
    stackIndex = 2;
    var request = await http.get(Uri.parse(
        'https://graph.instagram.com/$userId?fields=username,media&access_token=$accesToken'));


    if (request.statusCode == 200) {
      var result = jsonDecode(request.body);

      var media = jsonDecode(request.body)['media'];
      instaUsername = result['username'];
    } else {
      request.reasonPhrase;
    }
    update();
  }

  static const String appId = 'APP_ID';
  static const String appSecret = 'APP_SCRET';
  static const String redirectUri = 'REDIRECT_URL';
  final authFunctionUrl =
      'AUTH FUNCTION URL';
  RxBool showInstagramSingUpWeb = false.obs;

  Future<void> signinWithInstagram(int userId) async {
    stackIndex = 2;

    try {
      final http.Response responseCustomToken =
          await http.get(Uri.parse('$authFunctionUrl?instagramToken=$userId'));

      await FirebaseAuth.instance
          .signInWithCustomToken(
              jsonDecode(responseCustomToken.body)['customToken'])
          .then((_authResult) {
        _authResult.user!.updateDisplayName(instaUsername);
        Get.toNamed(RoutesNames.homeScreen);
      }).catchError((error) {
        errorSnackbar('error', error.toString());
      });
      stackIndex = 1;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    update();
  }
