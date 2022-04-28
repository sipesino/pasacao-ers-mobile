import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/emergency_contact.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/widgets/add_contact_dialog.dart';
import 'package:pers/src/widgets/emergency_contact_card.dart';
import 'package:http/http.dart' as http;

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<EmergencyContact> contacts = [];

  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              titleSpacing: 0,
              title: Text(
                'Emergency Contacts',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              setState(() {
                if (direction == ScrollDirection.reverse) {
                  _showFab = false;
                } else if (direction == ScrollDirection.forward) {
                  _showFab = true;
                }
              });
              return true;
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: contacts.map((e) {
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: boxShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Slidable(
                        key: ValueKey(contacts.indexOf(e)),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                showEditContactDialog(
                                  context,
                                  e,
                                  contacts.indexOf(e),
                                );
                              },
                              backgroundColor: Color(0xFF0392CF),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                showDeleteContactDialog(
                                  context,
                                  e,
                                  contacts.indexOf(e),
                                );
                              },
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: EmergencyContactCard2(
                          contact_name: e.contact_name,
                          contact_number: e.contact_number,
                          index: contacts.indexOf(e),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedSlide(
        duration: Duration(milliseconds: 300),
        offset: _showFab ? Offset.zero : Offset(0, 2),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                showAddContactDialog(context);
              });
            },
            child: Icon(Icons.add),
            backgroundColor: accentColor,
          ),
        ),
      ),
    );
  }

  void refresh() {
    SharedPref().read('contacts').then((value) {
      if (value != 'null')
        setState(() {
          contacts = EmergencyContact.decode(value);
        });
    });
  }

  void showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddContactDialog(
          notify_parent: refresh,
        );
      },
    );
  }

  void showEditContactDialog(
      BuildContext context, EmergencyContact contact, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddContactDialog(
          editContact: true,
          contact_name: contact.contact_name,
          contact_number: contact.contact_number,
          contact_id: contact.contact_id!,
          index: index,
          notify_parent: refresh,
        );
      },
    );
  }

  void showDeleteContactDialog(
      BuildContext context, EmergencyContact contact, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Remove ${contact.contact_name} as emergency contact?'),
          actions: [
            TextButton(
              onPressed: () {
                deleteContact(contact, index);
              },
              child: Text(
                'YES',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'NO',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void deleteContact(EmergencyContact contact, int index) {
    final Connectivity _connectivity = Connectivity();

    _connectivity.checkConnectivity().then((status) async {
      ConnectivityResult _connectionStatus = status;

      if (_connectionStatus != ConnectivityResult.none) {
        SharedPref pref = new SharedPref();
        String token = await pref.read("token");

        String url =
            'http://143.198.92.250/api/emergencycontacts/${contact.contact_id}';

        Map<String, dynamic> body = {
          "contact_name": contact.contact_name,
          "contact_number": contact.contact_number,
        };

        var res = await http.delete(
          Uri.parse(url),
          body: body,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (res.statusCode == 200) {
          setState(() {
            contacts.removeAt(index);
          });
          final String encoded_contacts = EmergencyContact.encode(contacts);
          SharedPref().save('contacts', encoded_contacts);
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: new Text("No internet connection."),
            backgroundColor: Colors.red,
            duration: new Duration(seconds: 5),
          ),
        );
      }
    });
  }
}
