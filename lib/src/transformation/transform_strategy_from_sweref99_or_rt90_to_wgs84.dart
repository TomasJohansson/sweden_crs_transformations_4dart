﻿/*
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
import './transform_strategy.dart';
import '../mighty_little_geodesy/gauss_kreuger.dart';
import '../mighty_little_geodesy/lat_lon.dart';

/// Intended to be an internal class, i.e. not exported from the library (i.e. in the file 'sweden_crs_transformations_4dart.dart')
class TransformStrategy_from_SWEREF99_or_RT90_to_WGS84 extends TransformStrategy {
  // Precondition: sourceCoordinate must be CRS SWEREF99 or RT90
  
  /// See the comment for the interface (abstract base class)
  @override
  CrsCoordinate transform(
    CrsCoordinate sourceCoordinate,
    CrsProjection targetCrsProjection
  ) {
    var gkProjection = GaussKreuger();
    gkProjection.swedish_params(sourceCoordinate.crsProjection);
    LatLon latLon = gkProjection.grid_to_geodetic(sourceCoordinate.yLatitude, sourceCoordinate.xLongitude);
    return CrsCoordinate.createCoordinate(targetCrsProjection, latLon.yLatitude, latLon.xLongitude);
  }
}
