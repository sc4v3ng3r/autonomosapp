import 'package:autonomosapp/model/User.dart';
import 'package:autonomosapp/ui/widget/UserViewItemWidget.dart';
import 'package:flutter/material.dart';

class UsersViewWidget extends StatefulWidget {
  final List<User> _userList;
  final Function _onClickCallback;
  final String _testParam;

  UsersViewWidget({@required List<User> userList, Function onClick(User user), String testParam}) :
      _onClickCallback = onClick,
      _testParam = testParam,
      _userList = userList;
  @override
  _UsersViewWidgetState createState() => _UsersViewWidgetState();
}

class _UsersViewWidgetState extends State<UsersViewWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          shrinkWrap: true,
          itemCount: widget._userList.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              child: UserViewItemWidget(
                  user: widget._userList[index],
                  view: null,
              ),
              elevation: 2.0,
            );
          }
    );
  }

  @override
  void dispose() {
    print("UsersViewWidget dispose()");
    super.dispose();
  }
}
