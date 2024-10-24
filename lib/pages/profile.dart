import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 70,
             backgroundImage: AssetImage('assets/IMG_7295.JPG'),
            ),
            const SizedBox(height: 40),
            itemProfile('Name', 'Thiwanga Jayasinghe', CupertinoIcons.person),
            const SizedBox(height: 40),
            itemProfile('Phone', '0750604148', CupertinoIcons.phone),
            const SizedBox(height: 40),
            itemProfile('Address', 'Narammala', CupertinoIcons.location),
            const SizedBox(height: 40),
            itemProfile('Email', 'info.thiwangasri@gmail.com', CupertinoIcons.mail),
            const SizedBox(height: 40,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text('Edit Profile')
              ),
            )
          ],
        ),
      ),
    );
  }
}

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Color.fromARGB(255, 75, 196, 207).withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }