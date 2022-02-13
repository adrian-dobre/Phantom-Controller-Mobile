import 'package:flutter/material.dart';
import 'package:phantom_controller/application/widgets/themed_scaffold.dart';

class Configuration extends StatefulWidget {
  const Configuration(
      {Key? key,
      this.controllerAddress,
      this.controllerAccessKey,
      required this.onSave})
      : super(key: key);

  final String? controllerAddress;
  final String? controllerAccessKey;
  final Function(
      {required String controllerAddress,
      required String controllerAccessKey}) onSave;

  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  final _formKey = GlobalKey<FormState>();

  String? controllerAddress;
  String? controllerAccessKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      title: "Configuration",
      body: Center(
          child: Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        autocorrect: false,
                        initialValue: widget.controllerAddress,
                        decoration: const InputDecoration(
                            label: Text('Controller Address'),
                            hintText: 'https://www.example.com'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            controllerAddress = value;
                          });
                        },
                      ),
                      TextFormField(
                        autocorrect: false,
                        obscureText: true,
                        initialValue: widget.controllerAccessKey,
                        decoration: const InputDecoration(
                            label: Text('Controller Access Key'),
                            hintText: 'fng1BFnhGo2E'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            controllerAccessKey = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  widget.onSave(
                                      controllerAddress: controllerAddress!,
                                      controllerAccessKey:
                                          controllerAccessKey!);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Save'),
                            )
                          ],
                        ),
                      ),
                    ],
                  )))),
    );
  }
}
