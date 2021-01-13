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

abstract class TransformStrategy {
  CrsCoordinate transform(
    CrsCoordinate sourceCoordinate,
    CrsProjection targetCrsProjection
  );
}
