import 'package:clean_arch_reso/core/usecases/usecase.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  group('Use cases tests', () {
    test('Should get trivia from the repository', () async {
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
          final result = await usecase(NoParams());

          expect(result, const Right(tNumberTrivia));
          verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
          verifyNoMoreInteractions(mockNumberTriviaRepository);
    });
  });
}
