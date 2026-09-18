import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/video_player_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageCtrl = PageController();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    getIt<FeedBloc>().add(const FeedLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<FeedBloc>(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedLoading) return const Center(child: CircularProgressIndicator());
            if (state is FeedError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<FeedBloc>().add(const FeedLoadRequested(refresh: true)),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            if (state is FeedLoaded) {
              if (state.videos.isEmpty) {
                return const Center(
                  child: Text('لا توجد فيديوهات بعد', style: TextStyle(color: Colors.white)),
                );
              }
              return PageView.builder(
                controller: _pageCtrl,
                scrollDirection: Axis.vertical,
                itemCount: state.videos.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => VideoPlayerItem(
                  video: state.videos[i],
                  isActive: i == _index,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}