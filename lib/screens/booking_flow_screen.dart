import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingFlowScreen extends StatefulWidget {
  final String packageName;
  final double packagePrice;

  const BookingFlowScreen({
    super.key,
    required this.packageName,
    required this.packagePrice,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowPageState();
}

class _BookingFlowPageState extends State<BookingFlowScreen> {
  final PageController _controller = PageController();


  String name = "";
  String email = "";
  String phone = "";
  String? address;
  DateTime? travelDate;
  int adults = 1;
  int children = 0;
  int infants = 0;

  bool hotelUpgrade = false;
  bool extraGuide = false;
  bool extraMeal = false;
  bool transportUpgrade = false;

  bool acceptedTerms = false;



  void _nextPage() {
    int currentPage = _controller.page!.toInt();


    if (currentPage == 0) {
      if (name.isEmpty || email.isEmpty || phone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields")),
        );
        return;
      }
    } else if (currentPage == 1) {
      if (travelDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select travel date")),
        );
        return;
      }
    } else if (currentPage == 2) {
      if (adults < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("At least one adult is required")),
        );
        return;
      }
    } else if (currentPage == 5) {
      if (!acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must accept terms & conditions")),
        );
        return;
      }
    }


    if (currentPage < 6) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_controller.page!.toInt() > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }



  Widget _stepWrapper({required Widget child}) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.65,
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }



  Widget _customTextField({
    required String label,
    required String hint,
    required Function(String) onChanged,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isOptional ? " (Optional)" : ""),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.orange, width: 2),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _counterRow(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              onPressed: () => onChanged(value > 0 ? value - 1 : 0),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text("$value", style: const TextStyle(fontSize: 16)),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        )
      ],
    );
  }

  Widget _gradientButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isGrey = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: isGrey
              ? const LinearGradient(
            colors: [Colors.grey, Colors.black45],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : const LinearGradient(
            colors: [Color(0xFF044BA3), Color(0xFF49A4F3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOnCard(String title, bool value, ValueChanged<bool?> onChanged) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: CheckboxListTile(
        value: value,
        title: Text(title),
        onChanged: onChanged,
      ),
    );
  }



  Widget _buildUserInfoPage() {
    return _stepWrapper(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _customTextField(
              label: "Full Name",
              hint: "Enter your name",
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 16),
            _customTextField(
              label: "Email",
              hint: "Enter your email",
              onChanged: (v) => email = v,
            ),
            const SizedBox(height: 16),
            _customTextField(
              label: "Phone",
              hint: "Enter your phone number",
              onChanged: (v) => phone = v,
            ),
            const SizedBox(height: 16),
            _customTextField(
              label: "Address",
              hint: "Enter your address",
              isOptional: true,
              onChanged: (v) => address = v,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectionPage() {
    return _stepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Travel Date",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF044BA3),
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) setState(() => travelDate = picked);
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text("Choose Date"),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
          const SizedBox(height: 12),
          if (travelDate != null)
            Text("Selected: ${DateFormat('yyyy-MM-dd').format(travelDate!)}"),
        ],
      ),
    );
  }

  Widget _buildTravelerPage() {
    return _stepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Traveler Count",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _counterRow("Adults", adults, (v) => setState(() => adults = v)),
          const SizedBox(height: 8),
          _counterRow("Children", children, (v) => setState(() => children = v)),
          const SizedBox(height: 8),
          _counterRow("Infants", infants, (v) => setState(() => infants = v)),
        ],
      ),
    );
  }

  Widget _buildAddOnPage() {
    return _stepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add-ons",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildAddOnCard("Hotel Upgrade", hotelUpgrade,
                  (v) => setState(() => hotelUpgrade = v ?? false)),
          _buildAddOnCard("Extra Guide", extraGuide,
                  (v) => setState(() => extraGuide = v ?? false)),
          _buildAddOnCard("Extra Meal Plan", extraMeal,
                  (v) => setState(() => extraMeal = v ?? false)),
          _buildAddOnCard("Transport Upgrade", transportUpgrade,
                  (v) => setState(() => transportUpgrade = v ?? false)),
        ],
      ),
    );
  }

  Widget _buildPaymentPage() {
    double total = widget.packagePrice;
    if (hotelUpgrade) total += 200;
    if (extraGuide) total += 150;
    if (extraMeal) total += 100;
    if (transportUpgrade) total += 300;

    return _stepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text("Base Price: \$${widget.packagePrice.toStringAsFixed(2)}"),
          Text("Total: \$${total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _gradientButton(
            label: "Pay with Bkash",
            icon: Icons.payment,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Only Cash on Arrival is allowed")),
              );
            },
            isGrey: true,
          ),
          const SizedBox(height: 10),
          _gradientButton(
            label: "Pay with Card",
            icon: Icons.credit_card,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Only Cash on Arrival is allowed")),
              );
            },
            isGrey: true,
          ),
          const SizedBox(height: 10),
          _gradientButton(
            label: "Cash on Arrival",
            icon: Icons.money,
            onPressed: () {
              _controller.animateToPage(
                5, // Terms & Conditions page index
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildTermsPage() {
    return _stepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Terms & Conditions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                "Before booking, you must accept:\n\n"
                    "1. Cancellation & Refund Policy\n"
                    "2. Travel Policy (ID required)\n"
                    "3. Health and Safety Guidelines\n",
              ),
            ),
          ),
          CheckboxListTile(
            value: acceptedTerms,
            title: const Text("I accept the terms & conditions"),
            onChanged: (v) => setState(() => acceptedTerms = v!),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationPage() {
    return _stepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 20),
          const Text("Booking Successful!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text("Booking ID: BK${DateTime.now().millisecondsSinceEpoch}"),
          const SizedBox(height: 12),
          Text("Name: $name"),
          Text("Phone: $phone"),
          Text("Email: $email"),
          if (address != null && address!.isNotEmpty) Text("Address: $address"),
          Text("Package: ${widget.packageName}"),
          Text(
              "Travel Date: ${travelDate != null ? DateFormat('yyyy-MM-dd').format(travelDate!) : 'Not set'}"),
          const SizedBox(height: 30),
          _gradientButton(
            label: "Return to Home",
            icon: Icons.home,
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    int currentPage = (_controller.hasClients ? _controller.page?.toInt() ?? 0 : 0);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Book: ${widget.packageName}"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF044BA3), Color(0xFF49A4F3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: currentPage / 6,
            backgroundColor: Colors.grey[300],
            color: Colors.blueAccent,
            minHeight: 5,
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildUserInfoPage(),
                _buildDateSelectionPage(),
                _buildTravelerPage(),
                _buildAddOnPage(),
                _buildPaymentPage(),
                _buildTermsPage(),
                _buildConfirmationPage(),
              ],
            ),
          ),
          if (currentPage != 6)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _gradientButton(
                      label: "Back",
                      icon: Icons.arrow_back,
                      onPressed: _prevPage,
                      isGrey: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _gradientButton(
                      label: "Next",
                      icon: Icons.arrow_forward,
                      onPressed: _nextPage,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
