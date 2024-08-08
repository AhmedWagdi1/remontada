class ConstKeys {
  static const devEnv = false;
  static const baseUrlDev = "https://match.almasader.net/api";
  //  const String.fromEnvironment("BASE_URL_DEV");
  static const uUidlDev = "00000000-0000-0000-0000-000000000000";
  //  const String.fromEnvironment("uUidL_DEV");
  static const baseUrlLive = "https://rmontada.com/api";
  static const uUidLive = const String.fromEnvironment("uUid");
  static const moyaser = "";
  static String paymentKeyLive = '';
  static String paymentKeyTest = '';

  static String get paymentKey => devEnv ? paymentKeyTest : paymentKeyLive;
  static String get baseUrl => devEnv ? baseUrlDev : baseUrlLive;
  static String get uUid => devEnv ? uUidlDev : uUidLive;

  static get baseNoApi {
    return baseUrl.replaceAll("/api", "");
  }
}
