import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:memory_box/services/app_images.dart';
import 'package:memory_box/services/auth_services.dart';
import 'package:provider/src/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  final TextEditingController nameControler = TextEditingController();
  final TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    this._getUpdateUser();
  }

  void _getUpdateUser() async {
    var auth = Provider.of<AuthServices>(context, listen: false);

    auth.getCurrentUser().listen((event) => setState(() => user = event));
  }

  @override
  Widget build(BuildContext context) {
    final update = context.read<AuthServices>();
    final user = context.watch<AuthServices>().getUser();
    final toogle = update.toogle;
    final sms = update.sendSms;
    final phone = user.phoneNumb;
    String? displayName = user.displayName ?? 'Здесь будет твоё имя';

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 85,
          backgroundColor: Color(0xff8C84E2),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu)),
          title: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Профиль',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'ttNormal',
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Твоя частичка',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'ffNormal', fontSize: 16),
              )
            ],
          )),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                CustomAppBarProfile(),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      EditingPhoto(),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                          child: toogle == false
                              ? Text(
                                  displayName,
                                  style: TextStyle(
                                      fontFamily: 'ttNormal', fontSize: 24),
                                )
                              : Container(
                                  child: TextField(
                                    decoration:
                                        InputDecoration(hintText: displayName),
                                    style: TextStyle(
                                        fontFamily: 'ttNormal', fontSize: 24),
                                    controller: nameControler,
                                    textAlign: TextAlign.center,
                                  ),
                                  width: 180,
                                )),
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Material(
                          elevation: 10.5,
                          borderRadius: BorderRadius.circular(50),
                          child: Stack(
                            children: [
                              TextField(
                                readOnly: toogle == false ? true : false,
                                controller: controller,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0+-9]')),
                                  LengthLimitingTextInputFormatter(13),
                                ],
                                keyboardType: TextInputType.phone,
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    hintText: sms == false ? phone : '',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 15),
                                    isCollapsed: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide(
                                            style: BorderStyle.none)),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.none))),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 4, right: 10),
                                alignment: Alignment.centerRight,
                                child: sms == false
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.send,
                                          color: toogle == false
                                              ? Colors.grey
                                              : Color(0xff8C84E2),
                                        ),
                                        onPressed: () {
                                          if (toogle == true) {
                                            if (controller.text.length == 13) {
                                              update.verifyPhoneNumber(
                                                  context, controller.text);
                                              controller.text = '';
                                              update.changeSendSms = true;
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            }
                                          }
                                        })
                                    : IconButton(
                                        icon: Icon(
                                          Icons.done,
                                          color: toogle == false
                                              ? Colors.grey
                                              : Color(0xff8C84E2),
                                        ),
                                        onPressed: () {
                                          if (toogle == true) {
                                            if (user.phoneNumb == null) {
                                              update.verifyCode(
                                                  context, controller.text);
                                            }
                                            update.UpdateNumb(
                                                context, controller.text);
                                            controller.text = '';
                                            update.changeSendSms = false;
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          }
                                        }),
                              )
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            if (toogle == false) {
                              update.changeToogle = true;
                            } else if (toogle == true) {
                              if (nameControler.text.length >= 1) {
                                update.updateDisplayName(nameControler.text);
                              }
                              update.auth.currentUser?.reload();

                              update.changeToogle = false;
                            }
                          },
                          child: Text(
                            '${toogle == false ? 'Редактировать' : "Сохранить"}',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'ttNormal',
                                fontSize: 14,
                                decoration: toogle == false
                                    ? TextDecoration.underline
                                    : TextDecoration.none),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/auth');
                                update.signOut();
                              },
                              child: Text(
                                'Выйти из приложения',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'ttNormal',
                                    fontSize: 14),
                              )),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text(
                                          'Точно удалить аккаунт?',
                                          style: TextStyle(
                                            fontFamily: 'ttNormal',
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Container(
                                          width: 150,
                                          child: Text(
                                            'Все аудиофайлы исчезнут и восстановить аккаунт будет невозможно',
                                            style: TextStyle(
                                                fontFamily: 'ttNormal',
                                                fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25))),
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all(Size(124, 41)),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Color(0xFFE27777),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    update.deleteAcc();
                                                    Navigator.of(context)
                                                        .pushReplacementNamed(
                                                            '/auth');
                                                  },
                                                  child: Text(
                                                    'Удалить',
                                                    style: TextStyle(
                                                      fontFamily: 'ttNormal',
                                                      fontSize: 16,
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                    minimumSize:
                                                        MaterialStateProperty
                                                            .all(Size(84, 41)),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        side: BorderSide(
                                                            color: Color(
                                                                0xff8C84E2)),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Нет',
                                                    style: TextStyle(
                                                        fontFamily: 'ttNormal',
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff8C84E2)),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ));
                            },
                            child: Text(
                              'Удалить аккаунт',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'ttNormal',
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditingPhoto extends StatefulWidget {
  EditingPhoto({Key? key}) : super(key: key);

  @override
  _EditingPhotoState createState() => _EditingPhotoState();
}

class _EditingPhotoState extends State<EditingPhoto> {
  File? image;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthServices>().getUser();
    var toogle = context.read<AuthServices>().toogle;

    final avatar = user.avatarUrl ??
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyz-77X11MoGE22xVjjPhbpW6lPj6I0SkcTQ&usqp=CAU';

    return Center(
        child: toogle == true
            ? GestureDetector(
                onTap: () async {
                  final user = context.read<AuthServices>();

                  try {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (image == null) return;

                    final ImageTemporary = File(image.path);
                    user.uploadProfilePhoto(ImageTemporary);

                    setState(() {
                      this.image = ImageTemporary;
                    });
                  } on PlatformException catch (e) {
                    print(e);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          width: 228,
                          height: 228,
                          child: image != null
                              ? Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                  width: 228,
                                  height: 228,
                                )
                              : Image.network(
                                  avatar,
                                  fit: BoxFit.cover,
                                  width: 228,
                                  height: 228,
                                )),
                    ),
                    Center(
                        child: ImageIcon(
                      AppImages.photoEdit,
                      color: Colors.white,
                      size: 80,
                    ))
                  ],
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    width: 228,
                    height: 228,
                    child: Image.network(
                      avatar,
                      fit: BoxFit.cover,
                      width: 228,
                      height: 228,
                    )),
              ));
  }
}

class CustomAppBarProfile extends StatelessWidget {
  const CustomAppBarProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 5),
        painter: MyPainter(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color(0xff8C84E2);
    canvas.drawCircle(Offset(size.width / 1.5, size.height - size.width),
        size.width * 1.1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Input extends StatelessWidget {
  TextEditingController phoneControler = TextEditingController();
  Input(this.phoneControler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Material(
        elevation: 10.5,
        borderRadius: BorderRadius.circular(50),
        child: TextField(
          controller: phoneControler,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0+-9]')),
            LengthLimitingTextInputFormatter(13),
          ],
          keyboardType: TextInputType.phone,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(style: BorderStyle.none)),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none))),
        ),
      ),
    );
  }
}
