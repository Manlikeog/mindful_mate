import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';

class AnimatedParticles extends ConsumerWidget {
  const AnimatedParticles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Particles(
      awayRadius: 150,
      particles: createParticles(),
      height: screenHeight,
      width: screenWidth,
      onTapAnimation: true,
      awayAnimationDuration: const Duration(milliseconds: 100),
      awayAnimationCurve: Curves.linear,
      enableHover: true,
      hoverRadius: 90,
      connectDots: false,
    );
  }

  List<Particle> createParticles() {
    var rng = Random();
    List<Particle> particles = [];
    for (int i = 0; i < 140; i++) {
      particles.add(Particle(
        color: Colors.white.withOpacity(0.6),
        size: rng.nextDouble() * 10,
        velocity: Offset(rng.nextDouble() * 200 * randomSign(),
            rng.nextDouble() * 200 * randomSign()),
      ));
    }
    return particles;
  }

  double randomSign() {
    var rng = Random();
    return rng.nextBool() ? 1 : -1;
  }
}
