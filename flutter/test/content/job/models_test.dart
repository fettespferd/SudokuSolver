import 'package:sudokuSolver/content/job/models.dart';

import 'package:test/test.dart';

import '../../utils/serialization.dart';

void main() {
  group('Job', () {
    group('JSON serialization', () {
      testJsonSerialization(
        'Feinwerkmechaniker/in initialized ',
        object: Job(
          duration: '3,5',
          industry: 'Mechanik/Mechatronik',
          requiredDegree: 'Realschulabschluss',
          procedure:
              'In der Ausbildung musst als erstes den Betrieb kennenlernen, in dem du deine Ausbildung machst und dich in deinem neuen Umfeld zurechtfinden. Wenn du dich etwas eingewöhnt hast, beginnen deine Ausbilder/innen damit, dir die verschiedenen Werkstoffe und Werkzeuge zu zeigen, mit denen du später arbeiten wirst. Dann kannst du endlich mit anpacken und arbeitest dich von einfachen Baugruppen zu immer komplizierteren hoch. Nach einer Zwischenprüfung entscheidest du dich dann für einen der oben genannten Schwerpunkte und verstiefst dein Wissen und deine Fähigkeiten auf dem jeweiligen Gebiet. Insgesamt dauert deine Ausbildung dreieinhalb Jahre und wird dual absolviert, das bedeutet, dass du die oben genannten Dinge nicht nur in der Praxis in deinem Ausbildungsbetrieb kennenlernst, sondern dich auch theoretisch mit ihnen auseinandersetzt. Das findet in der Berufsschule statt, die du an einigen Tagen in der Woche besuchst und in der du auch in allgemeinbildenden Fächern unterrichtet wirst. Deine Abschlussprüfung wartet am Ende der Ausbildung auf dich und du musst einen schriftlichen und einen praktischen Teil bestehen, bevor du dich offiziell staatlich anerkannte/r Feinwerkmechaniker/in nennen kannst.',
          suitability:
              'Der Beruf interessiert dich, aber bevor du dich bewirbst, möchtest du sichergehen, dass es auch wirklich etwas für dich ist? Am ehesten kannst du dir das beantworten, wenn du ein Praktikum machst. Aber wir haben einige Fragen für dich zusammengestellt, die dir auch jetzt schon helfen können, eine Antwort zu finden. Hast du einen Hang zum Perfektionismus, ein Faible für Organisation und ein Auge für Details? Technische Aufgaben gehen dir leicht von der Hand und machen dir Spaß? Du hast Bock auf Teamwork?Du solltest diese Fragen mit Ja beantworten können, wenn der Beruf des/der Feinwerkmechaniker/in etwas für dich ist.',
          tasks: 'Herstellung von (sehr kleinen) Geräte- und Maschinenteilen',
          type: 'duale Ausbildung',
          workingHours: ['Schichtdienst'],
          earnings: [621, 666, 745, 814],
          name: 'Feinwerkmechaniker/in',
          tips:
              'Neben der Vollständigkeit deiner Bewerbungsunterlagen solltest du darauf achten, deine persönliche Eignung für die Stelle in den Mittelpunkt zu stellen. Am besten gelingt dir das, wenn du Hobby erwähnst, bei denen du die erforderlichen Fähigkeiten schulen konntest. Wenn du eine Einladung zu einem Vorstellungsgespräch bekommst, dann brauchst du dir über den Dresscode zum Glück nicht lange den Kopf zu zerbrechen. Bei der Arbeit als Feinwerkmechaniker/in wirst du dich immer mal wieder schmutzig machen, deswegen kannst du ruhig in Hose und Hemd bzw. Bluse kommen, solange du ordentlich und gepflegt aussiehst, ist das vollkommen angemessen.',
          workingLocation: ['Werkstätten', 'Produktionshallen'],
          furtherEducation: [
            'Meister/in',
            'Fachkaufmann/frau in der Handwerkswirtschaft',
            'Studium (z.B. Konstruktionstechnik)'
          ],
        ),
        json: <String, dynamic>{
          'duration': '3,5',
          'industry': 'Mechanik/Mechatronik',
          'requiredDegree': 'Realschulabschluss',
          'procedure':
              'In der Ausbildung musst als erstes den Betrieb kennenlernen, in dem du deine Ausbildung machst und dich in deinem neuen Umfeld zurechtfinden. Wenn du dich etwas eingewöhnt hast, beginnen deine Ausbilder/innen damit, dir die verschiedenen Werkstoffe und Werkzeuge zu zeigen, mit denen du später arbeiten wirst. Dann kannst du endlich mit anpacken und arbeitest dich von einfachen Baugruppen zu immer komplizierteren hoch. Nach einer Zwischenprüfung entscheidest du dich dann für einen der oben genannten Schwerpunkte und verstiefst dein Wissen und deine Fähigkeiten auf dem jeweiligen Gebiet. Insgesamt dauert deine Ausbildung dreieinhalb Jahre und wird dual absolviert, das bedeutet, dass du die oben genannten Dinge nicht nur in der Praxis in deinem Ausbildungsbetrieb kennenlernst, sondern dich auch theoretisch mit ihnen auseinandersetzt. Das findet in der Berufsschule statt, die du an einigen Tagen in der Woche besuchst und in der du auch in allgemeinbildenden Fächern unterrichtet wirst. Deine Abschlussprüfung wartet am Ende der Ausbildung auf dich und du musst einen schriftlichen und einen praktischen Teil bestehen, bevor du dich offiziell staatlich anerkannte/r Feinwerkmechaniker/in nennen kannst.',
          'suitability':
              'Der Beruf interessiert dich, aber bevor du dich bewirbst, möchtest du sichergehen, dass es auch wirklich etwas für dich ist? Am ehesten kannst du dir das beantworten, wenn du ein Praktikum machst. Aber wir haben einige Fragen für dich zusammengestellt, die dir auch jetzt schon helfen können, eine Antwort zu finden. Hast du einen Hang zum Perfektionismus, ein Faible für Organisation und ein Auge für Details? Technische Aufgaben gehen dir leicht von der Hand und machen dir Spaß? Du hast Bock auf Teamwork?Du solltest diese Fragen mit Ja beantworten können, wenn der Beruf des/der Feinwerkmechaniker/in etwas für dich ist.',
          'tasks': 'Herstellung von (sehr kleinen) Geräte- und Maschinenteilen',
          'type': 'duale Ausbildung',
          'workingHours': ['Schichtdienst'],
          'earnings': [621, 666, 745, 814],
          'name': 'Feinwerkmechaniker/in',
          'tips':
              'Neben der Vollständigkeit deiner Bewerbungsunterlagen solltest du darauf achten, deine persönliche Eignung für die Stelle in den Mittelpunkt zu stellen. Am besten gelingt dir das, wenn du Hobby erwähnst, bei denen du die erforderlichen Fähigkeiten schulen konntest. Wenn du eine Einladung zu einem Vorstellungsgespräch bekommst, dann brauchst du dir über den Dresscode zum Glück nicht lange den Kopf zu zerbrechen. Bei der Arbeit als Feinwerkmechaniker/in wirst du dich immer mal wieder schmutzig machen, deswegen kannst du ruhig in Hose und Hemd bzw. Bluse kommen, solange du ordentlich und gepflegt aussiehst, ist das vollkommen angemessen.',
          'workingLocation': ['Werkstätten', 'Produktionshallen'],
          'furtherEducation': [
            'Meister/in',
            'Fachkaufmann/frau in der Handwerkswirtschaft',
            'Studium (z.B. Konstruktionstechnik)'
          ],
        },
        fromJson: (json) => Job.fromJson(json),
      );
      testJsonSerialization(
        'Berufssoldat/in initialized ',
        object: Job(
          duration: '',
          industry: 'Staatlich',
          requiredDegree: '',
          procedure:
              'Als Berufssoldat*in verpflichtest du dich, bis zum Ruhestand eine Feldwebel- oder Offizierslaufbahn zu verfolgen. Das kannst du tun, wenn du Soldat*in auf Zeit bist und deine Verpflichtungszeit abläuft. Allerdings ist das gar nicht so einfach, da du viele Voraussetzungen beachten und sehr gute Leistungen erbringen musst. Informiere dich am besten im Vorfeld, wie deine Laufbahn als Soldat*in aussehen könnte.',
          suitability: '',
          tasks: '',
          type: '',
          workingHours: null,
          earnings: null,
          name: 'Berufssoldat/in',
          tips: '',
          workingLocation: null,
          furtherEducation: null,
        ),
        json: <String, dynamic>{
          'duration': '',
          'industry': 'Staatlich',
          'requiredDegree': '',
          'procedure':
              'Als Berufssoldat*in verpflichtest du dich, bis zum Ruhestand eine Feldwebel- oder Offizierslaufbahn zu verfolgen. Das kannst du tun, wenn du Soldat*in auf Zeit bist und deine Verpflichtungszeit abläuft. Allerdings ist das gar nicht so einfach, da du viele Voraussetzungen beachten und sehr gute Leistungen erbringen musst. Informiere dich am besten im Vorfeld, wie deine Laufbahn als Soldat*in aussehen könnte.',
          'suitability': '',
          'tasks': '',
          'type': '',
          'workingHours': null,
          'earnings': null,
          'name': 'Berufssoldat/in',
          'tips': '',
          'workingLocation': null,
          'furtherEducation': null,
        },
        fromJson: (json) => Job.fromJson(json),
      );
    });
  });
}
