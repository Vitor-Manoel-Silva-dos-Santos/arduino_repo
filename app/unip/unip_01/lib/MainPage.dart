  //  // Method to connect to bluetooth
  // void _connect() async {
  //   setState(() {
  //     _isButtonUnavailable = true;
  //   });
  //   if (_device == null) {
  //   } else {
  //     if (!isConnected) {
  //       await BluetoothConnection.toAddress(_device.address)
  //           .then((_connection) {
  //         print('Connected to the device');
  //         connection = _connection;
  //         setState(() {
  //           _connected = true;
  //         });

  //         connection.input.listen(null).onDone(() {
  //           if (isDisconnecting) {
  //             print('Disconnecting locally!');
  //           } else {
  //             print('Disconnected remotely!');
  //           }
  //           if (this.mounted) {
  //             setState(() {});
  //           }
  //         });
  //       }).catchError((error) {
  //         print('Cannot connect, exception occurred');
  //         print(error);
  //       });

  //       setState(() => _isButtonUnavailable = false);
  //     }
  //   }
  // }
   
   
   
   
   
  //   // Method to disconnect bluetooth
  // void _disconnect() async {
  //   setState(() {
  //     _isButtonUnavailable = true;
  //     _deviceState = 0;
  //   });

  //   await connection.close();
  //   if (!connection.isConnected) {
  //     setState(() {
  //       _connected = false;
  //       _isButtonUnavailable = false;
  //     });
  //   }
  // }

  
  
  
  // // Method to send message,
  // // for turning the Bluetooth device on
  // void _sendOnMessageToBluetooth1() async {
  //   connection.output.add(ascii.encode("josue1" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }

  // void _sendOnMessageToBluetooth2() async {
  //   connection.output.add(ascii.encode("josue2" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }

  // void _sendOnMessageToBluetooth3() async {
  //   connection.output.add(ascii.encode("josue3" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }

  // void _sendOnMessageToBluetooth4() async {
  //   connection.output.add(ascii.encode("josue4" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }
  // void _sendOnMessageToBluetooth5() async {
  //   connection.output.add(ascii.encode("josue5" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }
  // void _sendOnMessageToBluetooth6() async {
  //   connection.output.add(ascii.encode("josue6" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }
  // void _sendOnMessageToBluetooth7() async {
  //   connection.output.add(ascii.encode("josue7" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }
  // void _sendOnMessageToBluetooth8() async {
  //   connection.output.add(ascii.encode("josue8" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }
  // void _sendOnMessageToBluetooth9() async {
  //   connection.output.add(ascii.encode("josue9" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }
  // void _sendOnMessageToBluetooth10() async {
  //   connection.output.add(ascii.encode("josue10" + "\r\n"));
  //   await connection.output.allSent;
  //   setState(() {
  //     _deviceState = 1; // device on
  //   });
  // }