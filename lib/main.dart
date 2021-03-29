import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const TextStyle kTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter AdMob Test Ads App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter AdMob Test Ads App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InterstitialAd interstitial;
  RewardedAd rewardedAd;
  int coins = 0;

  void createInterstitialAd() {
    interstitial = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('${ad.runtimeType} loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('${ad.runtimeType} opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed');
          ad.dispose();
          createInterstitialAd();
          print('${ad.runtimeType} reloaded');
        },
        // Called when an ad is in the process of leaving the application.
        onApplicationExit: (Ad ad) => print('Left application.'),
      ),
    )..load();
  }

  void createRewardedAd() {
    rewardedAd = RewardedAd(
      adUnitId: RewardedAd.testAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('${ad.runtimeType} loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('${ad.runtimeType} opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed');
          ad.dispose();
          createRewardedAd();
          print('${ad.runtimeType} reloaded');
        },
        // Called when an ad is in the process of leaving the application.
        onApplicationExit: (Ad ad) => print('Left application.'),
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
          print(reward.type);
          print(reward.amount);
          setState(() {
            coins = reward.amount + coins;
          });
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    //load ads
    createInterstitialAd();
    createRewardedAd();
  }

  @override
  void dispose() {
    interstitial.dispose();
    rewardedAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildScafold(widget.title, buildHomePage());
  }

  void onPressedInterstitialAdButton() {
    interstitial.show();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InterstitialAdPage()),
    );
  }

  void onPressedRewardedAdButton() {
    rewardedAd.show();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RewardedAdPage()),
    );
  }

  void onPressedBannerAdButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BannerAdPage()),
    );
  }

  Widget buildButton(String buttonTxt, Function onPressedFunction) {
    return ElevatedButton(
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all<Color>(Colors.black),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Padding(
        padding: EdgeInsets.all(9.0),
        child: Text(
          buttonTxt,
          style: kTextStyle,
        ),
      ),
      onPressed: onPressedFunction,
    );
  }

  Widget buildHomePage() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: Text(
                  'Reward Coins',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.stars,
                color: Color(0xFFFFD700),
                size: 50.0,
              ),
              Text(
                coins.toString(),
                style: TextStyle(fontSize: 50.0),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceEvenly,
              direction: Axis.vertical,
              children: <Widget>[
                buildButton('Rewarded Ad', onPressedRewardedAdButton),
                buildButton('Interstitial Ad', onPressedInterstitialAdButton),
                buildButton('Banner Ad', onPressedBannerAdButton),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget buildScafold(String title, Widget child) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      title: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 9.0,
        children: [
          Icon(
            Icons.ad_units,
            color: Colors.black,
          ),
          Text(
            title,
            style: kTextStyle,
          )
        ],
      ),
    ),
    body: child,
  );
}

class BannerAdPage extends StatefulWidget {
  @override
  _BannerAdPageState createState() => _BannerAdPageState();
}

class _BannerAdPageState extends State<BannerAdPage> {
  BannerAd banner;

  void createBannerAd() {
    banner = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('${ad.runtimeType} loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('${ad.runtimeType} opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed');
          ad.dispose();
          createBannerAd();
          print('${ad.runtimeType} reloaded');
        },
        // Called when an ad is in the process of leaving the application.
        onApplicationExit: (Ad ad) => print('Left application.'),
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    createBannerAd();
  }

  @override
  void dispose() {
    banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildScafold(
      'Banner Ad Page',
      Align(
        alignment: Alignment.bottomCenter,
        child: banner == null
            ? SizedBox(
                height: 50,
              )
            : Container(
                height: 50,
                child: AdWidget(
                  ad: banner,
                ),
              ),
      ),
    );
  }
}

class InterstitialAdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildScafold('Interstitial Ad Page', Container());
  }
}

class RewardedAdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildScafold('Rewarded Ad Page', Container());
  }
}