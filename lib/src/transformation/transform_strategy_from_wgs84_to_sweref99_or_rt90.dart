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
import './transform_strategy.dart';
import '../mighty_little_geodesy/gauss_kreuger.dart';
import '../mighty_little_geodesy/lon_lat.dart';

class TransformStrategy_from_WGS84_to_SWEREF99_or_RT90 extends TransformStrategy {
  // Precondition: sourceCoordinate must be CRS WGS84
  
  @override
  CrsCoordinate transform(
    CrsCoordinate sourceCoordinate,
    CrsProjection targetCrsProjection
  ) {
    var gkProjection = GaussKreuger();
    gkProjection.swedish_params(targetCrsProjection);
    LonLat lonLat = gkProjection.geodetic_to_grid(sourceCoordinate.yLatitude, sourceCoordinate.xLongitude);
    return CrsCoordinate.CreateCoordinate(targetCrsProjection, lonLat.LongitudeX, lonLat.LatitudeY);
  }
}
