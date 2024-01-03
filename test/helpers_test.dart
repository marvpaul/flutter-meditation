import 'package:flutter_meditation/common/helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('helper functions', () {

    test('secondsToHRF - should return a properly formatted string', () async {
      expect(secondsToHRF(60), '01:00');
    });
    /* test('timestampToHRF - should return a properly formatted string', () async {
      expect(timestampToHRF(0), 'Thursday, 01.01.1970 - 01:00');
    }); */
    test('dateToFormattedString - should return a properly formatted string', () async {
      expect(dateToFormattedString(DateTime(1997, 1, 1, 0, 0, 0)), 'Wednesday, 01.01.1997 - 00:00');
      expect(dateToFormattedString(DateTime(1997, 1, 2, 0, 0, 0)), 'Thursday, 02.01.1997 - 00:00');
      expect(dateToFormattedString(DateTime(1997, 1, 3, 0, 0, 0)), 'Friday, 03.01.1997 - 00:00');
      expect(dateToFormattedString(DateTime(1997, 1, 4, 0, 0, 0)), 'Saturday, 04.01.1997 - 00:00');
      expect(dateToFormattedString(DateTime(1997, 1, 5, 0, 0, 0)), 'Sunday, 05.01.1997 - 00:00');
      expect(dateToFormattedString(DateTime(1997, 1, 6, 0, 0, 0)), 'Monday, 06.01.1997 - 00:00');
      expect(dateToFormattedString(DateTime(1997, 1, 7, 0, 0, 0)), 'Tuesday, 07.01.1997 - 00:00');
    });
  });
}