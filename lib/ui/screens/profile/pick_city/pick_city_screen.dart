import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../bloc/pick_city/index.dart';
import '../../../reusable/loading_indicator.dart';
import '../../../reusable/search_bar.dart';
import '../../../reusable/show_dialog_mixin.dart';

class PickCityScreen extends StatelessWidget with ShowDialogMixin {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocListener<PickCityBloc, PickCityState>(
      listenWhen: (prev, curr) => prev.selectedCity != curr.selectedCity,
      listener: (context, state) =>
          Navigator.of(context).pop(state.selectedCity),
      child: BlocConsumer<PickCityBloc, PickCityState>(
        listenWhen: (prev, curr) =>
            !prev.detectedCityNotAllowed &&
            curr.detectedCityNotAllowed &&
            curr.detectedCity != null,
        listener: (context, state) => showSimpleDialog(
          context: context,
          message: localizations.yourCityIsNotAllowedYet(state.detectedCity!),
        ),
        builder: (context, state) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: theme.colorScheme.primary,
                    height: 52,
                  ),
                ),
                Positioned(
                  top: 144,
                  left: 0,
                  right: 0,
                  child: Visibility(
                    visible: state.loading,
                    child: Center(
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: LoadingIndicator(),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Image.asset('assets/logo_transparent.png'),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      SearchBar(
                        onTextChanged: (text) =>
                            _onSearchTextChanged(context, text),
                        onBackArrowPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).maybePop();
                        },
                      ),
                      Expanded(
                        child: _ScrollView(
                          cities: state.citiesToShow,
                          selectedCity: state.selectedCity,
                          detectingCity: state.detectingCity,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSearchTextChanged(BuildContext context, String text) {
    final bloc = BlocProvider.of<PickCityBloc>(context);
    final event = SearchQueryChanged(text);
    bloc.add(event);
  }
}

class _ScrollView extends StatefulWidget {
  final List<String> cities;
  final String selectedCity;
  final bool detectingCity;

  _ScrollView({
    Key? key,
    required this.cities,
    required this.selectedCity,
    required this.detectingCity,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScrollViewState();
}

class _ScrollViewState extends State<_ScrollView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scrollbar(
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 8),
        itemCount: widget.cities.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            if (widget.detectingCity) {
              return Container(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                alignment: Alignment.center,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: LoadingIndicator(),
                ),
              );
            } else {
              return TextButton(
                onPressed: _getCityFromLocationServices,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.useCurrentLocation,
                      style: theme.textTheme.subtitle2
                          ?.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.location_on,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ],
                ),
              );
            }
          } else {
            final city = widget.cities[index - 1];
            return RadioListTile(
              value: city,
              groupValue: widget.selectedCity,
              title: Text(city),
              onChanged: _selectCity,
            );
          }
        },
      ),
    );
  }

  void _selectCity(String? city) {
    if (city != null) {
      final event = SelectCity(city);
      BlocProvider.of<PickCityBloc>(context).add(event);
    }
  }

  Future<void> _getCityFromLocationServices() async {
    final event = GetLocationFromServices();
    BlocProvider.of<PickCityBloc>(context).add(event);
  }
}
