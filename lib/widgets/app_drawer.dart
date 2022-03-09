import 'package:digimobile/screens/documents_values_screen.dart';
import 'package:digimobile/screens/mof_rejected_screen.dart';
import 'package:digimobile/screens/payment_screen.dart';
import 'package:digimobile/screens/waiting_screen.dart';
import 'package:digimobile/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/user.dart';
import '../providers/app_setting.dart';
import '../screens/change_password_screen.dart';
import '../screens/document_count_screen.dart';
import '../screens/customers_report_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget _listTitleItem(
      BuildContext context, String title, IconData icon, Function onTap) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline2,
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/digi.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'DigiMobile',
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
             _listTitleItem(
                context,
                AppLocalizations.of(context).payment,
                Icons.payment,() {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(PaymentScreen.routeName);
            }),
             _listTitleItem(
                context,
                AppLocalizations.of(context).wallet,
                Icons.account_balance_wallet,() {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(WalletScreen.routeName);
            }),
            _listTitleItem(
                context,
                AppLocalizations.of(context).customers_report,
                Icons.note_alt_rounded, () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(CustomersReportScreen.routeName);
            }),
            _listTitleItem(context, AppLocalizations.of(context).mof_rejected,
                Icons.note_alt_rounded, () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MOFRejectedScreen.routeName);
            }),
            _listTitleItem(
                context,
                AppLocalizations.of(context).doucments_count,
                Icons.document_scanner, () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(DoucmentCountScreen.routeName);
            }),
            _listTitleItem(
                context,
                AppLocalizations.of(context).doucments_values,
                Icons.document_scanner, () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(DoucmentsValuesScreen.routeName);
            }),
            _listTitleItem(
                context,
                AppLocalizations.of(context).change_password,
                Icons.password_rounded, () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
            }),
            Consumer<AppSetting>(
              builder: (ctx, sett, _) => ListTile(
                title: Text(
                  AppLocalizations.of(context).dark_theme,
                  style: Theme.of(context).textTheme.headline2,
                ),
                leading: Icon(
                  Icons.style,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Switch.adaptive(
                  value: sett.isDark,
                  onChanged: (value) {
                    sett.changeTheme(value);
                  },
                ),
              ),
            ),
            _listTitleItem(
                context,
                AppLocalizations.of(context).change_language,
                Icons.language_outlined, () {
              Provider.of<AppSetting>(context, listen: false).changeLanguage();
            }),
            _listTitleItem(context, AppLocalizations.of(context).logout,
                Icons.logout_rounded, () {
              Provider.of<User>(context, listen: false).logout();
            }),
          ],
        ),
      ),
    );
  }
}
