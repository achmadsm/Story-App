class PageConfiguration {
  final bool unknown;
  final bool register;
  final bool? loggedIn;
  final String? id;

  PageConfiguration.splash()
      : unknown = false,
        register = false,
        loggedIn = null,
        id = null;

  PageConfiguration.login()
      : unknown = false,
        register = false,
        loggedIn = false,
        id = null;

  PageConfiguration.register()
      : unknown = false,
        register = true,
        loggedIn = false,
        id = null;

  PageConfiguration.home()
      : unknown = false,
        register = false,
        loggedIn = true,
        id = null;

  PageConfiguration.detailStory(String this.id)
      : unknown = false,
        register = false,
        loggedIn = true;

  PageConfiguration.unknown()
      : unknown = true,
        register = false,
        loggedIn = null,
        id = null;

  bool get isSplashPage =>
      unknown == false && register == false && loggedIn == null && id == null;

  bool get isLoginPage =>
      unknown == false && register == false && loggedIn == false && id == null;

  bool get isRegisterPage =>
      unknown == false && register == true && loggedIn == false && id == null;

  bool get isHomePage =>
      unknown == false && register == false && loggedIn == true && id == null;

  bool get isDetailPage =>
      unknown == false && register == false && loggedIn == true && id != null;

  bool get isUnknownPage =>
      unknown == true && register == false && loggedIn == null && id == null;
}
