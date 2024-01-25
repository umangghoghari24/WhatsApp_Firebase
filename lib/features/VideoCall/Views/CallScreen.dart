
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Model/VideoCall.dart';
import '../../../commen/krmLoader.dart';
import '../../../config/AgoraConfig.dart';
import '../Controller/VideoCallController.dart';
import 'package:agora_uikit/agora_uikit.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final VideoCall videoCall;
  final bool isGroupChat;

  CallScreen({
    super.key,
    required this.channelId,
    required this.videoCall,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String hosturl = 'https://ntce-ad8e47b5a79c.herokuapp.com/';
  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: hosturl,
      ),
    );

    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const krmLoader()
          : SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: client!),
            AgoraVideoButtons(
              client: client!,
              disconnectButtonChild: IconButton(
                icon: const Icon(
                  Icons.call_end,
                ),
                onPressed: () async {
                  await client!.engine.leaveChannel();
                  ref.read(videocallClasscontrollerProvider).endCall(
                    widget.videoCall.callerId,
                    widget.videoCall.receiverId,
                    context,
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
