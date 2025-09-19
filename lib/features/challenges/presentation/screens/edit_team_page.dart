import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/key.dart';
import '../../../../core/services/media/my_media.dart';
import '../../../../core/services/media/alert_of_media.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/network_image.dart';
import '../../../auth/domain/model/auth_model.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../../core/utils/Locator.dart';

class EditTeamPage extends StatefulWidget {
  final Map<String, dynamic> teamData;

  const EditTeamPage({super.key, required this.teamData});

  @override
  State<EditTeamPage> createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  File? _logo;
  bool _isSubmitting = false;

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  int? _selectedAreaId;
  List<Location> _areas = [];

  @override
  void initState() {
    super.initState();
    _loadTeamData();
    _loadAreas();
  }

  void _loadTeamData() {
    _teamNameController.text = widget.teamData['name'] ?? '';
    _bioController.text = widget.teamData['bio'] ?? '';
    _selectedAreaId = widget.teamData['area_id'] as int?;
  }

  Future<void> _loadAreas() async {
    try {
      final response = await locator<AuthRepository>().getArreasRequest();
      if (response?.areas != null) {
        setState(() {
          _areas = response!.areas!;
        });
      }
    } catch (e) {
      print('Error loading areas: $e');
    }
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    if (_teamNameController.text.trim().isEmpty) {
      _showError('يرجى إدخال اسم الفريق');
      return;
    }

    if (_bioController.text.trim().isEmpty) {
      _showError('يرجى إدخال وصف الفريق');
      return;
    }

    if (_selectedAreaId == null) {
      _showError('يرجى اختيار المنطقة');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Debug: print all field values
      print('--- EditTeamPage: Submitting team update ---');
      print('Team ID: ${widget.teamData['id']}');
      print('Name: ${_teamNameController.text.trim()}');
      print('Bio: ${_bioController.text.trim()}');
      print('Area ID: $_selectedAreaId');
      print('Logo file: ${_logo?.path ?? 'none'}');
      print('Token: ${Utils.token}');

      final url = '${ConstKeys.baseUrl}/team/${widget.teamData['id']}';
      print('Request Method: POST');
      print('Request URL: $url');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      )
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer ${Utils.token}'
        ..fields['name'] = _teamNameController.text.trim()
        ..fields['bio'] = _bioController.text.trim()
        ..fields['area_id'] = _selectedAreaId.toString();

      print('Request Headers: ${request.headers}');
      print('Request Fields: ${request.fields}');

      if (_logo != null) {
        print('Attaching logo file: ${_logo!.path}');
        request.files.add(
          await http.MultipartFile.fromPath('logo', _logo!.path),
        );
      }
      print('Request Files: ${request.files.map((f) => f.filename).toList()}');

      final streamed = await request.send();
      print('Response Status Code: ${streamed.statusCode}');
      print('Response Headers: ${streamed.headers}');

      final response = await http.Response.fromStream(streamed);
      print('Raw Response Body: ${response.body}');

      final data = jsonDecode(response.body);
      print('Decoded Response: $data');

      if (response.statusCode < 400 && data['status'] == true) {
        print('Team update successful. Message: ${data['message']}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'تم تحديث الفريق بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      } else {
        print('Team update failed. Message: ${data['message']}');
        _showError(data['message'] ?? 'حدث خطأ أثناء التحديث');
      }
    } catch (e, stack) {
      print('Exception during team update: $e');
      print('Stacktrace: $stack');
      _showError('حدث خطأ غير متوقع: $e');
    } finally {
      print('--- EditTeamPage: Team update finished ---');
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _showError(String message) async {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('خطأ'),
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

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    final currentLogoUrl = widget.teamData['logo_url'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الفريق'),
        centerTitle: true,
      ),
      body: AbsorbPointer(
        absorbing: _isSubmitting,
        child: Opacity(
          opacity: _isSubmitting ? 0.6 : 1.0,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Section
                  CustomText(
                    'شعار الفريق',
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
                              : currentLogoUrl != null && currentLogoUrl.isNotEmpty
                                  ? ClipOval(
                                      child: NetworkImagesWidgets(
                                        currentLogoUrl,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      ),
                                    )
                                  : const Icon(Icons.add_a_photo, color: darkBlue),
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          'إضافة صورة (الكاميرا/المعرض)',
                          color: darkBlue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Team Info Section
                  CustomText(
                    'معلومات الفريق',
                    color: darkBlue,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _teamNameController,
                    enabled: !_isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'اسم الفريق',
                      hintText: 'أدخل اسم الفريق',
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
                      labelText: 'وصف الفريق',
                      hintText: 'أدخل وصف مختصر للفريق',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Area Selection
                  CustomText(
                    'المنطقة',
                    color: darkBlue,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedAreaId,
                    onChanged: _isSubmitting ? null : (value) {
                      setState(() {
                        _selectedAreaId = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'اختر المنطقة',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _areas.map((area) {
                      return DropdownMenuItem<int>(
                        value: area.id,
                        child: Text(area.name ?? 'غير محدد'),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'حفظ التغييرات',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}