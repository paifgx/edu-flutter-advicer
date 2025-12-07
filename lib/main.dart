import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/pages/advice/bloc/advice_bloc.dart';
import 'application/pages/advice/bloc/advice_event.dart';
import 'application/pages/advice/bloc/advice_state.dart';
import 'application/pages/advice/bloc/favorites/favorites_bloc.dart';
import 'application/pages/advice/bloc/favorites/favorites_event.dart';
import 'application/pages/advice/bloc/favorites/favorites_state.dart';
import 'domain/entities/advice_entity.dart';
import 'injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advicer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const AdvicePage(),
    );
  }
}

class AdvicePage extends StatefulWidget {
  const AdvicePage({super.key});

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends State<AdvicePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AdviceBloc>()),
        BlocProvider(
          create: (_) => di.sl<FavoritesBloc>()..add(const LoadFavoritesEvent()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Advicer'),
          centerTitle: true,
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
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    final count = state is FavoritesLoaded ? state.favorites.length : 0;
                    return Text(
                      'Favoriten: $count',
                      style: const TextStyle(color: Colors.grey),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Builder(
                  builder: (buttonContext) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => buttonContext
                          .read<AdviceBloc>()
                          .add(const AdviceRequestedEvent()),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          'GET ADVICE',
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<AdviceBloc, AdviceState>(
                  builder: (context, state) {
                    if (state is AdviceLoaded) {
                      final advice = AdviceEntity(advice: state.advice, id: state.id);
                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () => context
                              .read<FavoritesBloc>()
                              .add(AddFavoriteEvent(advice: advice)),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('Save to favorites'),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Builder(
                  builder: (buttonContext) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => buttonContext
                          .read<FavoritesBloc>()
                          .add(const LoadFavoritesEvent()),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          'Reload favorites',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Favoriten',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 160,
                  child: BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      if (state is FavoritesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FavoritesError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is FavoritesLoaded) {
                        if (state.favorites.isEmpty) {
                          return const Center(
                            child: Text('Keine Favoriten gespeichert.'),
                          );
                        }
                        return ListView.builder(
                          itemCount: state.favorites.length,
                          itemBuilder: (context, index) {
                            final fav = state.favorites[index];
                            return ListTile(
                              title: Text(fav.advice),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => context
                                    .read<FavoritesBloc>()
                                    .add(RemoveFavoriteEvent(id: fav.id)),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
