import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  // logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header
              // DrawerHeader(
              //   child: Icon(
              //     Icons.favorite,
              //     color: Theme.of(context).colorScheme.inversePrimary,
              //   ),
              // ),
              Container(
                height: 150,
                alignment: Alignment.center,
                child: Icon(
                  Icons.people_alt_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 60,
                ),
              ),
              const SizedBox(height: 25.0),

              // Home title
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  horizontalTitleGap: 30,
                  title: Text("H O M E"),
                  onTap: () {
                    // this is already the home screen so just pop drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              // Profile title
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  horizontalTitleGap: 30,
                  title: Text("P R O F I L E"),
                  onTap: () {
                    // navigate to profile page
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),

              // users title
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.group,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  horizontalTitleGap: 30,
                  title: Text("U S E R S"),
                  onTap: () {
                    // navigate to users page
                    Navigator.pushNamed(context, '/users_page');
                  },
                ),
              ),
            ],
          ),

          // logout tile
          Padding(
            padding: EdgeInsets.only(left: 25, bottom: 20),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              horizontalTitleGap: 30,
              title: Text("L O G O U T"),
              onTap: () {
                // pop drawer
                Navigator.pop(context);

                // logout
                logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
