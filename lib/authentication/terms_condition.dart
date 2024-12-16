import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';

class TermsConditionsDialog extends StatelessWidget {
  const TermsConditionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: tertiaryColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 500.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BabySitter - Terms and Conditions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10.0),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "Last Updated: [Date]\n\n"
                  "Welcome to BabySitter!\n"
                  "By using our app, you agree to the following terms and conditions. "
                  "Please read them carefully before proceeding with registration or using any of our services. "
                  "If you do not agree with any of these terms, you should not use our platform.\n\n"
                  "1. Acceptance of Terms\n"
                  "By accessing or using BabySitter, you agree to comply with and be bound by these Terms and Conditions. "
                  "These terms apply to all users of the app, including babysitters and parents.\n\n"
                  "2.Registration and Account Responsibilities\n"
                  "- Eligibility: You must be at least 18 years old to register as a babysitter or parent.\n"
                  "- Account Information: You agree to provide accurate, complete, and current information during registration. "
                  "Falsifying any details may result in account suspension.\n"
                  "- Account Security:You are responsible for maintaining the confidentiality of your account credentials and for any activity under your account.\n"
                  "- Account Types: You can register as a babysitter or a parent. Each type of account has specific functionalities and responsibilities outlined in this agreement.\n\n"
                  "3. Babysitter Responsibilities\n"
                  "- Babysitters must provide accurate information about their experience, skills, certifications, and availability.\n"
                  "- Babysitters agree to provide safe and responsible care to the children they are hired to babysit.\n"
                  "- Babysitters must comply with all applicable laws, including local childcare regulations.\n"
                  "- Babysitters understand that BabySitter is not responsible for any disputes arising between babysitters and parents.\n\n"
                  "4. Parent Responsibilities\n"
                  "- Parents must provide accurate and complete information about the children under their care, including any special needs, allergies, or requirements.\n"
                  "- Parents agree to communicate clearly with babysitters regarding expectations, including hours of care, activities, and any specific instructions.\n"
                  "- Parents are responsible for ensuring the safety of their children and for the payment of services to the babysitters.\n"
                  "- Parents understand that BabySitter is not liable for any issues that arise between parents and babysitters during or after the booking process.\n\n"
                  "5. Booking and Payment\n"
                  "- BabySitter acts as a platform connecting parents and babysitters. All bookings are agreements between the two parties.\n"
                  "- Payment terms and conditions are agreed upon between babysitters and parents.\n"
                  "- Any cancellations or modifications to bookings should be communicated as early as possible.\n"
                  "- BabySitter is not responsible for handling or facilitating payments. It is the responsibility of parents to compensate babysitters as per agreed terms.\n\n"
                  "6. Background Checks and Verification\n"
                  "- Babysitters may undergo background checks as part of the verification process. However, *BabySitter* does not guarantee the accuracy of any background check results or the reliability of babysitters.\n"
                  "- BabySitter encourages parents to conduct additional background checks and interviews before hiring a babysitter.\n\n"
                  "7. Prohibited Conduct\n"
                  "Users are prohibited from engaging in the following:\n"
                  "- Misrepresenting information on the platform.\n"
                  "- Harassing or threatening any other user of the app.\n"
                  "- Using the platform for any unlawful activities.\n"
                  "- Sharing account credentials with others or impersonating another user.\n"
                  "- Engaging in any conduct that may harm or exploit children in any way.\n\n"
                  "8. Limitation of Liability\n"
                  "- BabySitter is a marketplace platform connecting parents with babysitters. We do not employ babysitters, nor do we provide babysitting services.\n"
                  "- BabySitter is not responsible for any damages, disputes, injuries, or losses resulting from services provided by babysitters.\n"
                  "- Users agree to hold BabySitter harmless from any claims or damages arising from the use of the app.\n\n"
                  "9. Termination of Account\n"
                  "We reserve the right to suspend or terminate accounts that violate these Terms and Conditions, engage in fraudulent activity, or otherwise misuse the platform.\n\n"
                  "10. Changes to Terms\n"
                  "We may update these Terms and Conditions from time to time. Continued use of the app after changes are posted constitutes acceptance of the revised terms.\n\n",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'Decline',
                    style: TextStyle(color: textColor),
                  ),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
