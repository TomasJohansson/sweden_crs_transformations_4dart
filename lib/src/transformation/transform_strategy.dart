/*
* Copyright (c) Tomas Johansson , http://www.programmerare.com
* The code in this library is licensed with MIT.
* The library is based on the C#.NET library 'sweden_crs_transformations_4net' (https://github.com/TomasJohansson/sweden_crs_transformations_4net)
* which in turn is based on 'MightyLittleGeodesy' (https://github.com/bjornsallarp/MightyLittleGeodesy/) 
* which is also released with MIT.
* For more information see the webpage below.
* https://github.com/TomasJohansson/sweden_crs_transformations_4dart
*/

import '../crs_coordinate.dart';
import '../crs_projection.dart';

/// Intended to be an internal class, i.e. not exported from the library (i.e. in the file 'sweden_crs_transformations_4dart.dart')
abstract class TransformStrategy {
  CrsCoordinate transform(
    CrsCoordinate sourceCoordinate,
    CrsProjection targetCrsProjection
  );
}
