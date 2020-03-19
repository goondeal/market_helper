import 'package:flutter/material.dart';

import 'colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static bool _weightAvailable = true;
  static bool _priceAvailable = true;
  static const double _sizedBoxHeight = 32.0;
  static TextEditingController _weightController,
      _unitWeightController,
      _priceController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _unitWeightController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _unitWeightController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Widget _buildText(String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: mStyle,
      ),
    );
  }

  Widget _buildTextField(
      {TextEditingController controller, Function onTap, Function onChanged}) {
    return TextField(
      textAlign: TextAlign.center,
      cursorColor: Colors.white,
      style: TextStyle(fontSize: 19.0, color: Colors.grey[400]),
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(12.0),
        filled: true,
        fillColor: textFieldColor,
      ),
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 const SizedBox(height: _sizedBoxHeight),
                  _buildText('WEIGHT (kg)'),
                  _buildTextField(
                    controller: _weightController,
                    onTap: () {
                      _weightAvailable = false;
                      _priceAvailable = true;
                      setState(() {
                        _weightController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _weightController.text.length,
                        );
                      });
                    },
                    onChanged: (text) {
                      var unitWeightPrice = _unitWeightController.text;
                      setState(() {
                        if (unitWeightPrice.isNotEmpty && _priceAvailable) {
                          _priceController.text = (double.parse(text) *
                                  double.parse(unitWeightPrice))
                              .toStringAsFixed(2);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: _sizedBoxHeight),
                  _buildText('UNIT-WEIGHT PRICE'),
                  _buildTextField(
                      controller: _unitWeightController,
                      onTap: () {
                        setState(() {
                          _unitWeightController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _unitWeightController.text.length);
                        });
                      },
                      onChanged: (text) {
                        var weight = _weightController.text;
                        var price = _priceController.text;
                        setState(() {
                          if (_priceAvailable && weight.isNotEmpty) {
                            _priceController.text =
                                (double.parse(text) * double.parse(weight))
                                    .toStringAsFixed(2);
                          }

                          if (_weightAvailable && price.isNotEmpty) {
                            double res =
                                double.parse(price) / double.parse(text);
                            String resToPrint = res == res.toInt()
                                ? '${res.toInt()} kg'
                                : res >= 1.0
                                    ? "${res.toStringAsFixed(3)} kg"
                                    : "${res.toStringAsFixed(3)} kg => ${(res * 1000).toStringAsFixed(0)} gm";
                            _weightController.text = resToPrint;
                          }
                        });
                      }),
                 const SizedBox(height: _sizedBoxHeight),
                  _buildText('TOTAL PRICE -or- BUDGET'),
                  _buildTextField(
                      controller: _priceController,
                      onTap: () {
                        _weightAvailable = true;
                        _priceAvailable = false;
                        setState(() {
                          _priceController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _priceController.text.length);
                        });
                      },
                      onChanged: (text) {
                        var unitWeightPrice = _unitWeightController.text;
                        setState(() {
                          if (unitWeightPrice.isNotEmpty && _weightAvailable) {
                            double res = double.parse(text) /
                                double.parse(unitWeightPrice);
                            String resToPrint = res == res.toInt()
                                ? '${res.toInt()} kg'
                                : res >= 1.0
                                    ? "${res.toStringAsFixed(3)} kg"
                                    : "${res.toStringAsFixed(3)} kg => ${(res * 1000).toStringAsFixed(0)} gm";

                            _weightController.text = resToPrint;
                          }
                        });
                      }),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: RaisedButton(
                      splashColor: Colors.white,
                      hoverColor: Colors.white,
                      animationDuration: Duration(milliseconds: 10),
                      elevation: 0,
                      color: textFieldColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _weightController.clear();
                        _unitWeightController.clear();
                        _priceController.clear();

                        _weightAvailable = _priceAvailable = true;
                      },
                    ),
                  ),
                 const SizedBox(height: 24),
                ]),
          ),
        ),
      ),
    );
  }
}
