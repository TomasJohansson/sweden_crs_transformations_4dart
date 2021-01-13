/*
* Copyright (c) Tomas Johansson , http://www.programmerare.com
* The code in this library is licensed with MIT.
* The library is based on the library 'MightyLittleGeodesy' (https://github.com/bjornsallarp/MightyLittleGeodesy/) 
* which is also released with MIT.
* For more information see the webpage below.
* https://github.com/TomasJohansson/sweden_crs_transformations
*/

/// <summary>
/// Class with methods for getting all projections, and for getting one projection by its EPSG number.
/// (since such custom methods can not be located within the CrsProjection enum type itself)
/// </summary>
/// See also <see cref="CrsProjection"/>

import 'crs_projection.dart';
import 'crs_projection_extensions.dart';

class CrsProjectionFactory {

  /// <summary>
  /// Factory method creating an enum 'CrsProjection' by its number (EPSG) value.
  /// </summary>
  /// <param name="epsg">
  /// An EPSG number.
  /// https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset
  /// https://epsg.org
  /// https://epsg.io
  /// </param>
  /// See also <see cref="CrsProjection"/>        
  static CrsProjection getCrsProjectionByEpsgNumber(int epsg) {
    var values = getAllCrsProjections();
    for(CrsProjection crsProjection in values) {
      if(crsProjection.getEpsgNumber() == epsg) {
        return crsProjection;
      }
    }
    throw ArgumentError("Could not find CrsProjection for EPSG " + epsg.toString()); // https://api.dart.dev/stable/2.10.4/dart-core/ArgumentError-class.html
  }

  /// <summary>
  /// Convenience method for retrieving all the projections in a List.
  /// </summary>
  static List<CrsProjection> getAllCrsProjections() {
    // return ((CrsProjection[])Enum.GetValues(typeof(CrsProjection))).ToList(); // C#.NET
    // this library is ported from C#.NET which implemented this method as the above line but with Dart it is as simple as the line below
    return CrsProjection.values;
  }
}
