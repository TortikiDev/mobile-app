import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/http_client/requests/requests.dart';
import '../../data/http_client/responses/confectioner/confectioner_short_response.dart';
import '../../data/repositories/repositories.dart';
import '../../ui/reusable/list_items/progress_indicator_item.dart';
import '../../ui/screens/map/search_confectioners/confectioner/confectioner_view_model.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class SearchConfectionersBloc
    extends BaseBloc<SearchConfectionersEvent, SearchConfectionersState> {
  // region Properties

  final ConfectionersRepository confectionersRepository;

  // endregion

  // region Lifecycle

  SearchConfectionersBloc(
      {required LatLong mapCenter,
      required this.confectionersRepository,
      required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState:
                SearchConfectionersState.initial(mapCenter: mapCenter),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<SearchConfectionersState> mapEventToState(
      SearchConfectionersEvent event) async* {
    if (event is SearchQueryChanged) {
      if (event.query.length > 2) {
        yield state.copy(loadingFirstPage: true, searchQuery: event.query);
        final recipes =
            await _getConfectionersFirstPage(searchQuery: event.query);
        yield state.copy(
          listItems: recipes,
          loadingFirstPage: false,
        );
      } else {
        yield state.copy(listItems: [], setSearchQueryToNull: true);
      }
    } else if (event is LoadNextPage) {
      final initialListItems = state.listItems;
      final liatItemsOnLoad = initialListItems + [ProgressIndicatorItem()];
      yield state.copy(loadingNextPage: true, listItems: liatItemsOnLoad);
      final recipesNextPage =
          await _getConfectionersNextPage(searchQuery: state.searchQuery);
      final updatedListItems = initialListItems + recipesNextPage;
      yield state.copy(loadingNextPage: false, listItems: updatedListItems);
    }
  }

  @override
  Stream<Transition<SearchConfectionersEvent, SearchConfectionersState>>
      transformEvents(
    Stream<SearchConfectionersEvent> events,
    TransitionFunction<SearchConfectionersEvent, SearchConfectionersState>
        transitionFn,
  ) {
    bool debouncedEventFilter(SearchConfectionersEvent event) {
      return event is SearchQueryChanged && event.query.isNotEmpty;
    }

    final nonDebounceStream =
        events.where((event) => !debouncedEventFilter(event));
    final debounceStream = events
        .where(debouncedEventFilter)
        .debounceTime(Duration(milliseconds: 1500));
    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transitionFn,
    );
  }

  // endregion

  // region Private methods

  Future<List<ConfectionerViewModel>> _getConfectionersFirstPage(
      {required String searchQuery}) async {
    List<ConfectionerShortResponse>? firstPageResponse;
    try {
      firstPageResponse = await confectionersRepository.getConfectioners(
        mapCenter: state.mapCenter,
        searchQuery: searchQuery,
      );
    } on Exception catch (e) {
      errorHandlingBloc.add(ExceptionRaised(e));
    }
    final result = firstPageResponse != null
        ? firstPageResponse.map(_mapConfectionerResponseToViewModel).toList()
        : <ConfectionerViewModel>[];
    return result;
  }

  Future<List<ConfectionerViewModel>> _getConfectionersNextPage(
      {String? searchQuery}) async {
    final lastItem = state.listItems
        .lastWhere((e) => e is ConfectionerViewModel) as ConfectionerViewModel;
    final lastId = lastItem.id;
    List<ConfectionerShortResponse> nextPageResponse;
    try {
      nextPageResponse = await confectionersRepository.getConfectioners(
        mapCenter: state.mapCenter,
        searchQuery: searchQuery,
        lastId: lastId,
      );
    } on Exception catch (e) {
      errorHandlingBloc.add(ExceptionRaised(e));
      nextPageResponse = [];
    }
    final result =
        nextPageResponse.map(_mapConfectionerResponseToViewModel).toList();
    return result;
  }

  ConfectionerViewModel _mapConfectionerResponseToViewModel(
          ConfectionerShortResponse response) =>
      ConfectionerViewModel(
        id: response.id,
        name: response.name,
        address: response.address,
        gender: response.gender,
        avatarUrl: response.avatarUrl,
        coordinate: response.coordinate,
        starType: response.starType,
        rating: response.rating,
      );

  // endregion
}
