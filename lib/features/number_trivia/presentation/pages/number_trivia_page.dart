import 'package:catdd_numbertrivia/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:catdd_numbertrivia/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }
}

BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<NumberTriviaBloc>(),
    child: Center(
      //Top Half
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
            if (state is InitialNumberTriviaState) {
              return MessageDisplay(
                message: 'Start Searching!',
              );
            } else if (state is Error) {
              return MessageDisplay(
                message: state.message,
              );
            }
            return Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Center(
                child: Text('Start Searching'),
              ),
            );
          }),
          SizedBox(height: 10),
          //Bottom Half
          Column(
            children: <Widget>[
              Placeholder(fallbackHeight: 40),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(child: Placeholder(fallbackHeight: 30)),
                  SizedBox(width: 10),
                  Expanded(child: Placeholder(fallbackHeight: 30)),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
