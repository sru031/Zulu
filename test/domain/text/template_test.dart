import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/domain/text/template.dart';

void main() {
  Map<String, String> vars({String userName = 'Sam', Pronouns pronouns = Pronouns.she}) => templateVars(
        userName: userName,
        petName: 'Pip',
        pronouns: pronouns,
        currency: 'coin',
        currencyPlural: 'coins',
      );

  test('fills standard placeholders', () {
    expect(fillTemplate('{petName} saved 3 {currencyPlural} for {userName}.', vars()), 'Pip saved 3 coins for Sam.');
  });

  test('uses the pet pronouns', () {
    expect(fillTemplate('{They} said {they} loves {their} hat. Tell {them}!', vars()), 'She said she loves her hat. Tell her!');
    expect(fillTemplate('{They} brought {their} map', vars(pronouns: Pronouns.they)), 'They brought their map');
  });

  test('an empty user name reads as "friend"', () {
    expect(fillTemplate('Hi {userName}!', vars(userName: '')), 'Hi friend!');
    expect(fillTemplate('Hi {userName}!', vars(userName: '   ')), 'Hi friend!');
  });

  test('leaves unknown placeholders visible', () {
    expect(fillTemplate('Hi {nmae}', vars()), 'Hi {nmae}');
  });

  test('reports unknown placeholder names', () {
    expect(unknownPlaceholders('{petName} {nmae} {They}'), {'nmae'});
    expect(unknownPlaceholders('no placeholders'), isEmpty);
  });

  test('Pronouns.fromId falls back to they', () {
    expect(Pronouns.fromId('he'), Pronouns.he);
    expect(Pronouns.fromId('xyz'), Pronouns.they);
  });
}
