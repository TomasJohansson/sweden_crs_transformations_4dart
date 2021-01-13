﻿// dart lib/src/transformation/transformer.dart
/*
* Copyright (c) Tomas Johansson , http://www.programmerare.com
* The code in this library is licensed with MIT.
* The library is based on the library 'MightyLittleGeodesy' (https://github.com/bjornsallarp/MightyLittleGeodesy/) 
* which is also released with MIT.
* For more information see the webpage below.
* https://github.com/TomasJohansson/sweden_crs_transformations
*/

import '../crs_coordinate.dart';
import '../crs_projection.dart';
import '../crs_projection_extensions.dart';
import './transform_strategy.dart';
import './transform_strategy_from_sweref99_or_rt90_to_wgs84.dart';
import './transform_strategy_from_sweref99_or_rt90_to_wgs84_and_then_to_real_target.dart';
import './transform_strategy_from_wgs84_to_sweref99_or_rt90.dart';

class Transformer {

  // Implementations of transformations from WGS84:
  static TransformStrategy _transformStrategy_from_WGS84_to_SWEREF99_or_RT90 = TransformStrategy_from_WGS84_to_SWEREF99_or_RT90();

  // Implementations of transformations to WGS84:
  static TransformStrategy _transformStrategy_from_SWEREF99_or_RT90_to_WGS84 = TransformStrategy_from_SWEREF99_or_RT90_to_WGS84();

  // Implementation first transforming to WGS84 and then to the real target:
  static TransformStrategy _transFormStrategy_From_Sweref99OrRT90_to_WGS84_andThenToRealTarget  = TransFormStrategy_From_Sweref99OrRT90_to_WGS84_andThenToRealTarget();

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

    //throw new ArgumentError(string.Format("Unhandled source/target projection transformation: {0} ==> {1}", sourceCoordinate.CrsProjection, targetCrsProjection));
    throw new ArgumentError("todo");
  }

}