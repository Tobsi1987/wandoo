import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/environment/environment.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/flows/scent/sniff_out.dart';

final sniffOutProvider = Provider<SniffOut>(
  (ref) => SniffOut(
    mapData: ref.watch(mapDataSourceProvider),
    known: ref.watch(knownSegmentsRepositoryProvider),
    classify: ref.watch(classifySegmentsProvider),
    scents: ref.watch(scentRepositoryProvider),
    pick: ref.watch(pickScentProvider),
  ),
);
