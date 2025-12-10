import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:advicer/injection.dart' as di;
import 'package:advicer/application/pages/advice/ui/list_demo_page.dart';
import 'package:advicer/application/pages/advice/bloc/advice_bloc.dart';
import 'package:advicer/application/pages/advice/bloc/advice_event.dart';
import 'package:advicer/application/pages/advice/bloc/advice_state.dart';

class AdvicePage extends StatefulWidget {
  const AdvicePage({super.key});

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends State<AdvicePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AdviceBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Advicer'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Liste-Demo',
              icon: const Icon(Icons.list_alt),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ListDemoPage()));
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                BlocBuilder<AdviceBloc, AdviceState>(
                  builder: (context, state) {
                    if (state is AdviceLoading) {
                      return const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 24),
                        ],
                      );
                    } else if (state is AdviceLoaded) {
                      return Column(
                        children: [
                          Text(
                            '"${state.advice}"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Geladen über BLoC & UseCase',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      );
                    } else if (state is AdviceError) {
                      return Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      );
                    }

                    // Initial
                    return const Column(
                      children: [
                        Text(
                          '"Your Advice here"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Hier wird später ein echter Ratschlag von der API stehen.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
                const Spacer(),
                Builder(
                  builder: (buttonContext) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => buttonContext.read<AdviceBloc>().add(
                        const AdviceRequestedEvent(),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          'GET ADVICE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
