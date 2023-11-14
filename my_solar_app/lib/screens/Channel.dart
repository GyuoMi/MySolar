// import 'package:flutter/material.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';
// import 'package:my_solar_app/widgets/drawer.dart';
//
// Future<Map<String, dynamic>> setUp() async {
//   final client = StreamChatClient(
//     'b67pax5b2wdq',
//     logLevel: Level.INFO,
//   );
//
//   await client.connectUser(
//     User(id: 'tutorial-flutter'),
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c',
//   );
//
//   final channel = client.channel('messaging', id: 'flutterdevs');
//   await channel.watch();
//
//   return {'client': client, 'channel': channel};
// }
//
// class ChatPage extends StatelessWidget {
//   ChatPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>>(
//         future: setUp(),
//     builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//     // While waiting for data, you can show a loading indicator.
//     return CircularProgressIndicator(); // Replace with your loading widget.
//     } else if (snapshot.hasError) {
//     // Handle errors if necessary.
//     return Text('Error: ${snapshot.error}');
//     } else {
//     final client = snapshot.data!['client'] as StreamChatClient;
//     final channel = snapshot.data!['channel'] as Channel;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chat Page"),
//       ),
//       drawer: CustomDrawer(),
//       body: MaterialApp(
//         builder: (context, widget) {
//           return StreamChat(
//             client: client,
//             child: widget,
//           );
//         },
//         home: StreamChannel(
//           channel: channel,
//           child: const ChannelPage(),
//         ),
//       ),
//     );
//     }
//     },
//     );
//   }
// }
// class ChannelPage extends StatelessWidget {
//   const ChannelPage({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const StreamChannelHeader(),
//       body: Column(
//         children: const <Widget>[
//           Expanded(
//             child: StreamMessageListView(),
//           ),
//           StreamMessageInput(),
//         ],
//       ),
//     );
//   }
// }
