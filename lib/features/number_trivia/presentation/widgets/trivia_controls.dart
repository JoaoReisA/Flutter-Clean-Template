import 'package:clean_arch_reso/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class TriviaControl extends StatefulWidget {
  const TriviaControl({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  late String inputStr;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //TextField
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: dispatchConcrete,
              child: Text('Search'),
            )),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: dispatchRandom,
              child: Text('Get random trivia'),
            ))
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(numberString:  inputStr));
  }

    void dispatchRandom() {
    controller.clear();
    context
        .read<NumberTriviaBloc>()
        .add(GetTriviaForRandomNumber());
  }
}
