import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:plant_flutter/model/auth/CountryResponse.dart';
import 'package:plant_flutter/network/RestApi.dart';
import 'package:plant_flutter/utils/common.dart';

import '../../main.dart';

class CountryDropdown extends StatefulWidget {
  final Function(String? country) onConChanged;
  final Function(String? country) onStateChanged;
  final String? country;
  final String? state;

  CountryDropdown({required this.onConChanged, required this.onStateChanged, this.state, this.country});

  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  List<CountryResponse> countryList = [];
  List<CountryState> stateList = [];
  bool isFirst = true;
  CountryResponse? selectedCountry;
  CountryState? selectedState;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
     getCountry();
  }

  Future<void> getCountry() async {
    await authApi.getCountries().then((value) async {
      countryList.clear();
      countryList.addAll(value);
      setState(() {});
      appStore.setLoading(false);
      value.forEach((e) {
        if (e.code == widget.country) {
          selectedCountry = e;
        }
      });
      getData();
    }).catchError((e) {
      toast('$e', print: true);
      appStore.setLoading(false);
    });
  }

  getState() {
    stateList.clear();
    stateList.addAll(selectedCountry!.states!);
    setState(() {});
    stateList.forEach((e) {
      selectedState = e;
    });
  }

  getData() {
    print("widget.country!"+widget.country!);
    if (widget.country!.isNotEmpty) {
      countryList.forEach((element) {
          if (element.name == widget.country!) {
            selectedCountry = element;
          }
        });
      // selectedCountry = countryList.firstWhere((element) => element.code == widget.country);
    }
    if (widget.state!.isNotEmpty) {
      stateList.forEach((element) {
        if (element.name == widget.state!) {
          selectedState = element;
        }
      });
      // selectedState = stateList.firstWhere((element) => element.name == widget.state);
    }
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButtonFormField<CountryResponse>(
          decoration: inputDecoration(context, label: ""),
          //hint: Text('Country', style: secondaryTextStyle()),
          isExpanded: true,
          value: selectedCountry,
          items: countryList.map((CountryResponse e) {
            return DropdownMenuItem<CountryResponse>(
              value: e,
              child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (c) {
            hideKeyboard(context);
            selectedCountry = c!;
            if (selectedCountry != null) {
              widget.onConChanged.call(selectedCountry!.name);
              log(selectedCountry);
            }
            // selectedCountry = c;
            // widget.onChanged.call(selectedCountry!.name, selectedCountry!.name);
            getState();
            setState(() {});
          },
        ).expand(),
        16.width,
        DropdownButtonFormField<CountryState>(
          decoration: inputDecoration(context, label: ""),
        //  hint: Text('State', style: secondaryTextStyle()),
          value: selectedState,
          isExpanded: true,
          items: selectedState == null
              ? []
              : stateList.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value.name != null && value.name.toString().isNotEmpty ? value.name : "NA",
                        style: primaryTextStyle(),
                      ),
                    );
                  },
                ).toList(),
          onChanged: (c) {
            selectedState = c!;
            widget.onStateChanged.call(selectedState!.name);
            setState(() {});
            log(selectedState!.name);
          },
        ).expand(),
      ],
    );
    /*   FutureBuilder<List<CountryResponse>>(
      future: _asyncMemoizer.runOnce(() => authApi.getCountries()),
      builder: (context, snap) {
        if (snap.hasData) {
          if (isFirst) {
            if (widget.country!.isNotEmpty) {}
            if (widget.state!.isNotEmpty && selectedCountryResponse != null && selectedCountryState == null) {
              selectedCountryState = selectedCountryResponse!.states!.firstWhere((element) => element.code == widget.state);
              widget.onChanged.call(selectedCountryResponse!.name, selectedCountryState!.name);
            }
            isFirst = false;
          }

          return Row(
            children: [
              DropdownButtonFormField<CountryResponse>(
                decoration: inputDecoration(context, label: ""),
                hint: Text('Country', style: secondaryTextStyle()),
                isExpanded: true,
                value: selectedCountryResponse,
                items: selectedCountryResponse == null
                    ? []
                    : snap.data!.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value.name != null && value.name.toString().isNotEmpty ? value.name : "NA",
                              style: primaryTextStyle(),
                            ),
                          );
                        },
                      ).toList(),
                onChanged: (c) {
                  hideKeyboard(context);
                  selectedCountryResponse = c!;
                  if (selectedCountryState != null) {
                    selectedCountryState = null;
                    widget.onChanged.call(selectedCountryResponse?.name, selectedCountryState?.name);
                  }
                  setState(() {});
                },
              ).expand(),
              16.width,
              DropdownButtonFormField<CountryState>(
                decoration: inputDecoration(context, label: ""),
                hint: Text('State', style: secondaryTextStyle()),
                value: selectedCountryState,
                isExpanded: true,
                items: selectedCountryResponse == null
                    ? []
                    : selectedCountryResponse!.states!.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value.name != null && value.name.toString().isNotEmpty ? value.name : "NA",
                              style: primaryTextStyle(),
                            ),
                          );
                        },
                      ).toList(),
                onChanged: (c) {
                  selectedCountryState = c!;
                  widget.onChanged.call(selectedCountryResponse?.name, selectedCountryState?.name);

                  setState(() {});
                },
              ).expand(),
            ],
          );
        }
        return snapWidgetHelper(snap, loadingWidget: AppLoader().center());
      },
    );*/
  }
}
