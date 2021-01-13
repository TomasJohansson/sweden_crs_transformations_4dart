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
import './transformer.dart';

class TransFormStrategy_From_Sweref99OrRT90_to_WGS84_andThenToRealTarget extends TransformStrategy {
  // Precondition: sourceCoordinate must be CRS SWEREF99 or RT90
  
  @override
  CrsCoordinate transform(
    CrsCoordinate sourceCoordinate,
    CrsProjection targetCrsProjection
  ) {
    var wgs84coordinate = Transformer.transform(sourceCoordinate, CrsProjection.wgs84);
    return Transformer.transform(wgs84coordinate, targetCrsProjection);
  }
}
