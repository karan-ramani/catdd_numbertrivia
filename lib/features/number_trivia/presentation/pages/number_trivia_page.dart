import 'package:catdd_numbertrivia/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:catdd_numbertrivia/features/number_trivia/presentation/widgets/trivia_state_controls.dart';
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
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }
}

BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<NumberTriviaBloc>(),
    child: Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          //Top Half
          BuildBloc(),
          SizedBox(height: 10),
          //Bottom Half
          TriviaControl(),
        ],
      ),
    ),
  );
}

class BuildBloc extends StatelessWidget {
  const BuildBloc({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        builder: (context, state) {
          if (state is InitialNumberTriviaState) {
            return MessageDisplay(
              message: 'Start Searching!',
            );
          } else if (state is Error) {
            return MessageDisplay(
              message: state.message,
            );
          } else if (state is Loading) {
            return LoadingWidget();
          } else if (state is Loaded) {
            return DisplayTrivia(
              trivia: state.trivia,
            );
          }
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height / 3,
            child: Center(
              child: Text('Start Searching'),
            ),
          );
        });
  }
}
