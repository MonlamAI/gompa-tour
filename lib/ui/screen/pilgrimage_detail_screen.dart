import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gompa_tour/states/pilgrim_site_state.dart';
import 'package:gompa_tour/ui/widget/address_card.dart';
import 'package:gompa_tour/ui/widget/card_tag.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/helper/localization_helper.dart';
import 'package:gompa_tour/ui/widget/gonpa_cache_image.dart';
import 'package:gompa_tour/ui/widget/location_card.dart';

class PilgrimageDetailScreen extends ConsumerWidget {
  static const String routeName = '/pilgrimage-detail';
  const PilgrimageDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPilgrimSite = ref.watch(selectedPilgrimSiteProvider);

    if (selectedPilgrimSite == null) {
      return const Scaffold(
        appBar: GonpaAppBar(title: 'Pilgrimage Detail'),
        body: Center(child: Text('No pilgrim selected')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GonpaAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  context.localizedField(
                    translations: selectedPilgrimSite.translations,
                    getter: (t) => t.name,
                  ),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: context.getLocalizedHeight(),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: selectedPilgrimSite.id,
                  child: GonpaCacheImage(
                    url: selectedPilgrimSite.image,
                  ),
                ),
              ),
              if (selectedPilgrimSite.contact != null &&
                  selectedPilgrimSite.contact!.translations.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Tag(
                      text: context.localizedField(
                        translations: selectedPilgrimSite.contact!.translations,
                        getter: (t) => t.state,
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    Tag(
                      text: context.localizedField(
                        translations: selectedPilgrimSite.contact!.translations,
                        getter: (t) => t.country,
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Text(
                context.localizedField(
                  translations: selectedPilgrimSite.translations,
                  getter: (t) => t.description,
                ),
                style: TextStyle(
                  fontSize: 16,
                  height: context.getLocalizedHeight(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              AddressCard(
                contact: selectedPilgrimSite.contact,
                translations: selectedPilgrimSite.translations,
                geoLocation: selectedPilgrimSite.geoLocation,
              ),
              const SizedBox(
                height: 16,
              ),
              if (selectedPilgrimSite.geoLocation.isNotEmpty)
                LocationCard(
                  address: selectedPilgrimSite,
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
