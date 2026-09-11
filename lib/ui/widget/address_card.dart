import 'package:flutter/material.dart';
import 'package:gompa_tour/l10n/generated/app_localizations.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/models/contact.dart';

class AddressCard extends StatelessWidget {
  final List<dynamic> translations;
  final Contact? contact;
  final String geoLocation;
  const AddressCard(
      {super.key,
      required this.translations,
      this.contact,
      required this.geoLocation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shadowColor: Theme.of(context).colorScheme.shadow,
          color: Theme.of(context).colorScheme.surfaceContainer,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.address,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (translations.isNotEmpty) ...[
                  Text(
                    'Name: ${context.localizedField(
                      translations: translations,
                      getter: (t) => t.name,
                    )}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (contact != null && contact!.translations.isNotEmpty) ...[
                  Text(
                    'Address: ${context.localizedField(
                      translations: contact!.translations,
                      getter: (t) => t.address,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'State: ${context.localizedField(
                      translations: contact!.translations,
                      getter: (t) => t.state,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Postal Code: ${context.localizedField(
                      translations: contact!.translations,
                      getter: (t) => t.postalCode ?? '',
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Country: ${context.localizedField(
                      translations: contact!.translations,
                      getter: (t) => t.country,
                    )}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (contact != null) ...[
                  Text(
                    'Phone: ${contact!.phoneNumber}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${contact!.email}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                ],
                if (geoLocation.isNotEmpty) ...[
                  Text(
                    'Map: $geoLocation',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
