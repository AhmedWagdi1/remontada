import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/utils/utils.dart';
import '../../data/challenges_repository_impl.dart';
import '../../domain/request/create_match_request.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subscribersController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _durationController = TextEditingController();
  final _durationTextController = TextEditingController();
  final _detailsController = TextEditingController();
  final _amountController = TextEditingController();
  String? _type;

  @override
  void dispose() {
    _subscribersController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    _durationTextController.dispose();
    _detailsController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      initialDate: now,
    );
    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final request = CreateMatchRequest(
      playgroundId: '11',
      supervisorId: Utils.user.user?.id?.toString() ?? '',
      subscribersQty: _subscribersController.text,
      date: _dateController.text,
      startTime: _timeController.text,
      durations: _durationController.text,
      durationsText: _durationTextController.text,
      details: _detailsController.text,
      amount: _amountController.text,
      type: _type ?? '',
    );
    try {
      final repo = ChallengesRepositoryImpl();
      final res = await repo.createMatch(request);
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['status'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(LocaleKeys.create_match_success.tr()),
          ),
        );
        Navigator.pop(context);
      } else {
        _showError();
      }
    } catch (_) {
      _showError();
    }
  }

  void _showError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(LocaleKeys.create_match_error.tr()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.create_match_title.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _subscribersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.create_match_subscribers_qty.tr(),
                  ),
                  validator: Utils.valid.defaultValidation,
                ),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.create_match_date.tr(),
                  ),
                  onTap: _pickDate,
                  validator: Utils.valid.defaultValidation,
                ),
                TextFormField(
                  controller: _timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.create_match_time.tr(),
                  ),
                  onTap: _pickTime,
                  validator: Utils.valid.defaultValidation,
                ),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.create_match_durations.tr(),
                  ),
                  validator: Utils.valid.defaultValidation,
                ),
                TextFormField(
                  controller: _durationTextController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.create_match_durations_text.tr(),
                  ),
                  validator: Utils.valid.defaultValidation,
                ),
                TextFormField(
                  controller: _detailsController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.create_match_details.tr(),
                  ),
                  validator: Utils.valid.defaultValidation,
                ),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.create_match_amount.tr(),
                  ),
                  validator: Utils.valid.defaultValidation,
                ),
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.create_match_type.tr(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'challenge',
                      child: Text(LocaleKeys.create_match_challenge.tr()),
                    ),
                    DropdownMenuItem(
                      value: 'friendly',
                      child: Text(LocaleKeys.create_match_friendly.tr()),
                    ),
                  ],
                  onChanged: (val) => setState(() => _type = val),
                  validator: (val) =>
                      val == null ? LocaleKeys.valid_requiredField.tr() : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(LocaleKeys.create_match_submit.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
