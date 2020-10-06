import 'package:chat_sample/src/utils/gradients.dart';
import 'package:chat_sample/src/widgets/custom_shape.dart';
import 'package:chat_sample/src/widgets/responsive_ui.dart';
import 'package:chat_sample/src/widgets/textformfield.dart';
import 'package:gender_selection/gender_selection.dart';

import '../src/utils/pref_util.dart';
import 'package:flutter/material.dart';

import 'package:connectycube_sdk/connectycube_sdk.dart';

import 'select_dialog_screen.dart';
import 'utils/api_utils.dart';

class Login extends StatelessWidget {
  static const String TAG = "LoginScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(automaticallyImplyLeading: false, title: Text('Chat')),*/

      body: LoginPageA(),
    );
  }
}

class LoginPageA extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginPageAState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class LoginPageAState extends State<LoginPageA> {
  static const String TAG = "_LoginPageState";
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _age = new TextEditingController();
  String _login = "";
  String _password = "";
  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  bool _isLoginContinues = false;

  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  LoginPageAState() {
    _name.addListener(_loginListen);
    _age.addListener(_passwordListen);
  }

  void _loginListen() {
    if (_name.text.isEmpty) {
      _login = "";
    } else {
      _login = _name.text;
    }
  }

  void _passwordListen() {
    if (_age.text.isEmpty) {
      _password = "";
    } else {
      _password = _age.text;
    }
  }

  // Swap in between our two forms, registering and logging in
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);


    return new Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: new Container(
          padding: EdgeInsets.all(10.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[_buildLogoField(), _initLoginWidgets()],
          ),
        ),
      ),
    );
  }


  Widget _buildLogoField() {
//    return Image.asset('assets/images/splash.png');
    return Container(
      child: Align(
        alignment: FractionalOffset.center,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Image.asset('assets/images/c.jpg'),
            ),
            Container(
              height: 5,
              width: 5,
              child: Visibility(
                visible: _isLoginContinues,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _initLoginWidgets() {
    return FutureBuilder<Widget>(
        future: getFilterChipsWidgets(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          }
          return SizedBox.shrink();
        });
  }

  Future<Widget> getFilterChipsWidgets() async {
    if (_isLoginContinues) return SizedBox.shrink();
    await SharedPrefs.instance.init();
    CubeUser user = SharedPrefs.instance.getUser();
    if (user != null) {
      _loginToCC(context, user);
      return SizedBox.shrink();
    } else
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[_buildTextFields()],
      );
  }

  Widget _buildTextFields() {
    return new Container(
      margin: EdgeInsets.only(
          left:_width/ 12.0,
          right: _width / 12.0,
          ),
      child: new Column(
        children: <Widget>[
          new Container(
            child: GenderSelection(
              maleText: "Boy",
              femaleText: "Girl",
              linearGradient: pinkRedGradient,
              selectedGenderIconBackgroundColor: Colors.indigo,
              checkIconAlignment: Alignment.centerRight,
              selectedGenderCheckIcon: null,
              onChanged: (Gender gender){
                print(gender);
              },
              equallyAligned: true,
              animationDuration: Duration(milliseconds: 400),
              isCircular: true,
              isSelectedGenderIconCircular: true,
              opacityOfGradient: 0.6,
              padding: const EdgeInsets.all(3),
              size: 50,

            ),
          ),
          SizedBox(height: _height/35,),
          new Container(
            child: CustomTextField(
              textEditingController: _name,
              keyboardType: TextInputType.text,
              icon: Icons.person,
              hint: "Name",
            )
          ),
          SizedBox(height: _height/35,),
          new Container(
            child: CustomTextField(
              textEditingController: _age,
              keyboardType: TextInputType.number,
              icon: Icons.phone,
              hint: "Age",
            )
          ),
          SizedBox(height: _height/35,),
          new Container(
            margin: EdgeInsets.only(top: _height / 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                    activeColor: Colors.orange[200],
                    value: checkBoxValue,
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxValue = newValue;
                      });
                    }),
                Text(
                  "I accept all terms and conditions",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: _large? 12: (_medium? 11: 10)),
                ),
              ],
            ),
          ),
          new Container(
            child: RaisedButton(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              onPressed: _loginPressed,
              textColor: Colors.white,
              padding: EdgeInsets.all(0.0),
              child: Container(
                alignment: Alignment.center,
//        height: _height / 20,
                width:_large? _width/4 : (_medium? _width/3.75: _width/3.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                    colors: <Color>[Colors.orange[200], Colors.pinkAccent],
                  ),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Text('SAVE', style: TextStyle(fontSize: _large? 14: (_medium? 12: 10)),),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Login'),
              onPressed: _loginPressed,
            ),
            new FlatButton(
              child: new Text('Don\'t have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
            new FlatButton(
              child: new Text('Delete user?'),
              onPressed: _delete_user_pressed,
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Create an Account'),
              onPressed: _createAccountPressed,
            ),
            new FlatButton(
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  void _loginPressed() {
    print('login with $_login and $_password');
    _loginToCC(context, CubeUser(login: _login, password: _password),
        saveUser: true);
  }

  void _createAccountPressed() {
    print('create an user with $_login and $_password');
    _signInCC(context,
        CubeUser(login: _login, password: _password, fullName: _login));
  }

  void _delete_user_pressed() {
    print('_delete_user_pressed $_login and $_password');
    _userDelete();
  }

  void _userDelete() {
    createSession(CubeUser(login: _login, password: _password))
        .then((cubeSession) {
      deleteUser(cubeSession.userId).then((_) {
        print("signOut success");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Delete user"),
                content: Text("succeeded"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            });
      });
    }).catchError(_processLoginError);
  }

  _signInCC(BuildContext context, CubeUser user) async {
    if (_isLoginContinues) return;

    setState(() {
      _isLoginContinues = true;
    });
    if (!CubeSessionManager.instance.isActiveSessionValid()) {
      try {
        await createSession();
      } catch (error) {
        _processLoginError(error);
      }
    }
    signUp(user).then((newUser) {
      print("signUp newUser $newUser");
      user.id = newUser.id;
      SharedPrefs.instance.saveNewUser(user);
      signIn(user).then((result) {
        _loginToCubeChat(context, user);
      });
    }).catchError(_processLoginError);
  }

  _loginToCC(BuildContext context, CubeUser user, {bool saveUser = false}) {
    if (_isLoginContinues) return;
    setState(() {
      _isLoginContinues = true;
    });

    createSession(user).then((cubeSession) async {
      var tempUser = user;
      user = cubeSession.user..password = tempUser.password;
      if (saveUser) SharedPrefs.instance.saveNewUser(user);
      _loginToCubeChat(context, user);
    }).catchError(_processLoginError);
  }

  _loginToCubeChat(BuildContext context, CubeUser user) {
    print("_loginToCubeChat user $user");
    CubeChatConnection.instance.login(user).then((cubeUser) {
      _isLoginContinues = false;
      _goDialogScreen(context, cubeUser);
    }).catchError(_processLoginError);
  }

  void _processLoginError(exception) {
    log("Login error $exception", TAG);
    setState(() {
      _isLoginContinues = false;
    });
    showDialogError(exception, context);
  }

  void _clear() {
    _isLoginContinues = false;
    _login = "";
    _password = "";
    _name.clear();
    _age.clear();
  }

  void _goDialogScreen(BuildContext context, CubeUser cubeUser) async {
    bool refresh = await Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: "/SelectDialogScreen"),
        builder: (context) => SelectDialogScreen(cubeUser),
      ),
    );
    setState(() {
      if (refresh) {
        _clear();
      }
    });
  }
}
