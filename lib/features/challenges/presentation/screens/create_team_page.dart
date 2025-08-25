import 'dart:io';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/media/my_media.dart';
import '../../../../core/services/media/alert_of_media.dart';
import '../../../../shared/widgets/customtext.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/key.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/Router/Router.dart';
import '../../../../core/utils/validations.dart';

/// Converts the dynamic value returned from the API into a valid team id.
///
/// Throws a [FormatException] when the id is missing or not numeric.
int parseTeamId(dynamic teamId) {
  if (teamId == null) {
    throw const FormatException('team_id is missing from response');
  }
  final parsed = int.tryParse(teamId.toString());
  if (parsed == null) {
    throw FormatException('Invalid team_id format: $teamId');
  }
  return parsed;
}

/// Page allowing users to create a new team.
class CreateTeamPage extends StatefulWidget {
  /// Default constructor for [CreateTeamPage].
  const CreateTeamPage({super.key});

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  File? _logo;
  bool _inviteEnabled = false;
  final Set<String> _selectedPlatforms = {};
  bool _isSubmitting = false;

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _coachNameController = TextEditingController();
  final TextEditingController _coachPhoneController = TextEditingController();
  final TextEditingController _assistantNameController = TextEditingController();
  final TextEditingController _assistantPhoneController = TextEditingController();

  final List<TextEditingController> _playerPhoneControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final List<TextEditingController> _playerNameControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    _coachNameController.text = Utils.user.user?.name ?? '';
    _coachPhoneController.text = Utils.user.user?.phone ?? '';
  }

  /// Builds a choice chip for selecting a social platform.
  Widget _buildSocialChip(String key, IconData icon, String label) {
    const darkBlue = Color(0xFF23425F);
    final selected = _selectedPlatforms.contains(key);
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: selected ? Colors.white : darkBlue),
          const SizedBox(width: 4),
          CustomText(label, color: selected ? Colors.white : darkBlue),
        ],
      ),
      selected: selected,
      onSelected: (val) {
        if (_isSubmitting) return;
        setState(() {
          if (val) {
            _selectedPlatforms.add(key);
          } else {
            _selectedPlatforms.remove(key);
          }
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: darkBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _bioController.dispose();
    _coachNameController.dispose();
    _coachPhoneController.dispose();
    _assistantNameController.dispose();
    _assistantPhoneController.dispose();
    for (final c in _playerPhoneControllers) {
      c.dispose();
    }
    for (final c in _playerNameControllers) {
      c.dispose();
    }
    super.dispose();
  }


  /// Handles the multi-step create team flow as described in the docs.
  Future<void> _submitForm() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      // Only require captain and subleader
      final captainName = _coachNameController.text.trim();
      final captainPhone = _coachPhoneController.text.trim();
      final subName = _assistantNameController.text.trim();
      final subPhone = _assistantPhoneController.text.trim();
      final teamName = _teamNameController.text.trim();
      // --- VALIDATION & CHECKS FIRST ---
      if (teamName.isEmpty) {
        await _showError('يرجى إدخال اسم الفريق.');
        setState(() => _isSubmitting = false);
        return;
      }
      if (captainName.isEmpty || captainPhone.isEmpty) {
        await _showError('يرجى إدخال بيانات الكابتن (الاسم ورقم الجوال).');
        setState(() => _isSubmitting = false);
        return;
      }
      if (subName.isEmpty || subPhone.isEmpty) {
        await _showError('يرجى إدخال بيانات المساعد (الاسم ورقم الجوال).');
        setState(() => _isSubmitting = false);
        return;
      }
      // Validate phone formats
      if (!(Validation.isValidSaudiPhoneNumber(captainPhone) ?? false)) {
        await _showError('رقم جوال الكابتن غير صالح. يجب أن يبدأ بـ 0 ويتكون من 10 أرقام.');
        setState(() => _isSubmitting = false);
        return;
      }
      if (!(Validation.isValidSaudiPhoneNumber(subPhone) ?? false)) {
        await _showError('رقم جوال المساعد غير صالح. يجب أن يبدأ بـ 0 ويتكون من 10 أرقام.');
        setState(() => _isSubmitting = false);
        return;
      }
      if (captainPhone == subPhone) {
        await _showError('رقم جوال الكابتن والمساعد متطابقان. يرجى إدخال رقمين مختلفين.');
        setState(() => _isSubmitting = false);
        return;
      }
      // 1. Check team name uniqueness
      final allTeamsRes = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/team/all-active'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );
      final allTeamsData = jsonDecode(allTeamsRes.body);
      if (allTeamsRes.statusCode >= 400 || allTeamsData['status'] != true) {
        await _showError('تعذر التحقق من أسماء الفرق.');
        setState(() => _isSubmitting = false);
        return;
      }
      final List<dynamic> teams = allTeamsData['data'] ?? [];
  final teamNames = teams.map((t) => t['name'].toString().trim()).toSet();
      if (teamNames.contains(teamName)) {
        await _showError('اسم الفريق مستخدم بالفعل. يرجى اختيار اسم آخر.');
        setState(() => _isSubmitting = false);
        return;
      }
      // 2. Check subleader is not in other teams (captain can create and join his own team)
      bool subleaderInTeam = false;
      for (final team in teams) {
        final teamId = team['id'];
        final teamShowRes = await http.get(
          Uri.parse('${ConstKeys.baseUrl}/team/show/$teamId'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Utils.token}',
          },
        );
        final teamShowData = jsonDecode(teamShowRes.body);
        if (teamShowRes.statusCode >= 400 || teamShowData['status'] != true) continue;
        final List<dynamic> users = teamShowData['data']['users'] ?? [];
        for (final user in users) {
          final mobile = user['mobile'].toString().trim();
          if (mobile == subPhone) subleaderInTeam = true;
        }
      }
      if (subleaderInTeam) {
        await _showError('المساعد بالفعل عضو في فريق آخر. يرجى اختيار مساعد آخر.');
        setState(() => _isSubmitting = false);
        return;
      }
      // 3. Check both phones are registered
      Future<bool> isPhoneRegistered(String phone) async {
        final loginRes = await http.post(
          Uri.parse('${ConstKeys.baseUrl}/login'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'mobile': phone}),
        );
        final loginData = jsonDecode(loginRes.body);
        // If status is true, phone is registered
        return loginRes.statusCode < 400 && loginData['status'] == true;
      }
      if (!await isPhoneRegistered(captainPhone)) {
        await _showError('رقم جوال الكابتن غير مسجل في النظام.');
        setState(() => _isSubmitting = false);
        return;
      }
      if (!await isPhoneRegistered(subPhone)) {
        await _showError('رقم جوال المساعد غير مسجل في النظام.');
        setState(() => _isSubmitting = false);
        return;
      }
      // --- END VALIDATION & CHECKS ---
      // Step 1: create the team
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ConstKeys.baseUrl}/team/store'),
      )
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer ${Utils.token}'
        ..fields['area_id'] = (Utils.user.user?.cityId ?? '').toString()
        ..fields['bio'] = _bioController.text
        ..fields['name'] = teamName;
      if (_logo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('logo', _logo!.path),
        );
      }
      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);
      final data = jsonDecode(res.body);
      if (res.statusCode >= 400 || data['status'] != true) {
        await _showError(data['message'] ?? 'خطأ غير متوقع');
        setState(() => _isSubmitting = false);
        return;
      }
      final dynamic teamIdRaw = data['data']['id'];
      final teamId = parseTeamId(teamIdRaw);
      // Step 2: add subleader and normal members as members
      List<String> addedPhones = [];
      // Add subleader as member
      final subRes = await http.post(
        Uri.parse('${ConstKeys.baseUrl}/team/add-member'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
        body: jsonEncode({
          'phone_number': subPhone,
          'team_id': teamId,
        }),
      );
      final subData = jsonDecode(subRes.body);
      if (subRes.statusCode >= 400 || subData['status'] != true) {
        // Rollback: delete the team
        try {
          await http.delete(
            Uri.parse('${ConstKeys.baseUrl}/team/$teamId'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${Utils.token}',
            },
          );
        } catch (_) {}
        await _showError(subData['message'] ?? 'خطأ في إضافة المساعد كعضو.');
        setState(() => _isSubmitting = false);
        return;
      } else {
        addedPhones.add(subPhone);
      }
      // Add normal members if any (from player phone controllers)
      final List<String> memberPhones = _playerPhoneControllers.map((c) => c.text.trim()).where((p) => p.isNotEmpty).toList();
      for (final phone in memberPhones) {
        if (phone == captainPhone || phone == subPhone) continue; // skip captain and subleader
        final memberRes = await http.post(
          Uri.parse('${ConstKeys.baseUrl}/team/add-member'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Utils.token}',
          },
          body: jsonEncode({
            'phone_number': phone,
            'team_id': teamId,
          }),
        );
        final memberData = jsonDecode(memberRes.body);
        if (memberRes.statusCode >= 400 || memberData['status'] != true) {
          // Rollback: remove added members, then delete the team
          for (final addedPhone in addedPhones) {
            try {
              await http.post(
                Uri.parse('${ConstKeys.baseUrl}/team/remove-member'),
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${Utils.token}',
                },
                body: jsonEncode({
                  'phone_number': addedPhone,
                  'team_id': teamId,
                }),
              );
            } catch (_) {}
          }
          try {
            await http.delete(
              Uri.parse('${ConstKeys.baseUrl}/team/$teamId'),
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer ${Utils.token}',
              },
            );
          } catch (_) {}
          await _showError(memberData['message'] ?? 'خطأ في إضافة العضو ذو الرقم $phone');
          setState(() => _isSubmitting = false);
          return;
        } else {
          addedPhones.add(phone);
        }
      }
      // Step 3: assign subleader role
      final roleRes = await http.post(
        Uri.parse('${ConstKeys.baseUrl}/team/member-role'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
        body: jsonEncode({
          'phone_number': subPhone,
          'team_id': teamId,
          'role': 'subleader',
        }),
      );
      final roleData = jsonDecode(roleRes.body);
      if (roleRes.statusCode >= 400 || roleData['status'] != true) {
        // Rollback: remove added members, then delete the team
        for (final addedPhone in addedPhones) {
          try {
            await http.post(
              Uri.parse('${ConstKeys.baseUrl}/team/remove-member'),
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${Utils.token}',
              },
              body: jsonEncode({
                'phone_number': addedPhone,
                'team_id': teamId,
              }),
            );
          } catch (_) {}
        }
        try {
          await http.delete(
            Uri.parse('${ConstKeys.baseUrl}/team/$teamId'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${Utils.token}',
            },
          );
        } catch (_) {}
        await _showError(roleData['message'] ?? 'تعذر تعيين الدور للمساعد.');
        setState(() => _isSubmitting = false);
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الفريق بنجاح!')),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.challengesScreen,
        (route) => false,
      );
    } catch (e) {
      await _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _showError(String message) async {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to choose between camera and gallery for logo selection.
  Future<void> _showLogoSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => AlertOfMedia(
        cameraTap: () async {
          Navigator.pop(context);
          final image = await MyMedia.pickImageFromCamera();
          if (image != null) {
            setState(() => _logo = image);
          }
        },
        galleryTap: () async {
          Navigator.pop(context);
          final image = await MyMedia.pickImageFromGallery();
          if (image != null) {
            setState(() => _logo = image);
          }
        },
      ),
    );
  }

  /// Builds a single player card for entering a player's phone number.
  Widget _buildPlayerCard(int index, TextEditingController phoneController, TextEditingController nameController) {
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
                controller: nameController,
                enabled: !_isSubmitting,
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
                controller: phoneController,
                enabled: !_isSubmitting,
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
                  onTap: _showLogoSourceDialog,
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
                            : const Icon(Icons.add_a_photo, color: darkBlue),
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        '${LocaleKeys.team_add_image.tr()} (Camera/Gallery)',
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
                  controller: _teamNameController,
                  enabled: !_isSubmitting,
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
                  controller: _bioController,
                  enabled: !_isSubmitting,
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
                            controller: _coachNameController,
                            readOnly: true,
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
                            controller: _coachPhoneController,
                            readOnly: true,
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
                            controller: _assistantNameController,
                            enabled: !_isSubmitting,
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
                            controller: _assistantPhoneController,
                            enabled: !_isSubmitting,
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
                for (int i = 0; i < _playerPhoneControllers.length; i++)
                  _buildPlayerCard(i + 1, _playerPhoneControllers[i], _playerNameControllers[i]),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _playerPhoneControllers.length >= 10 || _isSubmitting
                        ? null
                        : () {
                            setState(() {
                              _playerPhoneControllers.add(TextEditingController());
                              _playerNameControllers.add(TextEditingController());
                            });
                          },
                    icon: const Icon(Icons.add, color: darkBlue),
                    label: CustomText(
                      LocaleKeys.add_new_player.tr(),
                      color: darkBlue,
                      weight: FontWeight.bold,
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      side: const BorderSide(color: darkBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.share, color: darkBlue),
                    const SizedBox(width: 4),
                    CustomText(
                      LocaleKeys.invite_members_section.tr(),
                      color: darkBlue,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _inviteEnabled,
                  onChanged: _isSubmitting
                      ? null
                      : (val) => setState(() => _inviteEnabled = val),
                  contentPadding: EdgeInsets.zero,
                  title: CustomText(
                    LocaleKeys.enable_invite_title.tr(),
                    color: darkBlue,
                    weight: FontWeight.bold,
                  ),
                  subtitle: CustomText(
                    LocaleKeys.enable_invite_subtitle.tr(),
                    color: Colors.black54,
                  ),
                  activeColor: darkBlue,
                ),
                const SizedBox(height: 12),
                CustomText(
                  LocaleKeys.choose_social_platforms_label.tr(),
                  color: darkBlue,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildSocialChip(
                      'whatsapp',
                      FontAwesomeIcons.whatsapp,
                      LocaleKeys.social_whatsapp.tr(),
                    ),
                    _buildSocialChip(
                      'telegram',
                      FontAwesomeIcons.telegram,
                      LocaleKeys.social_telegram.tr(),
                    ),
                    _buildSocialChip(
                      'instagram',
                      FontAwesomeIcons.instagram,
                      LocaleKeys.social_instagram.tr(),
                    ),
                    _buildSocialChip(
                      'twitter',
                      FontAwesomeIcons.twitter,
                      LocaleKeys.social_twitter.tr(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: CustomText(
                      LocaleKeys.create_team_button.tr(),
                      color: Colors.white,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
