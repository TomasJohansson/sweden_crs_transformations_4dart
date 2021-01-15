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

import './crs_projection.dart';
import './crs_projection_extensions.dart';
import './crs_projection_factory.dart';
import './transformation/transformer.dart';

/// Used for supporting a custom toString implementation
typedef CrsCoordinateToString = String Function(CrsCoordinate crsCoordinate);


/// Coordinate, defined by the three parameters for the factory methods.
class CrsCoordinate {

  /// The coordinate reference system that defines the location together with the other two properties (xLongitude and yLatitude).
  final CrsProjection crsProjection;

  /// The coordinate value representing the longitude or X or Easting.
  final double xLongitude;

  /// The coordinate value representing the latitude or Y or Northing.
  final double yLatitude;

  // -----------------------------------------------
  // Three constructors (one private, and two public factory constructors):

  /// Private constructor. Client code must instead use the factory constructors.
  const CrsCoordinate._privateConstructor(
    this.crsProjection,
    this.yLatitude,    
    this.xLongitude
  );

  /// Factory constructor for creating an instance.
  /// [epsgNumber] represents the coordinate reference system that defines the location together with the other two parameters.
  /// [xLongitude] is the coordinate position value representing the longitude or X or Easting
  /// [yLatitude] is the coordinate position value representing the latitude or Y or Northing
  factory CrsCoordinate.createCoordinateByEpsgNumber(
    int epsgNumber,
    double yLatitude,    
    double xLongitude
  ) {
    CrsProjection crsProjection = CrsProjectionFactory.getCrsProjectionByEpsgNumber(epsgNumber);
    return CrsCoordinate.createCoordinate(crsProjection, yLatitude, xLongitude);
  }

  /// Factory constructor for creating an instance.
  /// [crsProjection] represents the coordinate reference system that defines the location together with the other two parameters.
  /// [xLongitude] is the coordinate position value representing the longitude or X or Easting
  /// [yLatitude] is the coordinate position value representing the latitude or Y or Northing
  /// See also [CrsProjection]
  factory CrsCoordinate.createCoordinate(
    CrsProjection crsProjection,
    double yLatitude,    
    double xLongitude
  ) {
    return CrsCoordinate._privateConstructor(crsProjection, yLatitude, xLongitude);
  }
  // -----------------------------------------------


  /// Transforms the coordinate to another coordinate reference system.
  /// [targetCrsProjection] represents the coordinate reference system that you want to transform to.
  CrsCoordinate transform(CrsProjection targetCrsProjection) {
    return Transformer.transform(this, targetCrsProjection);
  }

  /// Transforms the coordinate to another coordinate reference system.
  /// [targetEpsgNumber] represents the coordinate reference system that you want to transform to.
  CrsCoordinate transformByEpsgNumber(int targetEpsgNumber) {
    CrsProjection targetCrsProjection = CrsProjectionFactory.getCrsProjectionByEpsgNumber(targetEpsgNumber);
    return transform(targetCrsProjection);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Checks whether two references are to the same object.
    return (other is CrsCoordinate) && 
        crsProjection == other.crsProjection &&
        xLongitude == other.xLongitude &&
        yLatitude == other.yLatitude;
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
  /// "CrsCoordinate [ Y: 6579457.649 , X: 153369.673 , CRS: SWEREF_99_18_00 ]"
  /// "CrsCoordinate [ Latitude: 59.330231 , Longitude: 18.059196 , CRS: WGS84 ]"
  static String defaultToStringImplementation(CrsCoordinate coordinate) {
    bool isWgs84 =  coordinate.crsProjection.isWgs84();
    String yOrLatitude = isWgs84 ? 'Latitude' : 'Y';
    String xOrLongitude = isWgs84 ? 'Longitude' : 'X';
    return 'CrsCoordinate [ ${yOrLatitude}: ${coordinate.yLatitude} , ${xOrLongitude}: ${coordinate.xLongitude} , CRS: ${coordinate.crsProjection.getAsString()} ]';
  }

  /// Sets a custom method to be used for rendering an instance when the 'toString' method is used.
  static void setToStringImplementation(CrsCoordinateToString toStringImplementation) {
    _toStringImplementation = toStringImplementation;
  }  

  /// Sets the default method to be used for rendering an instance when the 'ToString' method is used.
  static void setToStringImplementationDefault() { 
    _toStringImplementation = defaultToStringImplementation;
  }



  // -----------------------------------------------
  // Deprecated methods:

  /// Deprecated: Use [createCoordinateByEpsgNumber] instead i.e. the same name but lowercased first letter
  @deprecated
  static CrsCoordinate CreateCoordinateByEpsgNumber(
    int epsgNumber,
    double yLatitude,    
    double xLongitude
  ) {
    return CrsCoordinate.createCoordinateByEpsgNumber(epsgNumber, yLatitude, xLongitude);
  }  

  /// Deprecated: Use [createCoordinate] instead i.e. the same name but lowercased first letter
  @deprecated
  static CrsCoordinate CreateCoordinate(
    CrsProjection crsProjection,
    double yLatitude,    
    double xLongitude
  ) {
    return CrsCoordinate.createCoordinate(crsProjection, yLatitude, xLongitude);
  }
  // -----------------------------------------------
}