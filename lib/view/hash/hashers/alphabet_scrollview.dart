import 'package:azlistview/azlistview.dart';
import 'package:create_hash_ui/models/hasher_model.dart';
import 'package:create_hash_ui/providers/hasher_provider.dart';
import 'package:create_hash_ui/repository/hasher_repository.dart';
import 'package:create_hash_ui/view/hash/hashers/create_hasher.dart';
import 'package:create_hash_ui/view/hash/hashers/hasherDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'list_of_hashers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;

  _AZItem({
    required this.title,
    required this.tag,
  });

  @override
  String getSuspensionTag() => tag;
}

class AlphabetScrollPage extends StatefulWidget {
  final List<String>? items;
  final List<Hasher>? hashersList;
  final VoidCallback? reloadFunction;

  const AlphabetScrollPage({
    Key? key,
    @required this.items,
    @required this.hashersList,
    @required this.reloadFunction,
  }) : super(key: key);

  @override
  State<AlphabetScrollPage> createState() => _AlphabetScrollPageState();
}

enum ConfirmAction { Cancel, Delete }

class _AlphabetScrollPageState extends State<AlphabetScrollPage> {
  List<_AZItem>? _items = [];
  List<Hasher>? _hashersList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initList(widget.items!);
  }

  load(bool val) {
    if (mounted) {
      setState(() {
        _isLoading = val;
      });
    }
  }

  _initList(List<String> items) {
    this._items = items
        .map((item) => _AZItem(title: item, tag: item[0].toUpperCase()))
        .toList();
    _hashersList = widget.hashersList;
    _hashersList!.sort(((a, b) => a.firstName!.compareTo(b.firstName!)));
  }

  Future<dynamic> deleteHasher(int id) async {
    HasherRepository hr = HasherRepository();
    var result = await hr.deleteHasher(id);

    //remove from provider list as well.
    Provider.of<HasherProvider>(context, listen: false).removeHasher(id);
    return result['success'];
  }

  Future<ConfirmAction?> _asyncConfirmDialog(
      BuildContext context, int id) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete This Hasher?'),
          content: const Text('This will permanently delete a hasher.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                var result = await deleteHasher(id);
                if (result == true) {
                  final snackBar = SnackBar(
                    content: Text(
                      "Deleted Successfully",
                      style: TextStyle(color: Colors.green),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pop(context);
                  // Navigator.pop(context);
                  widget.reloadFunction!();
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => AzListView(
        padding: const EdgeInsets.all(16),
        data: _items!,
        itemCount: _items!.length,
        itemBuilder: (context, index) {
          final item = _items![index];
          final hasher = widget.hashersList![index];
          return _buildListItem(item, hasher);
        },
      );

  Widget _buildListItem(item, Hasher hasher) {
    return InkWell(
      onTap: (() {
        // _getHasherDetailAlert(item, hasher);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => HashersDetail(
                  hasher: hasher,
                )),
          ),
        );
      }),
      child: ListTile(
        leading: CircleAvatar(
          radius: 13,
          backgroundColor: Colors.grey.withOpacity(0.3),
          child: Text(
            item.tag,
            style: const TextStyle(color: Color(0XFF006B60), fontSize: 14),
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(fontSize: 14),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                  ),
                  new GestureDetector(
                    child: Text('Edit'),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => CreateHasher(
                                hasher: hasher,
                              )),
                        ),
                      );
                      if (result == true) {
                        Navigator.pop(context);
                        widget.reloadFunction!();
                      }
                    },
                  )
                ],
              ),
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  const Icon(
                    Icons.delete,
                  ),
                  GestureDetector(
                    child: Text('Delete'),
                    onTap: () async {
                      final action =
                          await _asyncConfirmDialog(context, hasher.id!);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
