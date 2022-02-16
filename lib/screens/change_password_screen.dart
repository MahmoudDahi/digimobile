import 'package:digimobile/providers/user.dart';
import 'package:digimobile/widgets/digi_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change-password';
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _currentPassword;
  String _newPassword;

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;
  final _newPasswordNode = FocusNode();
  final _confirmPasswordNode = FocusNode();

  @override
  void dispose() {
    _newPasswordNode.dispose();
    _confirmPasswordNode.dispose();

    super.dispose();
  }

  void _showDialogWithMessage(String error) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor:
            error == null ? Colors.green[400] : Theme.of(context).errorColor,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              AppLocalizations.of(context).change_password,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              error == null
                  ? AppLocalizations.of(context).change_password_success
                  : error,
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).confirm,
                style: TextStyle(
                  color: error == null
                      ? Colors.green[400]
                      : Theme.of(context).errorColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitedChangePassword() async {
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    bool valid = _formKey.currentState.validate();
    if (valid) {
      setState(() {
        _isLoading = true;
      });

      try {
        final _errorFailed = await Provider.of<User>(context, listen: false)
            .changePassword(_currentPassword, _newPassword);
        _showDialogWithMessage(_errorFailed);
      } catch (error) {
        _showDialogWithMessage(error.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).change_password)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) => _currentPassword = value.trim(),
                  validator: (value) {
                    if (value.isEmpty)
                      return AppLocalizations.of(context)
                          .error_current_password;
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_newPasswordNode);
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    label: Text(AppLocalizations.of(context).current_password),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideCurrentPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideCurrentPassword = !_hideCurrentPassword;
                        });
                      },
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _hideCurrentPassword,
                ),
                SizedBox(height: 14),
                TextFormField(
                  onSaved: (value) => _newPassword = value.trim(),
                  validator: (value) {
                    if (value.isEmpty)
                      return AppLocalizations.of(context).error_new_password;
                    return null;
                  },
                  focusNode: _newPasswordNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    label: Text(AppLocalizations.of(context).new_password),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideNewPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideNewPassword = !_hideNewPassword;
                        });
                      },
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _hideNewPassword,
                ),
                SizedBox(height: 14),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return AppLocalizations.of(context)
                          .error_confirm_password_again;
                    if (value.trim() != _newPassword)
                      return AppLocalizations.of(context)
                          .error_confirm_password;
                    return null;
                  },
                  focusNode: _confirmPasswordNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    label: Text(AppLocalizations.of(context).confirm_password),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideConfirmPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideConfirmPassword = !_hideConfirmPassword;
                        });
                      },
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _hideConfirmPassword,
                ),
                SizedBox(height: 24),
                DigiButton(
                  onPressed: _submitedChangePassword,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(AppLocalizations.of(context).change_password),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
