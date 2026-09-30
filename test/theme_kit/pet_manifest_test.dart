import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/domain/pet/pet_stage.dart';
import 'package:zulu/theme_kit/pet_manifest.dart';

Matcher failsAt(String path) =>
    throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', path));

PetManifest parse(String stagesJson) => PetManifest.fromJson(JsonReader.decode(
      'pet.json',
      '{"canvas":512,"eggs":[{"id":"e","image":"pet/eggs/e.png"}],"stages":$stagesJson}',
    ));

void main() {
  final manifest = parse('{'
      '"baby":{"poses":{"idle":{"type":"png","path":"b/idle.png"},"happy":{"type":"lottie","path":"b/happy.json","loop":false}},'
      '"anchors":{"head":{"x":1,"y":2}}},'
      '"teen":{"poses":{"idle":{"type":"rive","path":"t/pet.riv","stateMachine":"Main","trigger":"idle"}}}'
      '}');

  test('returns the exact pose when it exists', () {
    final happy = manifest.pose(PetStage.baby, PetPose.happy);
    expect(happy, isA<LottiePose>().having((p) => p.loop, 'loop', isFalse));
    expect(happy.path, 'b/happy.json');
  });

  test('falls back to the same stage idle pose', () {
    final pose = manifest.pose(PetStage.teen, PetPose.sleepy);
    expect(pose, isA<RivePose>().having((p) => p.stateMachine, 'stateMachine', 'Main'));
  });

  test('falls back to the baby idle pose for a stage with no art', () {
    expect(manifest.pose(PetStage.adult, PetPose.happy).path, 'b/idle.png');
  });

  test('stages without anchors reuse the baby anchors', () {
    expect(manifest.anchors(PetStage.teen)[OutfitSlot.head]?.x, 1);
    expect(manifest.anchors(PetStage.teen)[OutfitSlot.head]?.scale, 1);
  });

  test('requires a baby idle pose', () {
    expect(() => parse('{"baby":{"poses":{"happy":{"type":"png","path":"x.png"}}}}'), failsAt(r'$.stages'));
  });

  test('rejects unknown pose types, poses and stages at their path', () {
    expect(
      () => parse('{"baby":{"poses":{"idle":{"type":"gif","path":"x.gif"}}}}'),
      failsAt(r'$.stages.baby.poses.idle.type'),
    );
    expect(
      () => parse('{"baby":{"poses":{"idle":{"type":"png","path":"x.png"},"dance":{"type":"png","path":"y.png"}}}}'),
      failsAt(r'$.stages.baby.poses.dance'),
    );
    expect(
      () => parse('{"baby":{"poses":{"idle":{"type":"png","path":"x.png"}}},"elder":{"poses":{}}}'),
      failsAt(r'$.stages.elder'),
    );
  });
}
