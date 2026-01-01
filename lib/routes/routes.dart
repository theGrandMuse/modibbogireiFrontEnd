// routes.dart

class TRoutes {
  static const login = '/login';
  static const forgetPassword = '/forgetPassword';
  static const resetPassword = '/resetPassword';
  static const dashboard = '/dashboard';
  static const cart = '/cart';
  static const saveStatus = '/saveStatus';
  static const salesHistory = '/salesHistory';
  static const receipt = '/receipt';
  static const printScreen = '/printScreen';
  static const printScreenTwo = '/printScreenTwo';
  static const saveStatusReprint = '/saveStatusReprint';
  static const populationPage = '/populationPage';
  static const addToCartPage = '/addToCart';

  static const settings = '/settings';
  static const profile = '/profile';
  static const logout = '/logout';

  static List sideMenuItems = [
    login,
    forgetPassword,
    dashboard,
    cart,
    saveStatus,
    receipt,
    saveStatusReprint,
    printScreen,
    printScreenTwo,
    populationPage,
    salesHistory,
    settings,
    profile,
    logout
  ];
}

// All App Screens
class AppScreens {
  static const home = '/';
  static const userProfile = '/user-profile';
  static const verifyEmail = '/verify-email';
  static const signIn = '/sign-in';
  static const resetPassword = '/reset-password';
  static const forgetPassword = '/forget-password';

  static List<String> allAppScreenItems = [
    signIn,
    verifyEmail,
    resetPassword,
    forgetPassword,
    home,
    userProfile,
  ];
}
