import 'dart:io';

class AdHelper {
  static String homePageBanner() {
    if (Platform.isAndroid) {
      return "ca-app-pub-8963258830964668/7156906146";
    } else {
      return "";
    }
  }

  static String detailPageBanner() {
    if (Platform.isAndroid) {
      return "ca-app-pub-8963258830964668/1143513209";
    } else {
      return "";
    }
  }

  static String editAndAddPageBanner() {
    if (Platform.isAndroid) {
      return "ca-app-pub-8963258830964668/7448550181";
    } else {
      return "";
    }
  }

  static String favPageBanner() {
    if (Platform.isAndroid) {
      return "ca-app-pub-8963258830964668/4908101030";
    } else {
      return "";
    }
  }

  static String fullPageAd() {
    if (Platform.isAndroid) {
      return "ca-app-pub-8963258830964668/9854634940";
    } else {
      return "";
    }
  }

  static String fullPageAdAddAndEdit() {
    if (Platform.isAndroid) {
      return "ca-app-pub-8963258830964668/1033219023";
    } else {
      return "";
    }
  }
}
