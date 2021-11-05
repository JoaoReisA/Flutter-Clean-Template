import 'package:bloc_test/bloc_test.dart';
import 'package:clean_arch_reso/core/util/input_converter.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late GetConcreteNumberTrivia getConcreteNumberTrivia;
  late GetRandomNumberTrivia getRandomNumberTrivia;
  late InputConverter inputConverter;
  late NumberTriviaBloc numberTriviaBloc;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      concrete: getConcreteNumberTrivia,
      random: getRandomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  test('initial state should be empty', () {
    expect(numberTriviaBloc.state, Empty());
  });

  group('GetTriviaForConcreteNUmber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
        'should call the input converter to validate and convert the string to an unsigned integer',
        () async {
      when(() => inputConverter.stringToUnsignedInteger(any()))
          .thenReturn(const Right(tNumberParsed));

      numberTriviaBloc
          .add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(() => inputConverter.stringToUnsignedInteger(any()));

      verify(() => inputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest(
      'should call the input converter to validate and convert the string to an unsigned integer',
      setUp: () {
        when(() => inputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));
      },
      build: () => NumberTriviaBloc(
        concrete: getConcreteNumberTrivia,
        random: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (NumberTriviaBloc bloc) =>
          bloc..add(GetTriviaForConcreteNumber(numberString: 'abc')),
      expect: () => [
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );
  });
}
