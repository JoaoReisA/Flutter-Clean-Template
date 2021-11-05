import 'package:clean_arch_reso/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_arch_reso/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Number Trivia'),
        ),
        body: buildBody(context));
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Placeholder(),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    //TextField
                    Placeholder(
                      fallbackHeight: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Placeholder(
                          fallbackHeight: 30,
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Placeholder(
                          fallbackHeight: 30,
                        ))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
