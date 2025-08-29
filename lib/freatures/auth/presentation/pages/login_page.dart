import 'dart:io';

import 'package:crud_product/freatures/auth/presentation/cubit/auth_cubit.dart';
import 'package:crud_product/freatures/product/presentation/pages/product_pages.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _deviceName = 'Unknown Device';

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getDeviceName().then((name) {
      setState(() {
        _deviceName = name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ProductsPage()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        String? nameError;
        if (state is AuthInputError) {
          nameError = state.data.errors?["name"]?.first.toString();
        }
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 30),

                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
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
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        minimumSize: WidgetStatePropertyAll<Size>(
                          const Size(double.infinity, 50),
                        ),
                      ),
                      onPressed: () {
                        context.read<AuthCubit>().login(
                          name: _nameController.text,
                          password: _passwordController.text,
                          deviceName: _deviceName,
                        );
                      },
                      child: state is AuthLoading
                          ? CircularProgressIndicator()
                          : Text('Login'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
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
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      deviceName = iosInfo.name;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfoPlugin.macOsInfo;
      deviceName = macOsInfo.model;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
      deviceName = windowsInfo.computerName;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
      deviceName = linuxInfo.name;
    } else {
      WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      deviceName = webBrowserInfo.browserName.toString();
    }
    return deviceName;
  }
}
