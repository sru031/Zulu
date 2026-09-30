import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/pet_repository.dart';
import 'package:zulu/domain/pet/trait.dart';
import 'package:zulu/domain/text/template.dart';

void main() {
  late AppDatabase db;
  late PetRepository pets;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    pets = PetRepository(db);
  });

  tearDown(() => db.close());

  Future<void> hatch({String name = 'Pip'}) => pets.save(
        name: name,
        pronouns: Pronouns.she,
        eggColor: 'mint',
        trait: Trait.curiosity,
        traitStats: {Trait.curiosity: 6, Trait.calm: 0.5},
        hatchedAt: DateTime(2026, 9, 29, 9),
      );

  test('there is no pet before hatching', () async {
    expect(await pets.get(), isNull);
  });

  test('save stores the hatched pet', () async {
    await hatch();
    final pet = (await pets.get())!;
    expect(pet.name, 'Pip');
    expect(Pronouns.fromId(pet.pronouns), Pronouns.she);
    expect(pet.eggColor, 'mint');
    expect(pet.trait, 'curiosity');
    expect(decodeTraitStats(pet.traitStats), {Trait.curiosity: 6.0, Trait.calm: 0.5});
  });

  test('saving again replaces the single pet row', () async {
    await hatch();
    await hatch(name: 'Mochi');
    expect(await db.select(db.pets).get(), hasLength(1));
    expect((await pets.get())!.name, 'Mochi');
  });

  test('rename changes only the name', () async {
    await hatch();
    await pets.rename('Bean');
    final pet = (await pets.get())!;
    expect(pet.name, 'Bean');
    expect(pet.eggColor, 'mint');
  });

  test('decodeTraitStats ignores unknown traits', () {
    expect(decodeTraitStats('{"calm":1,"bravery":3}'), {Trait.calm: 1.0});
  });
}
