import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/report_block_bloc.dart';

class ReportSheet extends StatefulWidget {
  final String targetType;
  final String targetId;
  const ReportSheet({super.key, required this.targetType, required this.targetId});

  static Future<void> show(BuildContext context, {required String targetType, required String targetId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReportSheet(targetType: targetType, targetId: targetId),
    );
  }

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  String _reason = 'spam';
  final _desc = TextEditingController();

  final _reasons = const {
    'spam': 'محتوى مزعج / دعائي',
    'harassment': 'تحرش / تنمّر',
    'hate': 'خطاب كراهية',
    'violence': 'عنف',
    'nudity': 'محتوى غير لائق',
    'false_info': 'معلومات مغلوطة',
    'other': 'أخرى',
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportBlockBloc>(),
      child: BlocConsumer<ReportBlockBloc, ReportBlockState>(
        listener: (context, state) {
          if (state is ReportSuccessState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إرسال البلاغ، شكرًا لك')),
            );
          } else if (state is ReportBlockError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final loading = state is ReportBlockLoading;
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('إبلاغ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ..._reasons.entries.map(
                    (e) => RadioListTile<String>(
                      value: e.key,
                      groupValue: _reason,
                      onChanged: loading ? null : (v) => setState(() => _reason = v!),
                      title: Text(e.value),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  TextField(
                    controller: _desc,
                    maxLines: 3,
                    enabled: !loading,
                    decoration: const InputDecoration(hintText: 'تفاصيل إضافية (اختياري)'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            context.read<ReportBlockBloc>().add(SubmitReportEvent(
                                  targetType: widget.targetType,
                                  targetId: widget.targetId,
                                  reason: _reason,
                                  description: _desc.text.trim(),
                                ));
                          },
                    child: loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('إرسال البلاغ'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
