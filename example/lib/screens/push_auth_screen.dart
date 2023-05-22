import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onegini/events/onewelcome_events.dart';
import 'package:onegini/onegini.dart';
import 'package:onegini/onegini.gen.dart';
import '../components/display_toast.dart';
import '../ow_broadcast_helper.dart';

class _ClampingScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      ClampingScrollPhysics();
}

class PushAuthScreen extends StatefulWidget {
  const PushAuthScreen({Key? key}) : super(key: key);

  @override
  _PushAuthScreenState createState() => _PushAuthScreenState();
}

class _PushAuthScreenState extends State<PushAuthScreen> {
  List<OWMobileAuthWithPushRequest>? pendingPushes;
  List<StreamSubscription<OWEvent>>? authenticationSubscriptions;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void initState() {
    super.initState();
    this.authenticationSubscriptions =
        OWBroadcastHelper.initAuthenticationSubscriptions(context);
    _getPendingPushes();
  }

  @override
  void dispose() {
    OWBroadcastHelper.stopListening(authenticationSubscriptions);
    super.dispose();
  }

  void _openMobileAuthModal(OWMobileAuthWithPushRequest request) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.amber,
            child: Center(
              child: Column(
                children: [
                  Text(request.message),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('Accept'),
                        onPressed: () async {
                          try {
                            await Onegini.instance.userClient
                                .acceptMobileAuthWithPushRequest(request);
                            showFlutterToast('request successfully accepted');
                            _removeRequestFromList(request);
                            _refreshIndicatorKey.currentState?.show();
                          } on PlatformException catch (error) {
                            showFlutterToast(error.message);
                          }
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Deny'),
                        onPressed: () async {
                          try {
                            await Onegini.instance.userClient
                                .denyMobileAuthWithPushRequest(request);
                            showFlutterToast('request successfully denied');
                            _removeRequestFromList(request);
                            _refreshIndicatorKey.currentState?.show();
                          } on PlatformException catch (error) {
                            showFlutterToast(error.message);
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _removeRequestFromList(OWMobileAuthWithPushRequest request) {
    setState(() {
      pendingPushes?.remove(request);
    });
  }

  Future<void> _getPendingPushes() async {
    try {
      final pushes = await Onegini.instance.userClient
          .getPendingMobileAuthWithPushRequests();
      setState(() {
        pendingPushes = pushes;
      });
    } on PlatformException catch (error) {
      showFlutterToast(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              "assets/logo_onegini.png",
              width: 200,
              height: 50,
            ),
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(builder: ((_, constraints) {
          return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () => _getPendingPushes(),
              child: ScrollConfiguration(
                behavior: _ClampingScrollBehavior(),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                          maxHeight: constraints.maxHeight),
                      child: _buildPendingPushesList()),
                ),
              ));
        })));
  }

  Widget _buildPendingPushesList() {
    if (pendingPushes?.length == 0) {
      return Center(child: Text("No pushes"));
    }
    return Column(
      children: [
        Builder(builder: (context) {
          final pushes = pendingPushes;
          return pushes != null
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: pushes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                      title: Text(pushes[index].transactionId),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () async {
                            _openMobileAuthModal(pushes[index]);
                          },
                          title: Text("${pushes[index].message}"),
                        )
                      ],
                    );
                  },
                )
              : Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                );
        }),
      ],
    );
  }
}
