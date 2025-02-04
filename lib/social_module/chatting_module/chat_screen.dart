import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../colors/colors.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, String> contact;

  const ChatScreen({super.key, required this.contact});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isEmojiVisible = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _messages = [
      types.TextMessage(
        author: const types.User(id: 'user_1'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '1',
        text: 'Hello! How are you?',
      ),
      types.TextMessage(
        author: const types.User(id: 'user_2'),
        createdAt: DateTime.now().millisecondsSinceEpoch + 1000,
        id: '2',
        text: 'I am good, thanks! How about you?',
      ),
      types.TextMessage(
        author: const types.User(id: 'user_1'),
        createdAt: DateTime.now().millisecondsSinceEpoch + 2000,
        id: '3',
        text: 'I am doing great, just working on some things.',
      ),
      types.TextMessage(
        author: const types.User(id: 'user_2'),
        createdAt: DateTime.now().millisecondsSinceEpoch + 3000,
        id: '4',
        text: 'That sounds cool! What are you working on?',
      ),
      types.TextMessage(
        author: const types.User(id: 'user_1'),
        createdAt: DateTime.now().millisecondsSinceEpoch + 4000,
        id: '5',
        text: 'Just improving my Flutter skills and working on an app.',
      ),
    ];
  }

  void _sendMessage(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: const types.User(id: 'user_1'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );
    setState(() {
      _messages.insert(0, textMessage);
    });
  }

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Handle image sending logic here
    }
  }

  void _onEmojiSelected(Emoji emoji) {
    _controller.text += emoji.emoji;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/user_exampletabbar.png'), // Ensure this asset exists
          ),
        ),
        title: Text(
          widget.contact['name']!,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor.withOpacity(0.7),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              isAttachmentUploading: true,
              messages: _messages,
              onSendPressed: (message) => _sendMessage(message),
              user: const types.User(id: 'user_1'),
              theme: DefaultChatTheme(
                attachmentButtonIcon: const Icon(Icons.add, color: Colors.black),
                primaryColor: AppColors.primaryColor.withOpacity(0.7),
                inputBackgroundColor: Colors.white,
                inputTextColor: Colors.black,
                sentMessageBodyTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                receivedMessageBodyTextStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          if (_isEmojiVisible)
            EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _onEmojiSelected(emoji);
              },
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {
                    setState(() {
                      _isEmojiVisible = !_isEmojiVisible;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _sendMessage(types.PartialText(text: _controller.text));
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
