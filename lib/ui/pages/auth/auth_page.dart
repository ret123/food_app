import 'package:auth/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/models/User.dart';
import 'package:food_app/state_management/auth/auth_cubit.dart';
import 'package:food_app/state_management/auth/auth_state.dart';
import 'package:food_app/ui/widgets/custom_flat_button.dart';
import 'package:food_app/ui/widgets/custom_outline_button.dart';
import 'package:food_app/ui/widgets/custom_text_field.dart';

class AuthPage extends StatefulWidget {
  final AuthManager _manager;
  final ISignUpService _signUpService;

  AuthPage(this._manager, this._signUpService);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  PageController _controller = PageController();
  String _username = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 110.0),
              child: _buildLogo(),
            ),
            SizedBox(
              height: 50.0,
            ),
            BlocConsumer<AuthCubit, AuthState>(
              builder: (_, state) {
                return Expanded(
                  child: PageView(
                    controller: _controller,
                    physics: NeverScrollableScrollPhysics(),
                    children: [_signIn(), _signUp()],
                  ),
                );
              },
              listener: (context, state) {
                if (state is LoadingState) {
                  _showLoader();
                }
                if (state is ErrorState) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message,
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                    ),
                  );
                  _hideLoader();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildLogo() => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 10.0,
            ),
            RichText(
              text: TextSpan(
                text: 'Food',
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.black,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: ' Space',
                      style: TextStyle(color: Theme.of(context).accentColor)),
                ],
              ),
            ),
          ],
        ),
      );

  // _buildUI() {
  //   Expanded(
  //       child: PageView(
  //       physics: NeverScrollableScrollPhysics(),
  //       children: [_signIn()],
  //     ),
  //   );
  // }

  _signIn() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            ..._emailAndPassword(),
            SizedBox(height: 30.0),
            CustomFlatButton(
                text: 'Sign In',
                size: Size(double.infinity, 54.0),
                onPressed: () {
                  BlocProvider.of<AuthCubit>(context).signin(widget._manager
                      .email(email: _email, password: _password));
                }),
            SizedBox(height: 30),
            CustomOutlineButton(
              text: 'Sign In with Google',
              size: Size(double.infinity, 54),
              icon: SvgPicture.asset(
                'assets/google.svg',
                height: 18,
                width: 18,
                fit: BoxFit.fill,
              ),
              onPressed: () {
                BlocProvider.of<AuthCubit>(context)
                    .signin(widget._manager.google);
              },
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                  children: [
                    TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.elasticOut);
                          }),
                  ]),
            ),
          ],
        ),
      );

  _signUp() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            CustomTextField(
              hint: 'Username',
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              onChanged: (val) {
                _username = val;
              },
            ),
            SizedBox(height: 30.0),
            ..._emailAndPassword(),
            SizedBox(height: 30.0),
            CustomFlatButton(
              text: 'Sign up',
              size: Size(double.infinity, 54.0),
              onPressed: () {
                final user =
                    User(name: _username, email: _email, password: _password);
                BlocProvider.of<AuthCubit>(context)
                    .signup(widget._signUpService, user);
              },
            ),
            SizedBox(height: 30.0),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: 'Already have an account?',
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                children: [
                  TextSpan(
                    text: ' Sign in',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _controller.previousPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.elasticOut);
                      },
                  )
                ],
              ),
            )
          ],
        ),
      );

  List<Widget> _emailAndPassword() => [
        CustomTextField(
            hint: 'Email',
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            onChanged: (val) {
              _email = val;
            }),
        SizedBox(height: 30.0),
        CustomTextField(
            hint: 'Password',
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            onChanged: (val) {
              _password = val;
            }),
      ];

  void _showLoader() {
    var alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white70,
        ),
      ),
    );
    showDialog(
        context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
