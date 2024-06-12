import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'utils.dart';

extension Photo on String {
  String png([String? path = "images"]) => 'assets/$path/$this.png';
  String svg([String path = "icons"]) => 'assets/$path/$this.svg';
  String jpeg([String path = "icons"]) => 'assets/$path/$this.jpg';
}

extension Dates on String {
  String nameFromUrl() {
    int index = lastIndexOf("/") + 1;
    return replaceRange(0, index, "") /* .replaceAll(".pdf", "") */;
  }

  String formattedDate([String format = "d - M - y"]) {
    if (isNotEmpty) {
      DateTime date = DateTime.parse(this);
      return DateFormat(format, "ar").format(date);
    }

    return "";
  }
}

// context extentions

extension ContextExtensions on BuildContext {
  // size
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  // theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  bool get isLight => Theme.of(this).brightness == Brightness.light;
}

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(
        height: this.toDouble().h,
      );
  SizedBox get pw => SizedBox(
        width: this.toDouble().w,
      );
}

extension MySLiverBox on Widget {
  SliverToBoxAdapter get SliverBox => SliverToBoxAdapter(
        child: this,
      );
  SliverToBoxAdapter get SliverPadding => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: this,
        ),
      );
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  // remove zero from the start of the string
  String get removeZero {
    if (this.startsWith("0")) {
      return this.substring(1);
    } else {
      return this;
    }
  }

  String get to24h {
    // should be en_us to send
    final parse = DateFormat("hh:mm a", Utils.lang).parse(this);
    return DateFormat("HH:mm", "en_us").format(parse);
  }

  String get formateDate {
    var date = DateTime.tryParse(this) ?? DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm", "en").format(
      date,
    );
  }

  String get formateDateTime {
    var date = DateTime.tryParse(this) ?? DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm:ss", "en").format(
      date,
    );
  }

  String get formateDateOnly {
    var date = DateTime.tryParse(this) ?? DateTime.now();
    return DateFormat("yyyy-MM-dd", "en").format(
      date,
    );
  }

  String formattedDate([String format = "d - M - y"]) {
    if (isNotEmpty) {
      DateTime date = DateTime.parse(this);
      return DateFormat(format, "ar").format(date);
    }

    return "";
  }

  // todouble
  double toDouble() => double.tryParse(this ?? "0") ?? 0;

  toColor() {
    var hexColor = this.replaceAll("#", ""); //0xff012547
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

extension DoubleExtensions on num? {
  String get roundTo2numberString {
    return this == null
        ? "0"
        : this!.truncateToDouble() == this!
            ? this!.toStringAsFixed(0)
            : this!.toStringAsFixed(2);
  }

  String get roundTo4numberString {
    return this == null
        ? "0"
        : this!.truncateToDouble() == this!
            ? this!.toStringAsFixed(0)
            : this!.toStringAsFixed(4);
  }
}

extension formatData on DateTime {
  String get formatedDateTime =>
      DateFormat("yyyy-MM-dd HH:mm", "en").format(this);
}

extension LocalReverse on List {
  get reverseLocal {
    if (Utils.lang == "ar") {
      return reversed.toList();
    }
    return this;
  }
}
