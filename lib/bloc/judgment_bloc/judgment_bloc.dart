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