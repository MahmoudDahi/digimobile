import 'dart:io';

import 'package:digimobile/models/exception.dart';
import 'package:digimobile/providers/entity.dart';
import 'package:digimobile/providers/user.dart';
import 'package:digimobile/widgets/digi_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class InputLogin extends StatefulWidget {
  @override
  _InputLoginState createState() => _InputLoginState();
}

class _InputLoginState extends State<InputLogin> {
  bool _hidePassword = true;
  bool _isLoading = false;
  String _error;
  final _formkey = GlobalKey<FormState>();
  String _userName;
  String _password;
  EntityItem _Entity;
  final _passwordFoucs = FocusNode();

  @override
  void dispose() {
    _passwordFoucs.dispose();
    super.dispose();
  }

  void _submittedLogin() async {
    bool valid = _formkey.currentState.validate();
    if (valid) {
      FocusScope.of(context).unfocus();
      _formkey.currentState.save();
      setState(() {
        _isLoading = true;
        _error = null;
      });

      try {
        await Provider.of<User>(context, listen: false)
            .loginUser(_userName, _password, _Entity.id, _Entity.title);
      } on ExceptionError catch (error) {
        setState(() {
          _isLoading = false;
          _error = error.toString();
        });
      } on SocketException catch (_) {
        setState(() {
          _isLoading = false;
          _error = AppLocalizations.of(context).no_internet_connection;
        });
      } catch (error) {
        var stringError = error.toString();
        if (stringError == 'Failed to parse header value')
          stringError = 'Username or Password not correct';
        setState(() {
          _isLoading = false;
          _error = stringError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: ValueKey('user'),
            onSaved: (value) => _userName = value.trim(),
            validator: (value) {
              if (value.isEmpty)
                return AppLocalizations.of(context).error_username;
              return null;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              label: Text(AppLocalizations.of(context).username),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFoucs);
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            onSaved: (value) => _password = value.trim(),
            validator: (value) {
              if (value.isEmpty)
                return AppLocalizations.of(context).error_password;
              return null;
            },
            focusNode: _passwordFoucs,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              label: Text(AppLocalizations.of(context).password),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: _hidePassword,
          ),
          SizedBox(height: 16),
          Consumer<Entity>(
            builder: (context, entity, _) =>
                DropdownButtonFormField<EntityItem>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text(AppLocalizations.of(context).entity),
                contentPadding: const EdgeInsets.all(8),
              ),
              items: entity.items
                  .map(
                    (entityItem) => DropdownMenuItem(
                      child: Text(entityItem.title),
                      value: entityItem,
                    ),
                  )
                  .toList(),
              validator: (value) {
                if (value == null || value.toString().isEmpty)
                  return AppLocalizations.of(context).erorr_entity;
                return null;
              },
              onSaved: (value) => _Entity = value,
              onChanged: (value) => _Entity,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          DigiButton(
            onPressed: _submittedLogin,
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    AppLocalizations.of(context).login,
                  ),
          ),
          SizedBox(
            height: 16,
          ),
          if (_error != null)
            Text(
              _error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).errorColor),
            )
        ],
      ),
    );
  }
}
