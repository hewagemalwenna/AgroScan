import 'package:flutter/material.dart';


class AboutUsScreen extends StatelessWidget {
  final List<Member> members;

  const AboutUsScreen({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (member.image != null)
                  CircleAvatar(
                    backgroundImage: member.image!,
                    radius: 25.0,
                  ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (member.title != null)
                      Text(
                        member.title!,
                      ),
                    if (member.email != null)
                      GestureDetector(
                        onTap: () => (
                        'mailto:${member.email}', // Launch mail app with member's email
                        ),
                        child: Text(
                          member.email!,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class Member {
  final String name;
  final String? title;
  final AssetImage? image;
  final String? email;

  const Member({
    required this.name,
    this.title,
    this.image,
    this.email,
  });
}


const List<Member> teamMembers = [
  Member(
    name: "Pamoda Piyumaka",
    title: "Lead Developer",
    image:  AssetImage("assets/images/Piyumaka1.jpg"),
    email: "pamoda.20200310@iit.ac.lk",
  ),
  Member(
    name: "Kulaja Malwenna",
    title: "Backend Developer",
    image:  AssetImage("assets/images/Kulaja1.jpg"),
    email: "kulaja.20220140@iit.ac.lk",
  ),
  Member(
    name: "Uditha Karawita",
    title: "Frontend Developer",
    image: AssetImage("assets/images/Uditha.jpg"),
    email: "uditha.20220668@iit.ac.lk",
  ),
  Member(
    name: "Umasha Wijenayake",
    title: "Backend Developer",
    image:  AssetImage("assets/images/Umasha.jpg"),
    email: "umasha.2021133@iit.ac.lk",
  ),
  Member(
    name: "Manditha Nanayakkara",
    title: "Developer",
    image:  AssetImage("assets/images/Manditha1.jpg"),
    email:"manditha.20221462@iit.ac.lk",
  ),

];
