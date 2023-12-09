import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../settings/data/model/bluetooth_device_model.dart';

class SetupBluetoothDeviceView extends StatelessWidget {
  final VoidCallback onSkip;
  final ValueSetter<BluetoothDeviceModel> onTap;
  List<BluetoothDeviceModel>? devices;

  SetupBluetoothDeviceView({required this.onTap, required this.onSkip, required this.devices});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (devices == null)
            Text("loading ...", style: TextStyle(fontSize: 32)),
          if (devices != null && devices!.length == 0)
            Text("no devices connected to the phone",
                style: TextStyle(fontSize: 22)),
          if (devices != null)
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: devices!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices![index].advName),
                  subtitle: Text(devices![index].macAddress),
                  onTap: () {
                    debugPrint("clicked on ${devices![index].advName}");
                    onTap(devices![index]);
                  },
                );
              },
            )
      ,
          ElevatedButton(
            onPressed: onSkip,
            child: Text('Skip'),
          )
        ],
      ),
    ));
  }
}
