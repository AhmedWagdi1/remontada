import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/media/my_media.dart';
import '../../../../shared/widgets/customtext.dart';

/// Page allowing users to create a new team.
class CreateTeamPage extends StatefulWidget {
  /// Default constructor for [CreateTeamPage].
  const CreateTeamPage({super.key});

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  File? _logo;

  /// Picks an image from the gallery and updates the logo state.
  Future<void> _pickLogo() async {
    final image = await MyMedia.pickImageFromGallery();
    if (image != null) {
      setState(() => _logo = image);
    }
  }

  /// Builds a single player card with form fields.
  Widget _buildPlayerCard(int index) {
    const darkBlue = Color(0xFF23425F);
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CustomText(
                    '${LocaleKeys.player_card_title.tr()} $index',
                    color: darkBlue,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey.shade200,
                    child: CustomText('$index', fontSize: 12, color: darkBlue),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: LocaleKeys.player_name_label.tr(),
                  hintText: LocaleKeys.player_name_hint.tr(),
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: LocaleKeys.player_number_label.tr(),
                  hintText: LocaleKeys.player_number_hint.tr(),
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: LocaleKeys.player_phone_label.tr(),
                  hintText: LocaleKeys.player_phone_hint.tr(),
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomText(
              LocaleKeys.mandatory_tag.tr(),
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  @override

  /// Builds the full create team page UI.
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    LocaleKeys.create_team_title.tr(),
                    color: darkBlue,
                    weight: FontWeight.bold,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: darkBlue),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomText(
                  LocaleKeys.team_logo_section.tr(),
                  color: darkBlue,
                  weight: FontWeight.bold,
                  align: TextAlign.right,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickLogo,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: darkBlue),
                        ),
                        child: _logo != null
                            ? ClipOval(
                                child: Image.file(_logo!, fit: BoxFit.cover),
                              )
                            : const Icon(Icons.camera_alt, color: darkBlue),
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        LocaleKeys.team_add_image.tr(),
                        color: darkBlue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomText(
                  LocaleKeys.team_info_section.tr(),
                  color: darkBlue,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: LocaleKeys.team_name_label.tr(),
                    hintText: LocaleKeys.team_name_hint.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.team_description_label.tr(),
                    hintText: LocaleKeys.team_description_hint.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: darkBlue, size: 18),
                    const SizedBox(width: 4),
                    CustomText(
                      LocaleKeys.team_level_label.tr(),
                      color: darkBlue,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.team_level_hint.tr(),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    LocaleKeys.team_level_note.tr(),
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.groups_2, color: darkBlue),
                    const SizedBox(width: 4),
                    CustomText(
                      LocaleKeys.coaching_staff_section.tr(),
                      color: darkBlue,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 18,
                                color: darkBlue,
                              ),
                              const SizedBox(width: 4),
                              CustomText(
                                LocaleKeys.coach_title.tr(),
                                color: darkBlue,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: LocaleKeys.coach_name_label.tr(),
                              hintText: LocaleKeys.coach_name_hint.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: LocaleKeys.coach_phone_label.tr(),
                              hintText: LocaleKeys.coach_phone_hint.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 18,
                                color: darkBlue,
                              ),
                              const SizedBox(width: 4),
                              CustomText(
                                LocaleKeys.assistant_title.tr(),
                                color: darkBlue,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: LocaleKeys.assistant_name_label.tr(),
                              hintText: LocaleKeys.assistant_name_hint.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: LocaleKeys.assistant_phone_label.tr(),
                              hintText: LocaleKeys.assistant_phone_hint.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.groups, color: darkBlue),
                    const SizedBox(width: 4),
                    CustomText(
                      LocaleKeys.players_list_section.tr(),
                      color: darkBlue,
                      weight: FontWeight.bold,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: CustomText(
                        LocaleKeys.players_list_badge.tr(),
                        color: darkBlue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          LocaleKeys.players_mandatory_note.tr(),
                          color: darkBlue,
                        ),
                      ),
                      const Icon(Icons.info_outline, color: darkBlue, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildPlayerCard(1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
