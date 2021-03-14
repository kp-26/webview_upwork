import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  InAppWebViewController _webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          allowFileAccessFromFileURLs: true),
      android: AndroidInAppWebViewOptions(
          useHybridComposition: true, allowFileAccess: true),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffcc0400),
        title: Text("SUIBOX"),
      ),
      body: SafeArea(
          child: Container(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse("https://suibox.my/merchant")),
              // initialUrlRequest: URLRequest(
              //     url: Uri.parse(
              //         "https://suibox.my/merchant-profile.php?uurl=73")),
              // initialOptions: InAppWebViewGroupOptions(
              //   crossPlatform: InAppWebViewOptions(
              //     mediaPlaybackRequiresUserGesture: false,
              //   ),
              // ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              initialOptions: options,
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (InAppWebViewController controller,
                  NavigationAction navigationAction) async {
                print("****** ${navigationAction.request.url.toString()} ******");
                if ((navigationAction.request.url.toString().contains("wa.me")) || (navigationAction.request.url.toString().contains("api.whatsapp.com")) || (navigationAction.request.url.toString().contains("whatsapp://send"))) {
                  // if (navigationAction.request.url.toString().contains("wa.me")) {
                  //   String number = navigationAction.request.url.path.replaceAll("/", "");
                  // String url = "whatsapp://send/?phone=$number&text&app_absent=0";
                  String url = navigationAction.request.url.toString();
                  print("=============== URL :: $url");
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print("================== in else");
                    throw 'Could not launch $url';
                  }
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
          )),
    );
  }
}
