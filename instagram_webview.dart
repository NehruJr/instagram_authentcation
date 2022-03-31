class InstaWebview extends StatelessWidget {
  InstaWebview(Key? key) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String clientId = 'CLIENT ID';
    String redirectUri = 'REDIRECT URL';
    String initialUrl =
        'https://api.instagram.com/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=code';

    return WebView(
            initialUrl: initialUrl,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith(redirectUri)) {
                if (request.url.contains('error')) {}
                var startIndex = request.url.indexOf('code=');
                var code = request.url.substring(startIndex + 5);
                authController.getInstagramUserId(code);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (url) {
              if (kDebugMode) {
                print("Page started " + url);
              }
            },
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onPageFinished: (url) {
            },
          );
        
  }
}
