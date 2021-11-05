import 'package:clean_arch_reso/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () {
      const str = '123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Right(123));
    });
    test('should return a failure when the string is not an integer', () {
      const str = 'abc';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
    test('should return a failure when the string is an negative integer', () {
      const str = '-123';

      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
