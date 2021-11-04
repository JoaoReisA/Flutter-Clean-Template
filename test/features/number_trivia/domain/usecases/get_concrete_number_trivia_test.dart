import 'package:clean_arch_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  group('Use cases tests', () {
    test('Should get trivia for the number from the repository', () async {
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => const Right(tNumberTrivia));
          final result = await usecase(Params(number: tNumber));

          expect(result, const Right(tNumberTrivia));
          verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
          verifyNoMoreInteractions(mockNumberTriviaRepository);
    });
  });
}
