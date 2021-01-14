/*
* Copyright (c) Tomas Johansson , http://www.programmerare.com
* The code in this library is licensed with MIT.
* The library is based on the C#.NET library 'sweden_crs_transformations_4net' (https://github.com/TomasJohansson/sweden_crs_transformations_4net)
* which in turn is based on 'MightyLittleGeodesy' (https://github.com/bjornsallarp/MightyLittleGeodesy/) 
* which is also released with MIT.
* License information about 'sweden_crs_transformations_4dart' and 'MightyLittleGeodesy':
* https://github.com/TomasJohansson/sweden_crs_transformations_4dart/blob/dart_SwedenCrsTransformations/LICENSE
* For more information see the webpage below.
* https://github.com/TomasJohansson/sweden_crs_transformations_4dart
*/

import '../crs_coordinate.dart';
import '../crs_projection.dart';
import '../crs_projection_extensions.dart';
import './transform_strategy.dart';
import './transform_strategy_from_sweref99_or_rt90_to_wgs84.dart';
import './transform_strategy_from_sweref99_or_rt90_to_wgs84_and_then_to_real_target.dart';
import './transform_strategy_from_wgs84_to_sweref99_or_rt90.dart';

/// Intended to be an internal class, i.e. not exported from the library (i.e. in the file 'sweden_crs_transformations_4dart.dart')
class Transformer {

  // Implementations of transformations from WGS84:
  static final TransformStrategy _transformStrategy_from_WGS84_to_SWEREF99_or_RT90 = TransformStrategy_from_WGS84_to_SWEREF99_or_RT90();

  // Implementations of transformations to WGS84:
  static final TransformStrategy _transformStrategy_from_SWEREF99_or_RT90_to_WGS84 = TransformStrategy_from_SWEREF99_or_RT90_to_WGS84();

  // Implementation first transforming to WGS84 and then to the real target:
  static final TransformStrategy _transFormStrategy_From_Sweref99OrRT90_to_WGS84_andThenToRealTarget  = TransFormStrategy_From_Sweref99OrRT90_to_WGS84_andThenToRealTarget();

  /// Transforms a [sourceCoordinate] (which includes the coordinate reference system as a property)
  /// to a coordinate in another coordinate reference system i.e. the [targetCrsProjection]
  static CrsCoordinate transform(CrsCoordinate sourceCoordinate, CrsProjection targetCrsProjection) {
    if(sourceCoordinate.crsProjection == targetCrsProjection) return sourceCoordinate;

    TransformStrategy _transFormStrategy = null;

    // Transform FROM wgs84:
    if(
      sourceCoordinate.crsProjection.isWgs84()
      &&
      ( targetCrsProjection.isSweref() || targetCrsProjection.isRT90() )
    ) {
      _transFormStrategy = _transformStrategy_from_WGS84_to_SWEREF99_or_RT90;
    }

    // Transform TO wgs84:
    else if(
      targetCrsProjection.isWgs84()
      &&
      ( sourceCoordinate.crsProjection.isSweref() || sourceCoordinate.crsProjection.isRT90() )
    ) {
      _transFormStrategy = _transformStrategy_from_SWEREF99_or_RT90_to_WGS84;
    }

    // Transform between two non-wgs84:
    else if(
      ( sourceCoordinate.crsProjection.isSweref() || sourceCoordinate.crsProjection.isRT90() )
      &&
      ( targetCrsProjection.isSweref() || targetCrsProjection.isRT90() )
    ) {
      // the only direct transform supported is to/from WGS84, so therefore first transform to wgs84
      _transFormStrategy = _transFormStrategy_From_Sweref99OrRT90_to_WGS84_andThenToRealTarget;
    }

    if(_transFormStrategy != null) {
      return _transFormStrategy.transform(sourceCoordinate, targetCrsProjection);
    }

    throw new ArgumentError("Unhandled source/target projection transformation: ${sourceCoordinate.crsProjection} ==> ${targetCrsProjection}");
  }

}