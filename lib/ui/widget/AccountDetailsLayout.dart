import 'package:flutter/material.dart';
const double _kAccountDetailsHeight = 56.0;
class AccountDetailsLayout extends MultiChildLayoutDelegate {

  AccountDetailsLayout({ @required this.textDirection });

  static const String accountName = 'accountName';
  static const String accountEmail = 'accountEmail';
  static const String dropdownIcon = 'dropdownIcon';
  static const String ratingBar = 'ratingBar';

  final TextDirection textDirection;

  @override
  void performLayout(Size size) {

    Size iconSize;
    if (hasChild(dropdownIcon)) {
      // place the dropdown icon in bottom right (LTR) or bottom left (RTL)
      iconSize = layoutChild(dropdownIcon, BoxConstraints.loose(size));
      positionChild(dropdownIcon, _offsetForIcon(size, iconSize));
    }

    final String bottomLine =
    hasChild(ratingBar) ? ratingBar :
    hasChild(accountEmail) ? accountEmail :
    (hasChild(accountName) ? accountName : null);

    if (bottomLine != null) {
      final Size constraintSize = iconSize == null ? size : size - Offset(iconSize.width, 0.0);
      iconSize ??= const Size(_kAccountDetailsHeight, _kAccountDetailsHeight);

      // place bottom line center at same height as icon center
      final Size bottomLineSize = layoutChild(bottomLine, BoxConstraints.loose(constraintSize));
      final Offset bottomLineOffset = _offsetForBottomLine(size, iconSize, bottomLineSize);
      positionChild(bottomLine, bottomLineOffset);

      if (bottomLine == ratingBar && hasChild(accountEmail)){
        final Size nameSize = layoutChild(accountEmail, BoxConstraints.loose(constraintSize));
        positionChild(accountEmail, _offsetForName(size, nameSize, bottomLineOffset));

        Size nameSize2 = layoutChild(accountName, BoxConstraints.loose(constraintSize));
        Size s  = new Size( nameSize.width, nameSize.height*2);
        //print("Size2: ${nameSize2.toString()} ");
        positionChild(accountName, _offsetForName(size, s, bottomLineOffset));

      }
      // place account name above account email
      else if(bottomLine == accountEmail && hasChild(accountName)) {
        final Size nameSize = layoutChild(accountName, BoxConstraints.loose(constraintSize));
        positionChild(accountName, _offsetForName(size, nameSize, (bottomLineOffset  ) ));
      }


    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => true;

  Offset _offsetForIcon(Size size, Size iconSize) {
    switch (textDirection) {
      case TextDirection.ltr:
        return Offset(size.width - iconSize.width, size.height - iconSize.height);
      case TextDirection.rtl:
        return Offset(0.0, size.height - iconSize.height);
    }
    assert(false, 'Unreachable');
    return null;
  }

  Offset _offsetForBottomLine(Size size, Size iconSize, Size bottomLineSize) {
    final double y = size.height - 0.5 * iconSize.height - 0.5 * bottomLineSize.height;
    switch (textDirection) {
      case TextDirection.ltr:
        return Offset(0.0, y);
      case TextDirection.rtl:
        return Offset(size.width - bottomLineSize.width, y);
    }
    assert(false, 'Unreachable');
    return null;
  }

  Offset _offsetForName(Size size, Size nameSize, Offset bottomLineOffset) {
    final double y = bottomLineOffset.dy - nameSize.height;
    switch (textDirection) {
      case TextDirection.ltr:
        return Offset(0.0, y);
      case TextDirection.rtl:
        return Offset(size.width - nameSize.width, y);
    }
    assert(false, 'Unreachable');
    return null;
  }
}

class AccountDetails extends StatelessWidget {
  const AccountDetails({
    Key key,
    @required this.accountName,
    @required this.accountEmail,
    @required this.ratingBar,
    this.onTap,
    this.isOpen,
  }) : super(key: key);

  final Widget accountName;
  final Widget accountEmail;
  final Widget ratingBar;
  final VoidCallback onTap;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final ThemeData theme = Theme.of(context);
    final List<Widget> children = <Widget>[];

    if (accountName != null) {
      final Widget accountNameLine = LayoutId(
        id: AccountDetailsLayout.accountName,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: DefaultTextStyle(
            style: theme.primaryTextTheme.body2,
            overflow: TextOverflow.ellipsis,
            child: accountName,
          ),
        ),
      );
      children.add(accountNameLine);
    }

    if (accountEmail != null) {
      final Widget accountEmailLine = LayoutId(
        id: AccountDetailsLayout.accountEmail,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: DefaultTextStyle(
            style: theme.primaryTextTheme.body1,
            overflow: TextOverflow.ellipsis,
            child: accountEmail,
          ),
        ),
      );
      children.add(accountEmailLine);
    }

    if (ratingBar != null) {
      final Widget ratingBarLine = LayoutId(
        id: AccountDetailsLayout.ratingBar,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: DefaultTextStyle(
            style: theme.primaryTextTheme.body1,
            overflow: TextOverflow.ellipsis,
            child: ratingBar,
          ),
        ),
      );
      children.add(ratingBarLine);
    }

    if (onTap != null) {
      final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      final Widget dropDownIcon = LayoutId(
        id: AccountDetailsLayout.dropdownIcon,
        child: Semantics(
          container: true,
          button: true,
          onTap: onTap,
          child: SizedBox(
            height: _kAccountDetailsHeight,
            width: _kAccountDetailsHeight,
            child: Center(
              child: Icon(
                isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.black87,
                semanticLabel: isOpen
                    ? localizations.hideAccountsLabel
                    : localizations.showAccountsLabel,
              ),
            ),
          ),
        ),
      );
      children.add(dropDownIcon);
    }

    Widget accountDetails = CustomMultiChildLayout(
      delegate: AccountDetailsLayout(
        textDirection: Directionality.of(context),
      ),
      children: children,
    );

    if (onTap != null) {
      accountDetails = InkWell(
        onTap: onTap,
        child: accountDetails,
        excludeFromSemantics: true,
      );
    }

    return SizedBox(
      height: _kAccountDetailsHeight,
      child: accountDetails,
    );
  }
}