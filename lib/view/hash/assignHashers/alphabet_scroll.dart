import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';

import '../../../models/hasher_model.dart';

// Define callback
typedef intArrayCallback(List<int> hl);

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;
  final int hasherId;

  _AZItem({required this.title, required this.tag, this.hasherId = 0});

  @override
  String getSuspensionTag() => tag;
}

class AlphabetScroll extends StatefulWidget {
  final intArrayCallback onHashListChanged;
  final List<Hasher>? hashers;

  const AlphabetScroll(
      {Key? key,
      // @required this.items,
      required this.hashers,
      required this.onHashListChanged})
      : super(key: key);

  @override
  State<AlphabetScroll> createState() => _AlphabetScrollState();
}

class _AlphabetScrollState extends State<AlphabetScroll> {
  // bool isChecked = false;
  // List<_AZItem>? _items = [];
  List<_AZItem>? _hashers = [];
  List<bool>? checkedList = [];
  List<int>? selectedHasher = [];

  List<int>? get getSelectedHasher => selectedHasher;

  @override
  void initState() {
    super.initState();
    _initList(widget.hashers!);
  }

  _initList(List<Hasher> hashers) {
    // _items = items
    //     .map((item) =>
    //         _AZItem(title: item, tag: item[0].toUpperCase(), hasherId: 555))
    //     .toList();

    _hashers = hashers
        .map((hasher) => _AZItem(
              title: hasher.firstName! + ' ' + hasher.lastName!,
              tag: hasher.firstName![0].toUpperCase(),
              hasherId: hasher.id!,
            ))
        .toList();
    _hashers?.sort((a, b) => a.title.compareTo(b.title));

    // checkedList = List.filled(_items!.length, false);
    checkedList = List.filled(_hashers!.length, false);
  }

  @override
  Widget build(BuildContext context) => AzListView(
        padding: const EdgeInsets.all(16),
        // data: _items!,
        // itemCount: _items!.length,
        data: _hashers!,
        itemCount: _hashers!.length,
        itemBuilder: (context, index) {
          // final item = _items![index];
          final item = _hashers![index];
          return _buildListItem(item, index);
        },
      );

  Widget _buildListItem(item, index) {
    return InkWell(
      onTap: (() {
        setState(() {
          bool value = checkedList![index];
          checkedList![index] = !value;
        });
        var clkHasher = _hashers![index].hasherId;
        if (selectedHasher?.contains(clkHasher) ?? false) {
          // debugPrint('array contains selected hasher');
          selectedHasher?.remove(clkHasher);
        } else {
          // debugPrint('array does not contain selected hasher');
          selectedHasher?.add(clkHasher);
        }

        widget.onHashListChanged(selectedHasher ?? []);
        // debugPrint(selectedHasher.toString());
      }),
      child: ListTile(
        leading: CircleAvatar(
          radius: 13,
          backgroundColor: checkedList![index] == true
              ? const Color(0XFF006B60)
              : Colors.grey.withOpacity(0.3),
          child: checkedList![index] == true
              ? const Icon(
                  Icons.check_outlined,
                  size: 18,
                )
              : Text(
                  item.tag,
                  style:
                      const TextStyle(color: Color(0XFF006B60), fontSize: 14),
                ),
        ),
        title: Text(
          item.title,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
