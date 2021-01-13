/*
* Copyright (c) Tomas Johansson , http://www.programmerare.com
* The code in this library is licensed with MIT.
* The library is based on the C#.NET library 'sweden_crs_transformations_4net' (https://github.com/TomasJohansson/sweden_crs_transformations_4net)
* which in turn is based on 'MightyLittleGeodesy' (https://github.com/bjornsallarp/MightyLittleGeodesy/) 
* which is also released with MIT.
* For more information see the webpage below.
* https://github.com/TomasJohansson/sweden_crs_transformations_4dart
*/

import './crs_projection.dart';
import './crs_projection_extensions.dart';
import './crs_projection_factory.dart';
import './transformation/transformer.dart';

/// Used for supporting a custom toString implementation
typedef CrsCoordinateToString = String Function(CrsCoordinate crsCoordinate);


/// Coordinate, defined by the three parameters for the factory methods.
class CrsCoordinate {

  /// The coordinate reference system that defines the location together with the other two properties (LongitudeX and LatitudeY).
  final CrsProjection crsProjection;

  /// The coordinate value representing the longitude or X or Easting.
  final double xLongitude;

  /// The coordinate value representing the latitude or Y or Northing.
  final double yLatitude;

  /// Private constructor. Client code must instead use the public factory methods.
  CrsCoordinate._privateConstructor(
    this.crsProjection,
    this.xLongitude,
    this.yLatitude
  );

  /// Transforms the coordinate to another coordinate reference system.
  /// [targetCrsProjection] represents the coordinate reference system that you want to transform to.
  CrsCoordinate transform(CrsProjection targetCrsProjection) {
    return Transformer.transform(this, targetCrsProjection);
  }

  /// Transforms the coordinate to another coordinate reference system.
  /// [targetEpsgNumber] represents the coordinate reference system that you want to transform to.
  CrsCoordinate transformByEpsgNumber(int targetEpsgNumber) {
    CrsProjection targetCrsProjection = CrsProjectionFactory.getCrsProjectionByEpsgNumber(targetEpsgNumber);
    return this.transform(targetCrsProjection);
  }

  /// Factory method for creating an instance.
  /// [epsgNumber] represents the coordinate reference system that defines the location together with the other two parameters.
  /// [xLongitude] is the coordinate position value representing the longitude or X or Easting
  /// [yLatitude] is the coordinate position value representing the latitude or Y or Northing
  static CrsCoordinate CreateCoordinateByEpsgNumber(
    int epsgNumber,
    double xLongitude,
    double yLatitude
  ) {
    CrsProjection crsProjection = CrsProjectionFactory.getCrsProjectionByEpsgNumber(epsgNumber);
    return CreateCoordinate(crsProjection, xLongitude, yLatitude);
  }

  /// Factory method for creating an instance.
  /// [crsProjection] represents the coordinate reference system that defines the location together with the other two parameters.
  /// [xLongitude] is the coordinate position value representing the longitude or X or Easting
  /// [yLatitude] is the coordinate position value representing the latitude or Y or Northing
  /// See also [CrsProjection]
  static CrsCoordinate CreateCoordinate(
    CrsProjection crsProjection,
    double xLongitude,
    double yLatitude
  ) {
    return CrsCoordinate._privateConstructor(crsProjection, xLongitude, yLatitude);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Checks whether two references are to the same object.
    if(other is CrsCoordinate) {
      return other != null &&
        this.crsProjection == other.crsProjection &&
        this.xLongitude == other.xLongitude &&
        this.yLatitude == other.yLatitude;
    }
    return true;
  }
  // Regarding the missing (i.e. not implemented or overridden here) method "!=" it is "just syntactic sugar.
  //  For example, the expression e1 != e2 is syntactic sugar for !(e1 == e2).""
  // quoted from https://dart.dev/guides/language/language-tour#methods

  @override
  int get hashCode {
    var result = xLongitude.hashCode;
    result = 31 * result + yLatitude.hashCode;
    result = 31 * result + crsProjection.hashCode;
    return result;
  }  


  /// Returns a string representation of the object.
  /// See also the method [defaultToStringImplementation] or the type [CrsCoordinateToString] 
  /// and the method [setToStringImplementation] if you want to change to a custom implementation of toString.
  @override
  String toString() {
    return _toStringImplementation(this);
  }


  /// See also [CrsCoordinateToString]
  static CrsCoordinateToString _toStringImplementation = defaultToStringImplementation;

  /// Two examples of the string that can be returned:
  /// "CrsCoordinate [ X: 153369.673 , Y: 6579457.649 , CRS: SWEREF_99_18_00 ]"
  /// "CrsCoordinate [ Longitude: 18.059196 , Latitude: 59.330231 , CRS: WGS84 ]"
  static String defaultToStringImplementation(CrsCoordinate coordinate) {
    bool isWgs84 =  coordinate.crsProjection.isWgs84();
    String xOrLongitude = isWgs84 ? "Longitude" : "X";
    String yOrLatitude = isWgs84 ? "Latitude" : "Y";    
    return "CrsCoordinate [ ${xOrLongitude}: ${coordinate.xLongitude} , ${yOrLatitude}: ${coordinate.yLatitude} , CRS: ${coordinate.crsProjection.getAsString()} ]";
  }

  /// Sets a custom method to be used for rendering an instance when the 'toString' method is used.
  static void setToStringImplementation(CrsCoordinateToString toStringImplementation) {
    _toStringImplementation = toStringImplementation;
  }  

  /// Sets the default method to be used for rendering an instance when the 'ToString' method is used.
  static void setToStringImplementationDefault() { 
    _toStringImplementation = defaultToStringImplementation;
  }

}