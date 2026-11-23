import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/audio_handler/auto/car_list_ranges.dart';

void main() {
  test('car list ranges cover later lists without nesting sequential More nodes', () {
    final ranges = carListRanges(121).toList();
    expect(ranges, [
      (page: 0, first: 1, last: 20),
      (page: 1, first: 21, last: 40),
      (page: 2, first: 41, last: 60),
      (page: 3, first: 61, last: 80),
      (page: 4, first: 81, last: 100),
      (page: 5, first: 101, last: 120),
      (page: 6, first: 121, last: 121),
    ]);
  });

  test('empty collections and exact boundaries do not produce extra range folders', () {
    expect(carListRanges(0), isEmpty);
    expect(carListRanges(20).single, (page: 0, first: 1, last: 20));
    expect(carListRanges(40).last, (page: 1, first: 21, last: 40));
  });
}
