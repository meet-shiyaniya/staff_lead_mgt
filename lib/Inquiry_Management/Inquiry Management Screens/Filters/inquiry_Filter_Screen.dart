import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: inquiryFilterScreen()));
}

class inquiryFilterScreen extends StatefulWidget {
  const inquiryFilterScreen({super.key});

  @override
  State<inquiryFilterScreen> createState() => _inquiryFilterScreenState();
}

class _inquiryFilterScreenState extends State<inquiryFilterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInquiryBottomSheet(context);
    });
  }

  void _showInquiryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9, // 80% of screen height
        minChildSize: 0.9,    // Minimum size when dragged down
        maxChildSize: 0.9,    // Maximum size when dragged up
        builder: (context, scrollController) => const InquiryBottomSheet(),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(title: const Text("Inquiry Filter")),
      body: const Center(child: Text("Main Screen Content")),
    );
  }
}

class InquiryBottomSheet extends StatefulWidget {
  const InquiryBottomSheet({super.key});

  @override
  _InquiryBottomSheetState createState() => _InquiryBottomSheetState();
}

class _InquiryBottomSheetState extends State<InquiryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Custom Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ID
                      TextFormField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          labelText: 'ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Mobile
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Next Follow-up Date
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2026),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Next Follow-up Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Inquiry Stages
                      CombinedDropdownTextField(
                        options: ['New', 'Contacted', 'Qualified', 'Proposal', 'Closed'],
                        onSelected: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // Assign To
                      CombinedDropdownTextField(
                        options: ['John Doe', 'Jane Smith', 'Mike Johnson'],
                        onSelected: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // Inquiry Type
                      CombinedDropdownTextField(
                        options: ['Residential', 'Commercial', 'Industrial'],
                        onSelected: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // Inquiry Source Type
                      CombinedDropdownTextField(
                        options: ['Online', 'Referral', 'Walk-in'],
                        onSelected: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // Interested Area
                      CombinedDropdownTextField(
                        options: ['Downtown', 'Suburbs', 'Countryside'],
                        onSelected: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // Property Subtype
                      CombinedDropdownTextField(
                        options: ['Apartment', 'Villa', 'Townhouse'],
                        onSelected: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // Property Type
                      CombinedDropdownTextField(
                        options: ['Sale', 'Rent', 'Lease'],
                        onSelected: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // Interested Site
                      CombinedDropdownTextField(
                        options: ['Site A', 'Site B', 'Site C'],
                        onSelected: (value) {},
                      ),
                      const SizedBox(height: 16),
                      // Property Configuration
                      CombinedDropdownTextField(
                        options: ['1BHK', '2BHK', '3BHK'],
                        onSelected: (value) {},
                      ),
                      const SizedBox(height: 24),
                      // Submit Button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CombinedDropdownTextField extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelected;

  const CombinedDropdownTextField({
    super.key,
    required this.options,
    required this.onSelected,
  });

  @override
  State<CombinedDropdownTextField> createState() => _CombinedDropdownTextFieldState();
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
          offset: const Offset(0.0, 5.0),
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
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              suffixIconConstraints: const BoxConstraints(minWidth: 40),
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