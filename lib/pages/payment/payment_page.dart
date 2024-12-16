import 'package:babysitterapp/pages/confirmation/confirmpage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PaymentPage extends StatefulWidget {
  final String babysitterImage;
  final String babysitterName;
  final String babysitterEmail;
  final DateTime selectedDate;
  final String parentName;
  final String specialRequirements;
  final String duration;
  String? paymentMode;
  final String totalpayment;
  final double babysitterRate;
  PaymentPage(
      {super.key,
      required this.babysitterImage,
      required this.babysitterName,
      required this.parentName,
      required this.specialRequirements,
      required this.duration,
      required this.paymentMode,
      required this.totalpayment,
      required this.babysitterRate,
      required this.babysitterEmail, required this.selectedDate});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Function to show confirmation dialog
  Future<void> _showConfirmationDialog(VoidCallback onConfirm) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Payment Method'),
          content: const Text(
              'Are you sure you want to proceed with this payment method?'),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  // Payment functions
  void _payWithGCash() {
    _showConfirmationDialog(() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(
            babysitterImage: widget.babysitterImage,
            babysitterName: widget.babysitterName,
            parentName: widget.parentName,
            specialRequirements: widget.specialRequirements,
            paymentMode: widget.paymentMode!,
            duration: widget.duration.toString(),
            totalpayment: widget.totalpayment,
            babysitterRate: widget.babysitterRate,
            babysitterEmail: widget.babysitterEmail, 
            selectedDate: widget.selectedDate,
          ),
        ),
      );
    });
  }

  void _payWithDirectPay() {
    _showConfirmationDialog(() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(
            babysitterImage: widget.babysitterImage,
            babysitterName: widget.babysitterName,
            babysitterEmail: widget.babysitterEmail,
            parentName: widget.parentName,
            specialRequirements: widget.specialRequirements,
            paymentMode: widget.paymentMode!,
            duration: widget.duration.toString(),
            totalpayment: widget.totalpayment,
            babysitterRate: widget.babysitterRate,
            selectedDate: widget.selectedDate,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Method')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Choose Payment Method:',
                  style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                // Payment options grid
                GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  children: [
                    _buildPaymentOption(
                      label: 'GCash',
                      iconPath:
                          'assets/images/gcash.png', // Update path as needed
                      onTap: () {
                        setState(() {
                          widget.paymentMode = 'GCash';
                        });
                        _payWithGCash();
                      },
                    ),
                    _buildPaymentOption(
                      label: 'Cash Upon Arrival',
                      iconPath:
                          'assets/images/cua.png', // Update path as needed
                      onTap: () {
                        setState(() {
                          widget.paymentMode = 'Direct Pay';
                        });
                        _payWithDirectPay();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String label,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}

// Success Screen
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.deepPurple, size: 80),
            SizedBox(height: 20),
            Text(
              'Congratulations!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You have successfully paid.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
