import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class MultiSelectTagsDropDown extends StatelessWidget {
  const MultiSelectTagsDropDown({
    super.key,
    required MultiSelectController multiDropdownController,
  }) : _multiDropdownController = multiDropdownController;

  final MultiSelectController _multiDropdownController;

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown(
      controller: _multiDropdownController,
      onOptionSelected: (List<ValueItem> selectedOptions) {},
      options: const [],
      selectionType: SelectionType.multi,
      chipConfig: const ChipConfig(wrapType: WrapType.scroll),
      dropdownHeight: 200,
      optionTextStyle: const TextStyle(fontSize: 16),
      selectedOptionIcon: const Icon(Icons.check_circle),
      inputDecoration:
          const BoxDecoration(border: Border(bottom: BorderSide(width: .7))),
      selectedOptionTextColor: Theme.of(context).colorScheme.primary,
    );
  }
}
