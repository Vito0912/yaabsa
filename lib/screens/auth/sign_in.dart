import 'package:buchshelfly/api/me/request/login_request.dart';
import 'package:buchshelfly/api/me/server.dart';
import 'package:buchshelfly/api/me/user.dart';
import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/screens/home_screen.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverAddressController = useTextEditingController();
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    final currentUser = ref.watch(currentUserProvider).value;
    useEffect(() {
      if (currentUser?.server?.url != null &&
          serverAddressController.text.isEmpty) {
        serverAddressController.text = currentUser!.server!.url;
      }
      return null;
    }, [currentUser]);

    void validateAndSignIn() async {
      errorMessage.value = null;

      final server = serverAddressController.text.trim();
      final username = usernameController.text.trim();
      final password = passwordController.text;

      if (server.isEmpty || username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All fields are required!'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      isLoading.value = true;

      try {
        logger(
          'Attempting login to Server: $server, Username: $username',
          tag: 'SignIn',
        );

        final loginApi = ABSApi(basePathOverride: server);
        final apiResponse = await loginApi.getMeApi().login(
          loginRequest: LoginRequest(username: username, password: password),
        );

        final loginData = apiResponse.data;

        if (loginData != null) {
          final User loggedInUser = loginData.user;

          final db = ref.read(appDatabaseProvider);
          await db.addOrUpdateStoredUser(
            loggedInUser.copyWith(
              server: Server(
                host: Uri.parse(server).host,
                port: Uri.parse(server).port,
                ssl: Uri.parse(server).scheme == "https",
              ),
            ),
          );
          await db.setActiveUserId(loggedInUser.id);

          ref.invalidate(allStoredUsersProvider);
          ref.invalidate(currentUserProvider);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Sign in successful! Welcome ${loggedInUser.username}.',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        } else {
          errorMessage.value = 'Login failed: Invalid response from server.';
        }
      } catch (e) {
        String errorTextToShow = 'An unexpected error occurred.';
        if (e is DioException) {
          if (e.response != null && e.response?.data != null) {
            var responseData = e.response!.data;
            if (responseData is Map) {
              if (responseData.containsKey('message')) {
                errorTextToShow = responseData['message'].toString();
              } else if (responseData.containsKey('error')) {
                errorTextToShow = responseData['error'].toString();
              } else {
                errorTextToShow = e.response?.statusMessage ?? 'Server error.';
              }
            } else if (responseData is String && responseData.isNotEmpty) {
              errorTextToShow = responseData;
            } else {
              errorTextToShow =
                  e.response?.statusMessage ?? 'Server communication error.';
            }
          } else if (e.message != null && e.message!.isNotEmpty) {
            errorTextToShow = e.message!;
          } else {
            errorTextToShow =
                'Network error or server unavailable. Please check the server address and your connection.';
          }
        } else {
          errorTextToShow = e.toString();
        }
        errorMessage.value = 'Login failed: $errorTextToShow';
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.menu_book,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Buchshelfly',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your cross-platform App',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Please enter your credentials to sign in.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: serverAddressController,
                        decoration: InputDecoration(
                          labelText: 'Server Address',
                          hintText: 'e.g., myapp.com or http://localhost:port',
                          prefixIcon: const Icon(Icons.dns_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        keyboardType: TextInputType.url,
                        enabled: !isLoading.value,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        enabled: !isLoading.value,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        enabled: !isLoading.value,
                      ),
                      const SizedBox(height: 16),

                      if (errorMessage.value != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            errorMessage.value!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 28.0 - 12.0),
                      ],

                      if (errorMessage.value == null)
                        const SizedBox(height: 12),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: isLoading.value ? null : validateAndSignIn,
                        child:
                            isLoading.value
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                : const Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
