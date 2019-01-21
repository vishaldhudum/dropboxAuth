        import 'package:flutter/material.dart';
        import 'package:simple_auth/simple_auth.dart' as simpleAuth;
        import 'package:simple_auth_flutter/simple_auth_flutter.dart';
        import 'package:url_launcher/url_launcher.dart';
        import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
        
        void main() => runApp(MyApp());
        
        class MyApp extends StatefulWidget {
          @override
          _MyAppState createState() => _MyAppState();
        }
        
        class _MyAppState extends State<MyApp> {
          @override
          initState() {
            super.initState();
            SimpleAuthFlutter.init(context);
          }
        
          @override
          Widget build(BuildContext context) {
            return MaterialApp(
              title: "Dropbox Auth",
              routes:  <String, WidgetBuilder>{
                '/': (BuildContext context) => MyHomePage(),
                '/dropboxauth': (BuildContext context) => DropboxWelcomePage(),
              },
            );
          }
        }
        
        
        class MyHomePage extends StatefulWidget {
          @override
          _MyHomePageState createState() => _MyHomePageState();
        }
        
        class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
        
          final simpleAuth.DropboxApi dropboxApi = new simpleAuth.DropboxApi(
            "dropbox", "txuseickomozz9q", "aa7qrc3z8h1iz0v", "https://dropboxauth.page.link/dropboxauth");
        
          @override
          void initState() {
            super.initState();
            _retrieveDynamicLink();
            WidgetsBinding.instance.addObserver(this);
          }
        
          @override
          void dispose() {
            super.dispose();
            WidgetsBinding.instance.removeObserver(this);
          }
        
          @override
          void didChangeAppLifecycleState(AppLifecycleState state) {
            if (state == AppLifecycleState.resumed) {
              _retrieveDynamicLink();
            }
          }
        
          Future<void> _retrieveDynamicLink() async {
            final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.retrieveDynamicLink();
            final Uri deepLink = data?.link;
        
            if (deepLink != null) {
              Navigator.pushNamed(context, deepLink.path);
            }
          }
        
          @override
          Widget build(BuildContext context) {
            SimpleAuthFlutter.context = context;
            return Scaffold(
              appBar: AppBar(
                title: Text("Dropbox Auth"),
              ),
              body: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "Dropbox Auth",
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.launch),
                    title: Text('Login'),
                    onTap: () {
                      login(dropboxApi);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Logout'),
                    onTap: () {
                      logout(dropboxApi);
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Test Deeplink",
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.launch),
                    title: Text('Deep Link'),
                    onTap: () async {
                      await launch("https://dropboxauth.page.link/dropboxauth");
                    },
                  ),
                ],
              )
            );
          }
        
          void showError(dynamic ex) {
            showMessage(ex.toString());
          }
        
          void showMessage(String text) {
            var alert = new AlertDialog(content: new Text(text), actions: <Widget>[
              new FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                }
              )
            ]);
        
            showDialog(context: context, builder: (BuildContext context) => alert);
          }
        
          void login(simpleAuth.AuthenticatedApi api) async {
            try {
              var success = await api.authenticate();
              showMessage("Logged in success: $success");
            } catch (e) {
              showError(e);
            }
          }
        
          void logout(simpleAuth.AuthenticatedApi api) async {
            await api.logOut();
            showMessage("Logged out");
          }
        }
        
        class DropboxWelcomePage extends StatelessWidget {
          @override
          Widget build(BuildContext context) {
            return Scaffold(
              body: Container(
                child: Center(
                  child: Text("Dropbox authenticated"),
                ), 
              ),
            );
          }
        }
        
