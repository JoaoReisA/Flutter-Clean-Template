import 'package:bloc_test/bloc_test.dart';
import 'package:clean_arch_reso/core/error/failures.dart';
import 'package:clean_arch_reso/core/usecases/usecase.dart';
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
      when(() => getConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((invocation) async => const Right(tNumberTrivia));

      numberTriviaBloc
          .add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(() => inputConverter.stringToUnsignedInteger(any()));

      verify(() => inputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest(
      'should call the input converter to validate and convert the string to an unsigned integer when gets an error',
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

    test('should get data from the usecase', () async {
      when(() => inputConverter.stringToUnsignedInteger(any()))
          .thenReturn(const Right(tNumberParsed));

      when(() => getConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((invocation) async => const Right(tNumberTrivia));

      numberTriviaBloc
          .add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(
          () => getConcreteNumberTrivia(const Params(number: tNumberParsed)));

      verify(
          () => getConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    blocTest(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(() => inputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));

        when(() => getConcreteNumberTrivia(const Params(number: tNumberParsed)))
            .thenAnswer((invocation) async => const Right(tNumberTrivia));
      },
      build: () => NumberTriviaBloc(
        concrete: getConcreteNumberTrivia,
        random: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (NumberTriviaBloc bloc) =>
          bloc..add(GetTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => [Loading(), Loaded(numberTrivia: tNumberTrivia)],
    );
    blocTest(
      'Should emit [Loading, Error] when getting data fails',
      setUp: () {
        when(() => inputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));

        when(() => getConcreteNumberTrivia(const Params(number: tNumberParsed)))
            .thenAnswer((invocation) async => Left(ServerFailure()));
      },
      build: () => NumberTriviaBloc(
        concrete: getConcreteNumberTrivia,
        random: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (NumberTriviaBloc bloc) =>
          bloc..add(GetTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => [Loading(), Error(message: SERVER_FAILURE_MESSAGE)],
    );
    blocTest(
      'Should emit [Loading, Error] with the proper message for the error when getting data fails',
      setUp: () {
        when(() => inputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));

        when(() => getConcreteNumberTrivia(const Params(number: tNumberParsed)))
            .thenAnswer((invocation) async => Left(CacheFailure()));
      },
      build: () => NumberTriviaBloc(
        concrete: getConcreteNumberTrivia,
        random: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (NumberTriviaBloc bloc) =>
          bloc..add(GetTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => [Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });

    group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random usecase', () async {

      when(() => getRandomNumberTrivia(NoParams()))
          .thenAnswer((invocation) async => const Right(tNumberTrivia));

      numberTriviaBloc
          .add(GetTriviaForRandomNumber());
      await untilCalled(
          () => getRandomNumberTrivia(NoParams()));

      verify(
          () => getRandomNumberTrivia(NoParams()));
    });

    blocTest(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(() => getRandomNumberTrivia(NoParams()))
          .thenAnswer((invocation) async => const Right(tNumberTrivia));
      },
      build: () => NumberTriviaBloc(
        concrete: getConcreteNumberTrivia,
        random: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (NumberTriviaBloc bloc) =>
          bloc..add(GetTriviaForRandomNumber()),
      expect: () => [Loading(), Loaded(numberTrivia: tNumberTrivia)],
    );
    blocTest(
      'Should emit [Loading, Error] when getting data fails',
      setUp: () {

        when(() => getRandomNumberTrivia(NoParams()))
            .thenAnswer((invocation) async => Left(ServerFailure()));
      },
      build: () => NumberTriviaBloc(
        concrete: getConcreteNumberTrivia,
        random: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (NumberTriviaBloc bloc) =>
          bloc..add(GetTriviaForRandomNumber()),
      expect: () => [Loading(), Error(message: SERVER_FAILURE_MESSAGE)],
    );
    blocTest(
      'Should emit [Loading, Error] with the proper message for the error when getting data fails',
      setUp: () {

        when(() => getRandomNumberTrivia(NoParams()))
            .thenAnswer((invocation) async => Left(CacheFailure()));
      },
      build: () => NumberTriviaBloc(
        concrete: getConcreteNumberTrivia,
        random: getRandomNumberTrivia,
        inputConverter: inputConverter,
      ),
      act: (NumberTriviaBloc bloc) =>
          bloc..add(GetTriviaForRandomNumber()),
      expect: () => [Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });
}
