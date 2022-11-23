import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';
import 'package:mobile_design_system/mobile_design_system.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_design_system/src/atoms/neumorphic/neumorphic_effect.dart';

/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;

  CountrySearchListWidget(
    this.countries,
    this.locale, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
  });

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late TextEditingController _searchController = TextEditingController();
  late List<Country> filteredCountries;
  FocusNode focusNode = FocusNode();
  InputStatus status = InputStatus.initial;

  @override
  void initState() {
    final String value = _searchController.text.trim();
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  void focusListener() {
    focusNode.addListener(() async {
      if (!focusNode.hasPrimaryFocus || !focusNode.hasFocus) {
        if (!focusNode.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus
              ?.unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);

          setState(() {
            status = InputStatus.unFocus;
          });
        }
      }
    });
  }

  void _onTapNormalInput() {
    setState(() {
      status = InputStatus.focus;
      focusNode = FocusNode();
      focusNode.requestFocus();
      focusListener();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        InputDecoration(labelText: 'Search by country name or dial code');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ForestSpacing.spaceX3,
            vertical: ForestSpacing.spaceY4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ForestText.textBodyM(label: 'Search country'),
              SizedBox(height: ForestSpacing.spaceX1),
              (status == InputStatus.focus)
                  ? NeumorphicEffect(
                      widget: ForestField(
                        key: widget.key,
                        controller: _searchController,
                        onChanged: (value) {
                          final String value = _searchController.text.trim();
                          return setState(
                            () => filteredCountries = Utils.filterCountries(
                              countries: widget.countries,
                              locale: widget.locale,
                              value: value,
                            ),
                          );
                        },
                        focusNode: focusNode,
                        filled: true,
                        textAlignVertical: TextAlignVertical.center,
                        prefixIcon: SizedBox(
                          child: Center(
                            widthFactor: 0.0,
                            child: FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: ForestColors.colorWood900,
                              size: 18,
                            ),
                          ),
                        ),
                        fillColor: ForestColors.colorWood0,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      borderColor: ForestColors.colorForest800,
                    )
                  : ForestField(
                      key: widget.key,
                      controller: _searchController,
                      onChanged: (value) {
                        final String value = _searchController.text.trim();
                        return setState(
                          () => filteredCountries = Utils.filterCountries(
                            countries: widget.countries,
                            locale: widget.locale,
                            value: value,
                          ),
                        );
                      },
                      hintText: 'United Kingdom',
                      readOnly: false,
                      onTap: _onTapNormalInput,
                      textAlignVertical: TextAlignVertical.center,
                      prefixIcon: SizedBox(
                        child: Center(
                          widthFactor: 0.0,
                          child: FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: ForestColors.colorWood900,
                            size: 18,
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide:
                            BorderSide(color: ForestColors.colorWood300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide:
                            BorderSide(color: ForestColors.colorWood300),
                      ),
                    ),
            ],
          ),
          /* TextFormField(
            key: Key(TestHelper.CountrySearchInputKeyValue),
            decoration: getSearchBoxDecoration(),
            controller: _searchController,
            autofocus: widget.autoFocus,
            onChanged: (value) {
              final String value = _searchController.text.trim();
              return setState(
                () => filteredCountries = Utils.filterCountries(
                  countries: widget.countries,
                  locale: widget.locale,
                  value: value,
                ),
              );
            },
          ),
          */
        ),
        if (filteredCountries.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ForestSpacing.spaceX3,
            ),
            child: Row(
              children: [
                Flexible(
                  child: ForestText.textBodyL(
                    label: 'Not results found for “${_searchController.text}”',
                  ),
                ),
              ],
            ),
          )
        ],
        Flexible(
          child: ListView.builder(
            controller: widget.scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: ForestSpacing.spaceX3),
            itemCount: filteredCountries.length,
            itemBuilder: (BuildContext context, int index) {
              Country country = filteredCountries[index];

              return DirectionalCountryListTile(
                country: country,
                locale: widget.locale,
                showFlags: widget.showFlags!,
                useEmoji: widget.useEmoji!,
              );
              // return ListTile(
              //   key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
              //   leading: widget.showFlags!
              //       ? _Flag(country: country, useEmoji: widget.useEmoji)
              //       : null,
              //   title: Align(
              //     alignment: AlignmentDirectional.centerStart,
              //     child: Text(
              //       '${Utils.getCountryName(country, widget.locale)}',
              //       textDirection: Directionality.of(context),
              //       textAlign: TextAlign.start,
              //     ),
              //   ),
              //   subtitle: Align(
              //     alignment: AlignmentDirectional.centerStart,
              //     child: Text(
              //       '${country.dialCode ?? ''}',
              //       textDirection: TextDirection.ltr,
              //       textAlign: TextAlign.start,
              //     ),
              //   ),
              //   onTap: () => Navigator.of(context).pop(country),
              // );
            },
          ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;

  const DirectionalCountryListTile({
    Key? key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(country),
      child: Container(
        color: Color(0xffF5F5F5),
        padding: const EdgeInsets.only(bottom: ForestSpacing.spaceY4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showFlags) _Flag(country: country, useEmoji: useEmoji),
            SizedBox(width: ForestSpacing.spaceX05),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: ForestText.textBodyL(
                      label: '${Utils.getCountryName(country, locale)}',
                      color: ForestColors.colorWood900,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: ForestSpacing.spaceX05),
            ForestText.textBodyL(
              label: '${country.dialCode ?? ''}',
              color: ForestColors.colorWood900,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );

    /* ListTile(
      key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
      leading: (showFlags ? _Flag(country: country, useEmoji: useEmoji) : null),
      title: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          '${Utils.getCountryName(country, locale)}',
          textDirection: Directionality.of(context),
          textAlign: TextAlign.start,
        ),
      ),
      subtitle: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          '${country.dialCode ?? ''}',
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.start,
        ),
      ),
      onTap: () => Navigator.of(context).pop(country),
    );
    */
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headline5,
                  )
                : country?.flagUri != null
                    ? CircleAvatar(
                        backgroundImage: AssetImage(
                          country!.flagUri,
                          package: 'intl_phone_number_input',
                        ),
                      )
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}
