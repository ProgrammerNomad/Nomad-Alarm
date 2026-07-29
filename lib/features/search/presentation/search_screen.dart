import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/alarm_config_args.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/models/search_result.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:nomad_alarm/services/deep_link_service.dart';
import 'package:nomad_alarm/services/group_travel_service.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _speech = stt.SpeechToText();
  var _listening = false;

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
        SnackBar(content: Text(context.l10n.savedToFavorites)),
      );
    }
  }

  Future<void> _importFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      return;
    }

    if (FeatureFlags.groupTravel) {
      const groupTravel = GroupTravelService();
      final draft = groupTravel.parseImport(text);
      if (draft != null) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.importAlarmConfig)),
        );
        context.push(
          '/alarm/new',
          extra: AlarmConfigArgs(
            destination: DestinationArgs(
              name: draft.name,
              latitude: draft.destLatitude,
              longitude: draft.destLongitude,
              address: draft.address,
              placeId: draft.placeId,
            ),
            importedDraft: draft,
          ),
        );
        return;
      }
    }

    final args = DeepLinkService.parse(text);
    if (!mounted) {
      return;
    }
    if (args == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.deepLinkInvalid)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.deepLinkImported)),
    );
    context.push('/alarm/new', extra: args);
  }

  Future<void> _startVoiceSearch() async {
    if (!FeatureFlags.voiceSearch) {
      return;
    }
    final available = await _speech.initialize();
    if (!available || !mounted) {
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
        ref.read(searchControllerProvider.notifier).search(result.recognizedWords);
        if (mounted) {
          setState(() {});
        }
      },
    );
    if (mounted) {
      setState(() => _listening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resultsAsync = ref.watch(searchControllerProvider);
    final recentAsync = ref.watch(recentSearchesProvider);
    final query = _controller.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchDestination),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (FeatureFlags.voiceSearch)
            IconButton(
              icon: Icon(_listening ? Icons.mic : Icons.mic_none_outlined),
              tooltip: l10n.voiceSearchHint,
              onPressed: _listening ? null : _startVoiceSearch,
            ),
          if (FeatureFlags.deepLinkImport)
            Semantics(
              label: l10n.semImportFromClipboard,
              button: true,
              child: IconButton(
                icon: const Icon(Icons.content_paste_go_outlined),
                tooltip: l10n.importFromClipboard,
                onPressed: _importFromClipboard,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Semantics(
              label: l10n.semSearchSubmit,
              child: SearchBar(
                controller: _controller,
                focusNode: _focusNode,
                hintText: l10n.searchHintExtended,
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
          ),
          Expanded(
            child: query.isEmpty
                ? _RecentList(
                    recentAsync: recentAsync,
                    onSelect: (recent) => _selectResult(
                      ref
                          .read(searchControllerProvider.notifier)
                          .recentToResult(recent),
                    ),
                  )
                : resultsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(l10n.searchFailed(e.toString())),
                      ),
                    ),
                    data: (results) {
                      if (results.isEmpty) {
                        return Center(child: Text(l10n.noResultsFound));
                      }
                      return ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
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
    final l10n = context.l10n;
    return recentAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l10n.errorPrefix(e.toString()))),
      data: (recent) {
        if (recent.isEmpty) {
          return Center(child: Text(l10n.searchEmptyHint));
        }
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                l10n.recent,
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
