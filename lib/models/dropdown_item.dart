

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DropdownItem {
  String id;
  String displayText;
  String value;

  DropdownItem({
    required this.id,
    required this.displayText,
    required this.value,
  });

  @override
  String toString() =>
      'DropdownItem(id: $id, displayText: $displayText, value: $value)';

  factory DropdownItem.empty() =>
      DropdownItem(id: "", displayText: "", value: "");
}
