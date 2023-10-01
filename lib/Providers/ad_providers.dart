import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sqflite_database_example/Services/Adhelper.dart';

class AdProvider with ChangeNotifier {
  bool isHomePageBannerLoaded = false;
  late BannerAd homePageBanner;

  bool isDetailsPageBannerLoaded = false;
  late BannerAd detailPageBanner;

  bool isAddEditPageBannerLoaded = false;
  late BannerAd addEditPageBanner;

  bool isFavAdLoaded = false;
  late BannerAd favPageAd;

  bool isFullPageAdLoaded = false;
  late InterstitialAd fullPageAd;

  bool isFullPageAdEditAndAddLoaded = false;
  late InterstitialAd fullPageAdEditAndAdd;

  void initializeHomePageBanner() async {
    homePageBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.homePageBanner(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log("HomePage Banner Loaded");
          isHomePageBannerLoaded = true;
          notifyListeners(); // Move this line here
        },
        onAdClosed: (ad) {
          ad.dispose();
          isHomePageBannerLoaded = false;
          notifyListeners(); // And here
        },
        onAdFailedToLoad: (ad, error) {
          log(error.toString());
          isHomePageBannerLoaded = false;
          notifyListeners(); // And here
        },
      ),
      request: const AdRequest(),
    );

    await homePageBanner.load();
  }

  void initializeDetailPageBanner() async {
    detailPageBanner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.detailPageBanner(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            log("Detail Banner Loaded");
            isDetailsPageBannerLoaded = true;
            notifyListeners();
          },
          onAdClosed: (ad) {
            ad.dispose();
            isDetailsPageBannerLoaded = false;
            notifyListeners();
          },
          onAdFailedToLoad: (ad, error) {
            log(error.toString());
            isDetailsPageBannerLoaded = false;
            notifyListeners();
          },
        ),
        request: const AdRequest());
    await detailPageBanner.load();
  }

  void initializeEditAndAddPageBanner() async {
    addEditPageBanner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.editAndAddPageBanner(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            log("Edit And Add Banner Loaded");
            isAddEditPageBannerLoaded = true;
            notifyListeners();
          },
          onAdClosed: (ad) {
            ad.dispose();
            isAddEditPageBannerLoaded = false;
            notifyListeners();
          },
          onAdFailedToLoad: (ad, error) {
            log(error.toString());
            isAddEditPageBannerLoaded = false;
            notifyListeners();
          },
        ),
        request: const AdRequest());
    await addEditPageBanner.load();
  }

  void initializFavPageBanner() async {
    favPageAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.favPageBanner(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            log("Favourite Banner Loaded");
            isFavAdLoaded = true;
            notifyListeners();
          },
          onAdClosed: (ad) {
            ad.dispose();
            isFavAdLoaded = false;
            notifyListeners();
          },
          onAdFailedToLoad: (ad, error) {
            log(error.toString());
            isFavAdLoaded = false;
            notifyListeners();
          },
        ),
        request: const AdRequest());
    await favPageAd.load();
  }

  void initializeFullPageAd() async {
    await InterstitialAd.load(
        adUnitId: AdHelper.fullPageAd(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdFailedToLoad: (error) {
            log(error.toString());
            isFullPageAdLoaded = false;
            notifyListeners();
          },
          onAdLoaded: (ad) {
            log("Full Edit And Add Page Ad Loaded");
            fullPageAd = ad;
            isFullPageAdLoaded = true;
            notifyListeners();
          },
        ));
  }

  void initializeFullPageForAddAndEditAd() async {
    await InterstitialAd.load(
        adUnitId: AdHelper.fullPageAdAddAndEdit(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdFailedToLoad: (error) {
            log(error.toString());
            isFullPageAdEditAndAddLoaded = false;
            notifyListeners();
          },
          onAdLoaded: (ad) {
            log("Full Page Ad Loaded");
            fullPageAdEditAndAdd = ad;
            isFullPageAdEditAndAddLoaded = true;
            notifyListeners();
          },
        ));
  }
}
