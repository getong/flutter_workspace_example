import 'package:widget_layout_example2/features/squadron/domain/entities/squadron_models.dart';

abstract interface class SquadronRepository {
  Future<SquadronRunReport> runCpuBatch(List<SquadronWorkItem> items);
}
