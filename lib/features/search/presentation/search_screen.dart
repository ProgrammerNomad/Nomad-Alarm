import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _selectResult(SearchResult result, {String query = ''}) async {
    await ref.read(searchControllerProvider.notifier).selectResult(result);
    if (!mounted) {
      return;
    }
    context.push(
      '/alarm/new',
      extra: DestinationArgs.fromSearchResult(result),
    );
  }

  Future<void> _saveFavorite(SearchResult result) async {
    await ref.read(favoriteRepositoryProvider).save(
          name: result.name,
          latitude: result.latitude,
          longitude: result.longitude,
          address: result.address,
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchControllerProvider);
    final recentAsync = ref.watch(recentSearchesProvider);
    final query = _controller.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search destination'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _controller,
              focusNode: _focusNode,
              hintText: 'Station, landmark, address…',
              leading: const Icon(Icons.search),
              trailing: [
                if (query.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      ref.read(searchControllerProvider.notifier).search('');
                      setState(() {});
                    },
                  ),
              ],
              onChanged: (value) {
                ref.read(searchControllerProvider.notifier).search(value);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: query.isEmpty
                ? _RecentList(
                    recentAsync: recentAsync,
                    onSelect: (recent) => _selectResult(
                      ref.read(searchControllerProvider.notifier).recentToResult(recent),
                    ),
                  )
                : resultsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Search failed: $e'),
                      ),
                    ),
                    data: (results) {
                      if (results.isEmpty) {
                        return const Center(child: Text('No results found'));
                      }
                      return ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final result = results[index];
                          return _ResultTile(
                            result: result,
                            onTap: () => _selectResult(result, query: query),
                            onLongPress: () => _saveFavorite(result),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.result,
    required this.onTap,
    required this.onLongPress,
  });

  final SearchResult result;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.place_outlined),
      title: Text(result.name),
      subtitle: result.address != null ? Text(result.address!) : null,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

class _RecentList extends StatelessWidget {
  const _RecentList({
    required this.recentAsync,
    required this.onSelect,
  });

  final AsyncValue<List<RecentSearch>> recentAsync;
  final ValueChanged<RecentSearch> onSelect;

  @override
  Widget build(BuildContext context) {
    return recentAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (recent) {
        if (recent.isEmpty) {
          return const Center(
            child: Text('Search for a station, landmark, or address'),
          );
        }
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Recent',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ...recent.map(
              (item) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(item.resultName),
                subtitle: item.address != null ? Text(item.address!) : null,
                onTap: () => onSelect(item),
              ),
            ),
          ],
        );
      },
    );
  }
}
