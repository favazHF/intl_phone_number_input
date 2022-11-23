import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:mobile_design_system/mobile_design_system.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// [Item]
class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final bool trailingSpace;

  const Item({
    Key? key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
    this.leadingPadding = 12,
    this.trailingSpace = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "   ");
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: ForestSpacing.spaceX2),
          _Flag(
            country: country,
            showFlag: showFlag,
            useEmoji: useEmoji,
          ),
          SizedBox(width: ForestSpacing.spaceX1),
          ForestText.textBodyM(
            label: '$dialCode',
            color: ForestColors.colorWood900,
          ),
          SizedBox(width: ForestSpacing.spaceX1),
          FaIcon(
            FontAwesomeIcons.chevronDown,
            color: ForestColors.colorWood900,
            size: 10,
          ),
          SizedBox(width: ForestSpacing.spaceX1),
          Container(
            width: 1,
            height: 24,
            color: ForestColors.colorWood300,
          ),
          // Text(
          //   '$dialCode',
          //   textDirection: TextDirection.ltr,
          //   style: textStyle,
          // ),
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.showFlag, this.useEmoji})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag!
        ? Container(
            child: useEmoji!
                ? ForestText.textBodyL(
                    label: Utils.generateFlagEmojiUnicode(
                        country?.alpha2Code ?? ''),
                  )

                // Text(
                //     Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                //     style: Theme.of(context).textTheme.headline5,
                //   )
                : Image.asset(
                    country!.flagUri,
                    width: 32.0,
                    package: 'intl_phone_number_input',
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox.shrink();
                    },
                  ),
          )
        : SizedBox.shrink();
  }
}
