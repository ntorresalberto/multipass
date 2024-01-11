import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'vm_table_headers.dart';

class LastingPopupMenuItem extends PopupMenuItem<String> {
  const LastingPopupMenuItem({super.key, required super.child})
      : super(padding: EdgeInsets.zero);

  @override
  PopupMenuItemState<String, LastingPopupMenuItem> createState() =>
      _LastingPopupMenuItemState();
}

class _LastingPopupMenuItemState
    extends PopupMenuItemState<String, LastingPopupMenuItem> {
  @override
  void handleTap() {}
}

final enabledHeadersProvider = StateProvider(
  (_) => {for (final h in headers) h.name: true}.build(),
);

class HeaderSelectionTile extends ConsumerWidget {
  final String name;

  const HeaderSelectionTile(this.name, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledHeaders = ref.watch(enabledHeadersProvider);

    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(name),
      value: enabledHeaders[name],
      onChanged: (isSelected) {
        ref.read(enabledHeadersProvider.notifier).update(
          (state) {
            final builder = state.toBuilder();
            builder[name] = isSelected!;
            return builder.build();
          },
        );
      },
    );
  }
}

class HeaderSelection extends StatelessWidget {
  const HeaderSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      itemBuilder: (_) => headers
          .skip(2)
          .map((h) => LastingPopupMenuItem(child: HeaderSelectionTile(h.name)))
          .toList(),
      child: Container(
        width: 120,
        height: 42,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              'assets/settings.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xff333333),
                BlendMode.srcIn,
              ),
            ),
            const Text(
              'Columns',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
