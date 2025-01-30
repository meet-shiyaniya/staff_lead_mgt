import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(WhatsAppCloneApp());
}

class WhatsAppCloneApp extends StatelessWidget {
  const WhatsAppCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WhatsAppHomePage(),
    );
  }
}

class WhatsAppHomePage extends StatefulWidget {
  const WhatsAppHomePage({super.key});

  @override
  _WhatsAppHomePageState createState() => _WhatsAppHomePageState();
}

class _WhatsAppHomePageState extends State<WhatsAppHomePage> {
  final List _tabs = ['All', 'WhatsApp', 'Messenger'];

  final List _contacts = [
    {
      'name': 'Amit Sharma',
      'message': 'Hello!',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg'
    },
    {
      'name': 'Priya Patel',
      'message': 'How are you?',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg'
    },
    {
      'name': 'Neha Singh',
      'message': 'See you soon.',
      'image': 'https://randomuser.me/api/portraits/women/4.jpg'
    },
    {
      'name': 'Sanjay Verma',
      'message': 'Meeting at 5 PM.',
      'image': 'https://randomuser.me/api/portraits/men/5.jpg'
    },
    {
      'name': 'Anjali Gupta',
      'message': 'Great job!',
      'image': 'https://randomuser.me/api/portraits/women/6.jpg'
    },
    {
      'name': 'Rahul Joshi',
      'message': 'On my way.',
      'image': 'https://randomuser.me/api/portraits/men/7.jpg'
    },
    {
      'name': 'Pooja Mehta',
      'message': 'See you tomorrow.',
      'image': 'https://randomuser.me/api/portraits/women/8.jpg'
    },
    {
      'name': 'Vikram Choudhary',
      'message': 'Call me back.',
      'image': 'https://randomuser.me/api/portraits/men/9.jpg'
    },
    {
      'name': 'Ritu Malhotra',
      'message': 'Good night.',
      'image': 'https://randomuser.me/api/portraits/women/10.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
          title: Text(
            'Social Media',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
          actions: const [
            Icon(Icons.search),
            SizedBox(width: 10),
            Icon(Icons.more_vert),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: TabBarView(
          children: [
            _buildChatList(context),
            _buildChatList(context),
            _buildChatList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    return ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return ListTile(
          leading:
              CircleAvatar(backgroundImage: NetworkImage(contact['image']!)),
          title: Text(contact['name']!, style: GoogleFonts.poppins()),
          subtitle: Text(contact['message']!, style: GoogleFonts.poppins()),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(contact['name']!)),
          ),
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String contactName;

  const ChatScreen(this.contactName, {super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'user1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
        title: Text(widget.contactName, style: GoogleFonts.poppins()),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        showUserAvatars: true,
        showUserNames: true,
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: '${_messages.length}',
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });
  }
}
