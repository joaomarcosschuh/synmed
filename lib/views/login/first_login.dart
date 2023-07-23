import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meu_flash/services/session_services/user_service.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meu_flash/models/streak_model.dart';
import 'package:meu_flash/services/stats/streak_service.dart';
import 'package:meu_flash/services/stats/dailystats_service.dart';
import 'package:meu_flash/services/stats/streak_service.dart';

class FirstLoginPage extends StatefulWidget {
  @override
  _FirstLoginPageState createState() => _FirstLoginPageState();
}

class _FirstLoginPageState extends State<FirstLoginPage> {
  late FirebaseAuth _auth;
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _name;
  int? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;
  dynamic _profilePicture;
  String? _profilePictureUrl;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _medicinaEtapa;
  final DailyStatsService _dailyStatsService = DailyStatsService();
  final StreakService _streakService = StreakService(DailyStatsService());

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    debugPrint("Initial state set");
  }

  Future<void> _updateUserInfo() async {
    debugPrint("Attempt to update user info");

    if (_formKey.currentState!.validate()) {
      debugPrint("Form is valid");
      _formKey.currentState!.save();

      if (_username != null &&
          _selectedDay != null &&
          _selectedMonth != null &&
          _selectedYear != null &&
          _name != null &&
          _medicinaEtapa != null) {
        debugPrint("All required fields are filled");

        User? user = _auth.currentUser;
        if (user != null) {
          debugPrint("User is logged in");

          if (_profilePicture != null) {
            String profilePicturePath = 'profile_pictures/${user.uid}.jpg';
            try {
              TaskSnapshot snapshot;
              // Uploading process
              debugPrint("Profile picture uploading");

              if (_profilePicture is File) {
                snapshot = await _storage
                    .ref(profilePicturePath)
                    .putFile(_profilePicture);
              } else {
                Uint8List bytes = _profilePicture;
                snapshot = await _storage
                    .ref(profilePicturePath)
                    .putData(bytes);
              }

              String downloadUrl = await snapshot.ref.getDownloadURL();

              await _userService.updateUserInfo(
                _username!,
                DateTime(_selectedYear!, _selectedMonth!, _selectedDay!),
                downloadUrl,
                _name!,
                _medicinaEtapa!,
              );

              setState(() {
                _profilePictureUrl = downloadUrl;
              });

              debugPrint("Profile picture uploaded");
            } catch (e) {
              print('Error uploading profile picture: $e');
              return;
            }
          } else {
            await _userService.updateUserInfo(
              _username!,
              DateTime(_selectedYear!, _selectedMonth!, _selectedDay!),
              _profilePictureUrl,
              _name!,
              _medicinaEtapa!,
            );
          }

          // Create a new streak document for the user
          String userId = user.uid;
          StreakModel newStreak = StreakModel(
            dailyLogins: {},
            streak: 0,
            totalXP: 0,
          );
          await _streakService.updateStreak(userId, newStreak);

          Navigator.pushReplacementNamed(context, '/mainView');
        }
      } else {
        debugPrint("Not all required fields are filled");
      }
    } else {
      debugPrint("Form is not valid");
    }
  }

  Future<void> _getPicture() async {
    if (kIsWeb) {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final userFile = uploadInput.files!.first;
        final reader = html.FileReader();

        reader.readAsDataUrl(userFile);
        reader.onLoadEnd.listen((event) {
          setState(() {
            final String dataUrl = reader.result as String;
            final String data = dataUrl.split(',')[1];
            Uint8List bytes = base64Decode(data);
            _profilePicture = bytes;
          });
        });
      });
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profilePicture = File(pickedFile.path);
        });
      }
    }
  }

  ImageProvider? _getImageProvider() {
    if (_profilePictureUrl != null) {
      return NetworkImage(_profilePictureUrl!);
    } else if (_profilePicture != null) {
      if (kIsWeb) {
        return MemoryImage(_profilePicture);
      } else {
        return FileImage(_profilePicture);
      }
    } else {
      return AssetImage('lib/assets/profile_picture.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:(54.0)),
        child: SingleChildScrollView(
         child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('lib/assets/logo/static_logo.png', height: 150),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _getPicture,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: _getImageProvider(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getPicture,
                child: Text(
                  'Escolher foto',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Seu nome',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nome de usuário',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Dia',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      items: List.generate(31, (index) => index + 1)
                          .map((day) => DropdownMenuItem<int>(
                        value: day,
                        child: Text(day.toString()),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a day';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Mês',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      items: List.generate(12, (index) => index + 1)
                          .map((month) => DropdownMenuItem<int>(
                        value: month,
                        child: Text(month.toString()),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMonth = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a month';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Ano',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      items: List.generate(124, (index) => index + 1900)
                          .map((year) => DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a year';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Etapa/Semestre de Medicina',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Medicina Etapa/Semester';
                  }
                  return null;
                },
                onSaved: (value) => _medicinaEtapa = value,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateUserInfo,
                child: Text(
                  'Criar Conta',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
}
