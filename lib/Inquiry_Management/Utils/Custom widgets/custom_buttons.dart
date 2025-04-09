import 'package:flutter/material.dart';
import 'package:switcher_button/switcher_button.dart';

class MainButtonGroup extends StatefulWidget {
  final List<String> buttonTexts;
  final String selectedButton;
  final ValueChanged<String> onButtonPressed;

  const MainButtonGroup({
    Key? key,
    required this.buttonTexts,
    required this.selectedButton,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  _MainButtonGroupState createState() => _MainButtonGroupState();
}

class _MainButtonGroupState extends State<MainButtonGroup> {
  late String _selectedButton;

  @override
  void initState() {
    super.initState();
    _selectedButton = widget.selectedButton;
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> buttonRows = _splitIntoRows(widget.buttonTexts, 3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: buttonRows.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((text) => _buildButton(text)).toList(),
          );
        }).toList(),
      ),
    );
  }

  List<List<String>> _splitIntoRows(List<String> items, int buttonsPerRow) {
    List<List<String>> rows = [];
    for (int i = 0; i < items.length; i += buttonsPerRow) {
      rows.add(items.sublist(i, (i + buttonsPerRow) > items.length ? items.length : (i + buttonsPerRow)));
    }
    return rows;
  }

  Widget _buildButton(String text) {
    final bool isSelected = _selectedButton == text;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.deepPurple.shade100 : Colors.white,
            foregroundColor: isSelected ? Colors.deepPurple : Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
            ),
            elevation: 0,
          ),
          onPressed: () {
            setState(() {
              _selectedButton = text;
            });
            widget.onButtonPressed(text);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "poppins_thin",
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double height;
  final double width;
  final Icon? icon;
  final double borderRadius;
  final TextStyle? textStyle;
  final  bool? enable;

  // Constructor with required and optional parameters
  GradientButton({
    required this.buttonText,
    required this.onPressed,
    this.gradientColors = const [Colors.deepPurple, Colors.purple], // Default gradient
    this.height = 40.0, // Default height
    this.width = double.infinity, // Default width
    this.borderRadius = 30.0, // Default border radius
    this.textStyle, // Optional custom text style
    this.icon, // Optional icon
    this.enable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width, // Width of the button
        height: height, // Height of the button
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
          gradient: LinearGradient(
            colors: gradientColors, // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center content horizontally
            crossAxisAlignment: CrossAxisAlignment.center, // Center content vertically
            mainAxisSize: MainAxisSize.min, // Shrink to fit the content
            children: [
              if (icon != null) ...[
                icon!, // Display the icon if provided
                // const SizedBox(width: 8.0), // Add spacing between icon and text
              ],
              Text(
                buttonText,
                style: textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "poppins_thin",
                    ), // Text styling, uses default or custom text style
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class demo extends StatefulWidget {
  const demo({super.key});

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: Center(
          child: SwitcherButton(
            value: true,
            onChange: (value) {
              print(value);
            },
          ),
        ),
      ),
    );
  }
}
class mainbutton extends StatefulWidget {
  const mainbutton({super.key});

  @override
  State<mainbutton> createState() => _mainbuttonState();
}

class _mainbuttonState extends State<mainbutton> {
  // Main Filter Button Group

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
