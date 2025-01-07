import 'judgment_event.dart';
import 'judgment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../managers/judgment_manager.dart';
import '../../models/judgment_model.dart';

class JudgmentBloc extends Bloc<JudgmentEvent, JudgmentState> {
  final JudgmentManager manager;

  JudgmentBloc({required this.manager}) : super(JudgmentInitial()) {
    on<JudgmentKeywordSearchEvent>((event, emit) async {
      emit(JudgmentLoading());
      try {
        final List<Judgment> judgments = await manager.fetchJudgmentsByKeyword(
          keyword: event.keyword,
          page: event.page,
          limit: event.limit,
        );
        emit(JudgmentsLoaded(judgments: judgments));
      } catch (e) {
        emit(JudgmentError(error: e.toString()));
      }
    });

    on<JudgmentViewEvent>((event, emit) async {
      emit(JudgmentLoading());
      try {
        final Judgment judgment = await manager.fetchJudgmentById(event.id);
        emit(JudgmentViewLoaded(judgment: judgment));
      } catch (e) {
        emit(JudgmentError(error: e.toString()));
      }
    });

    on<JudgmentAddFavoriteEvent>((event, emit) async {
      try {
        final result = await manager.addFavorite(
          judgmentId: event.JudgmentID,
        );
        if (result['success'] == true) {
          //Nothign
        } else {
          emit(JudgmentError(error: result['message']));
        }
      } catch (e) {
        emit(JudgmentError(error: e.toString()));
      }
    });

    on<JudgmentFetchAllFavoritesEvent>((event, emit) async {
  emit(JudgmentFavoritesLoading());
  try {
    final favorites = await manager.viewFavorites();
    emit(JudgmentFavoritesLoaded(judgments: favorites));
  } catch (error) {
    emit(JudgmentFavoritesError(error: error.toString()));
  }
});
  }
}


  // on<TransactionsFetchEvent>((event, emit) async {
  //   emit(TransactionsLoading());
  //   try {
  //     final transactions = await fetchTransactions();
  //     print("Transactions: $transactions");
  //     emit(TransactionsLoaded(transactions: transactions));
  //   } catch (e) {
  //     emit(TransactionsError(error: e.toString()));
  //   }
  // });

  // on<TransactionsErrorEvent>((event, emit) {
  //   emit(TransactionsError(error: event.error));
  // });
//   }
// }