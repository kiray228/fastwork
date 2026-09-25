import 'package:flutter/material.dart';

import 'data/session.dart';
import 'package:fastwork_core/data/support_repository.dart';
import 'package:fastwork_core/shift.dart';
import 'package:fastwork_core/support.dart';
import 'stories/story_actions.dart';
import 'theme/app_colors.dart';
import 'widgets/common.dart';
import 'widgets/skeleton.dart';

/// Документы исполнителя и их проверка.
class DocumentsPage extends StatefulWidget {
  final DocumentRepository repository;
  final AppSession session;

  const DocumentsPage({
    super.key,
    required this.repository,
    required this.session,
  });

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  List<UserDocument>? docs;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await widget.repository.documents();
    if (!mounted) return;
    setState(() => docs = loaded);
  }

  UserDocument? _byType(String type) {
    for (final d in docs ?? const <UserDocument>[]) {
      if (d.type == type) return d;
    }
    return null;
  }

  Future<void> _upload(String type) async {
    final input = await showDialog<_UploadInput>(
      context: context,
      builder: (context) => _UploadDialog(type: type),
    );
    if (input == null || !mounted) return;

    await widget.repository.upload(
      type: type,
      number: input.number,
      expiresAt: input.expiresAt,
    );
    await _load();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Документ отправлен на проверку')),
    );

    // Проверку документов в боевом приложении делает оператор платформы
    // из своего интерфейса. У нас его нет, поэтому эмулируем ответ —
    // чтобы было видно, как работает цепочка статусов.
    final doc = _byType(type);
    if (doc == null) return;

    await Future<void>.delayed(const Duration(seconds: 2));
    await widget.repository.review(doc.id, approved: true);
    await _load();
    if (!mounted) return;

    // Статус проверки влияет на профиль — обновляем пользователя.
    final user = widget.session.user;
    if (user != null && type == 'id_card') {
      widget.session.setUser(user.copyWith(isVerified: true));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Документ проверен и принят')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = docs;

    return Scaffold(
      appBar: AppBar(title: const Text('Документы')),
      body: list == null
          ? const TileListSkeleton(count: 2)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                const _Explainer(),
                Wrap(
                  children: [
                    HelpLink(
                      label: 'Как проходит проверка',
                      onTap: () => openHelpStory(context, 'documents'),
                    ),
                    HelpLink(
                      label: 'Кому нужна медкнижка',
                      onTap: () => openHelpStory(context, 'medbook'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                for (final entry in documentTypes.entries)
                  _DocumentCard(
                    title: entry.value,
                    document: _byType(entry.key),
                    onUpload: () => _upload(entry.key),
                  ),
              ],
            ),
    );
  }
}

class _Explainer extends StatelessWidget {
  const _Explainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.brand.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_outlined,
              size: 18, color: AppColors.brand),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Проверенные документы открывают доступ к большему числу '
              'заказчиков. Санитарная книжка нужна для работы с продуктами.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12.5, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final String title;
  final UserDocument? document;
  final VoidCallback onUpload;

  const _DocumentCard({
    required this.title,
    required this.document,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    final doc = document;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 15),
                  ),
                ),
                if (doc == null)
                  const TagChip(text: 'Не загружен')
                else if (doc.isPending)
                  const TagChip(
                    text: 'На проверке',
                    icon: Icons.hourglass_top_rounded,
                    color: AppColors.accent,
                  )
                else if (doc.isApproved)
                  const TagChip(
                    text: 'Принят',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.brand,
                  )
                else
                  const TagChip(
                    text: 'Отклонён',
                    icon: Icons.close_rounded,
                    color: AppColors.accent,
                  ),
              ],
            ),
            if (doc != null) ...[
              const SizedBox(height: 10),
              Text(
                'Номер: ${doc.number}',
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              if (doc.expiresAt != null) ...[
                const SizedBox(height: 4),
                _Expiry(document: doc, now: DateTime.now()),
              ],
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: doc?.isPending == true ? null : onUpload,
                icon: const Icon(Icons.upload_file_rounded, size: 18),
                label: Text(doc == null ? 'Загрузить' : 'Загрузить заново'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(46),
                  foregroundColor: AppColors.brand,
                  side: const BorderSide(color: AppColors.brand),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Что ввели в окне загрузки.
class _UploadInput {
  final String number;
  final DateTime? expiresAt;

  const _UploadInput(this.number, this.expiresAt);
}

/// Окно загрузки: номер документа и, если у документа есть срок, дата.
///
/// Дату у медкнижки спрашиваем обязательно: без неё не напомнить, что
/// пора на медосмотр, а заказчик не пустит на смену с просроченной.
class _UploadDialog extends StatefulWidget {
  final String type;

  const _UploadDialog({required this.type});

  @override
  State<_UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<_UploadDialog> {
  final controller = TextEditingController();
  DateTime? expiresAt;
  String? error;

  bool get needsDate => documentsWithExpiry.contains(widget.type);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      helpText: 'Действует до',
      initialDate: expiresAt ?? DateTime(now.year + 1, now.month, now.day),
      firstDate: now,
      lastDate: DateTime(now.year + 5, now.month, now.day),
    );
    if (picked != null) setState(() => expiresAt = picked);
  }

  void _submit() {
    final number = controller.text.trim();
    if (number.isEmpty) {
      setState(() => error = 'Введите номер документа');
      return;
    }
    if (needsDate && expiresAt == null) {
      setState(() => error = 'Укажите, до какого числа действует медосмотр');
      return;
    }
    Navigator.of(context).pop(_UploadInput(number, expiresAt));
  }

  @override
  Widget build(BuildContext context) {
    final until = expiresAt;

    return AlertDialog(
      title: Text(documentTypes[widget.type] ?? 'Документ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Загрузка файлов пока не подключена — введите номер документа, '
            'этого достаточно для учебной версии.',
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Номер документа',
              border: OutlineInputBorder(),
            ),
          ),
          if (needsDate) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event_rounded, size: 18),
              label: Text(
                until == null
                    ? 'Действует до…'
                    : 'Действует до ${formatDate(until)}',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                foregroundColor: AppColors.brand,
              ),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 10),
            Text(
              error!,
              style: const TextStyle(fontSize: 13, color: AppColors.danger),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        TextButton(onPressed: _submit, child: const Text('Отправить')),
      ],
    );
  }
}

/// Строка про срок: «действует до», «скоро истекает», «просрочена».
class _Expiry extends StatelessWidget {
  final UserDocument document;
  final DateTime now;

  const _Expiry({required this.document, required this.now});

  @override
  Widget build(BuildContext context) {
    final until = formatDate(document.expiresAt!);
    final left = document.daysLeftAt(now) ?? 0;

    final (text, color, icon) = document.isExpiredAt(now)
        ? (
            'Срок вышел $until — пройдите медосмотр и загрузите заново',
            AppColors.danger,
            Icons.error_outline_rounded,
          )
        : document.expiresSoonAt(now)
            ? (
                left == 0
                    ? 'Действует до сегодня — пора на медосмотр'
                    : 'Действует до $until — осталось ${daysLabel(left)}',
                AppColors.warning,
                Icons.schedule_rounded,
              )
            : (
                'Действует до $until',
                AppColors.muted,
                Icons.event_available_rounded,
              );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight:
                  color == AppColors.muted ? FontWeight.w500 : FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
