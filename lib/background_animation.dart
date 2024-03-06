import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BackgroundAnimation extends StatefulWidget {
  const BackgroundAnimation({
    super.key,
    this.builder,
  });

  final WidgetBuilder? builder;

  @override
  State<BackgroundAnimation> createState() => _BackgroundAnimationState();
}

class _BackgroundAnimationState extends State<BackgroundAnimation> {
  StateMachineController? _sceneryController;
  late double time = 12;

  void _handleTimeChanged(value) {
    if (_sceneryController != null) {
      setState(() {
        time = value;
      });
      _sceneryController!.findInput<double>('time')?.value = value;
    }
  }

  void _onInit(Artboard art) {
    var ctrl = StateMachineController.fromArtboard(
      art,
      'state',
    ) as StateMachineController;

    art.addController(ctrl);

    // Set the initial time
    ctrl.findInput<double>('time')?.value = time;

    setState(() {
      _sceneryController = ctrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: RiveAnimation.network(
                'https://public.rive.app/community/runtime-files/8645-16533-day-night-cycle.riv',
                useArtboardSize: true,
                artboard: "DayAndNight",
                stateMachines: const ["state"],
                fit: BoxFit.cover,
                onInit: _onInit,
              ),
            ),
            Center(
              child: Slider(
                value: time,
                min: 0,
                max: 24,
                onChanged: _handleTimeChanged,
              ),
            )
          ],
        ),
      ],
    );
  }
}
