import 'package:flutter/material.dart';
import 'package:psy_assistant/screen/auth/login_screen.dart';
import 'package:psy_assistant/screen/auth/register_info_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const routeName = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/logo/welcome.png',
            height: 250,
            width: 250,
          ),

          const SizedBox(height: 32),

          // button row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //sign up button
              SizedBox(
                width: 104,
                height: 42,
                child: ElevatedButton(
                    onPressed: () {
                      // show dialog
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Signup as',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(Icons.clear))
                                  ],
                                ),

                                //
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //todo: cr, teacher late implement
                                    //teacher button
                                    // TextButton(onPressed: () {}, child: const Text('Teacher')),

                                    const SizedBox(width: 8),

                                    // student button
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context,
                                              RegisterInfoScreen.routeName);
                                        },
                                        child: const Text('Student')),
                                    const SizedBox(width: 16),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Signup')),
              ),

              const SizedBox(width: 16),

              // login button
              SizedBox(
                width: 104,
                height: 42,
                child: ElevatedButton(
                    onPressed: () {
                      // show dialog
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Login as',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(Icons.clear))
                                  ],
                                ),

                                //
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //todo: cr, teacher late implement
                                    //teacher button
                                    // TextButton(onPressed: () {}, child: const Text('Teacher')),

                                    const SizedBox(width: 8),

                                    // student button
                                    TextButton(
                                        onPressed: () async {
                                          await Navigator.pushReplacementNamed(
                                              context, LoginScreen.routeName);
                                        },
                                        child: const Text('Student')),
                                    const SizedBox(width: 16),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Login')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
