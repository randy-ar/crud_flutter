// lib/features/auth/presentation/pages/login_page.dart
// ...
import 'dart:io';

import 'package:crud_product/freatures/auth/presentation/bloc/auth_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getDeviceName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final deviceName = snapshot.data ?? 'Unknown Device';

        return Scaffold(
          appBar: AppBar(),
          body: BlocProvider(
            create: (context) => GetIt.instance<AuthBloc>(),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login successful!')),
                  );
                  // Navigasi ke halaman produk
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                String? nameError;
                if (state is AuthInputError) {
                  nameError = state.data.errors?["name"]?.first.toString();
                }

                return Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          if (nameError != null)
                            Text(
                              nameError,
                              style: const TextStyle(color: Colors.red),
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Colors.black87,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              minimumSize: WidgetStatePropertyAll<Size>(
                                const Size(double.infinity, 50),
                              ),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                LoginButtonPressed(
                                  name: _nameController.text,
                                  password: _passwordController.text,
                                  deviceName: deviceName,
                                ),
                              );
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<String> _getDeviceName() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceName = 'Unknown Device';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceName = androidInfo.model ?? 'Android Device';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      deviceName = iosInfo.name ?? 'iOS Device';
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfoPlugin.macOsInfo;
      deviceName = macOsInfo.model ?? 'macOS Device';
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
      deviceName = windowsInfo.computerName ?? 'Windows Device';
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
      deviceName = linuxInfo.name ?? 'Linux Device';
    } else {
      WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      deviceName = webBrowserInfo.browserName.toString();
    }
    return deviceName;
  }
}
