import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import 'baidu_date_state.dart';
import 'baidu_date_cubit.dart';
import 'package:go_router/go_router.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  Timer? _timer;

  BaiduDateCubit get baiduDateCubit => GetIt.instance<BaiduDateCubit>();

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _refresh());
  }

  void _refresh() {
    baiduDateCubit.fetchDate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Baidu.com Date Header')),
      body: BlocBuilder<BaiduDateCubit, BaiduDateState?>(
        bloc: baiduDateCubit,
        builder: (context, BaiduDateState? state) {
          if (state == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.dateHeader?.startsWith('Failed') == true
                      ? state.dateHeader!
                      : 'Baidu Date: ${state.dateHeader}',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (state.responseMilliseconds != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Response time: ${state.responseMilliseconds} ms',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refresh,
                  child: const Text('Refresh Now'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Auto-refreshes every 5 seconds',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    GetIt.instance<GoRouter>().go('/');
                  },
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
