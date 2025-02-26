import 'package:flutter/material.dart';

class CombinedDropdownTextField extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelected;

  const CombinedDropdownTextField({
    super.key,
    required this.options,
    required this.onSelected,
  });

  @override
  State<CombinedDropdownTextField> createState() =>
      _CombinedDropdownTextFieldState();
}

class _CombinedDropdownTextFieldState extends State<CombinedDropdownTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _isDropdownVisible = false;
  List<String> _filteredOptions = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isDropdownVisible = _focusNode.hasFocus;
      if (_isDropdownVisible) {
        _showOverlay(context);
      } else {
        _hideOverlay();
      }
    });
  }

  void _filterOptions(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((option) => option.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectOption(String option) {
    setState(() {
      _controller.text = option;
      _filteredOptions = [];
      _isDropdownVisible = false;
    });
    widget.onSelected(option);
    _focusNode.unfocus();
    _hideOverlay();
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Card(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  return InkWell(
                    onTap: () => _selectOption(option),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Select or Type',
              hintStyle: const TextStyle(fontFamily: "poppins_light"),
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              suffixIcon: _isDropdownVisible
                  ? IconButton(
                icon: const Icon(Icons.arrow_drop_up),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = false;
                    _focusNode.unfocus();
                    _hideOverlay();
                  });
                },
              )
                  : IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = true;
                    _focusNode.requestFocus();
                    _filterOptions(_controller.text);
                    _showOverlay(context);
                  });
                },
              ),
            ),
            onChanged: _filterOptions,
            onTap: () {
              setState(() {
                _isDropdownVisible = true;
                _focusNode.requestFocus();
                _filterOptions(_controller.text);
                _showOverlay(context);
              });
            },
          ),
        ],
      ),
    );
  }
}