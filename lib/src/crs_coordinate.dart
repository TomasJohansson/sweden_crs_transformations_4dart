// dart lib/src/crs_coordinate.dart
/*
* Copyright (c) Tomas Johansson , http://www.programmerare.com
* The code in this library is licensed with MIT.
* The library is based on the library 'MightyLittleGeodesy' (https://github.com/bjornsallarp/MightyLittleGeodesy/) 
* which is also released with MIT.
* For more information see the webpage below.
* https://github.com/TomasJohansson/sweden_crs_transformations
*/

/// <summary>
/// Coordinate, defined by the three parameters for the factory methods.
/// </summary>
/// 
import './crs_projection.dart';
import './crs_projection_extensions.dart';
import './crs_projection_factory.dart';
import './transformation/transformer.dart';

typedef CrsCoordinateToString = String Function(CrsCoordinate crsCoordinate); // used for supporting a custom toString implementation

class CrsCoordinate {

  /// <summary>
  /// The coordinate reference system that defines the location together with the other two properties (LongitudeX and LatitudeY).
  /// </summary>
  final CrsProjection crsProjection;

  /// <summary>
  /// The coordinate value representing the longitude or X or Easting.
  /// </summary>    
  final double xLongitude;

  /// <summary>
  /// The coordinate value representing the latitude or Y or Northing.
  /// </summary>
  final double yLatitude;

  /// <summary>
  /// Private constructor. Client code must instead use the public factory methods.
  /// </summary>
  CrsCoordinate._privateConstructor(
    this.crsProjection,
    this.xLongitude,
    this.yLatitude
  );

  /// <summary>
  /// Transforms the coordinate to another coordinate reference system
  /// </summary>
  /// <param name="targetCrsProjection">the coordinate reference system that you want to transform to</param>        
  CrsCoordinate transform(CrsProjection targetCrsProjection) {
    return Transformer.transform(this, targetCrsProjection);
  }

  /// <summary>
  /// Transforms the coordinate to another coordinate reference system
  /// </summary>
  /// <param name="targetEpsgNumber">the coordinate reference system that you want to transform to</param>        
  CrsCoordinate transformByEpsgNumber(int targetEpsgNumber) {
    CrsProjection targetCrsProjection = CrsProjectionFactory.getCrsProjectionByEpsgNumber(targetEpsgNumber);
    return this.transform(targetCrsProjection);
  }

  /// <summary>
  /// Factory method for creating an instance.
  /// </summary>
  /// <param name="epsgNumber">represents the coordinate reference system that defines the location together with the other two parameters</param>
  /// <param name="xLongitude">the coordinate position value representing the longitude or X or Easting</param>
  /// <param name="yLatitude">the coordinate position value representing the latitude or Y or Northing</param>
  static CrsCoordinate CreateCoordinateByEpsgNumber(
    int epsgNumber,
    double xLongitude,
    double yLatitude
  ) {
    CrsProjection crsProjection = CrsProjectionFactory.getCrsProjectionByEpsgNumber(epsgNumber);
    return CreateCoordinate(crsProjection, xLongitude, yLatitude);
  }

  /// <summary>
  /// Factory method for creating an instance.
  /// See also <see cref="CrsProjection"/>
  /// </summary>
  /// <param name="crsProjection">represents the coordinate reference system that defines the location together with the other two parameters</param>
  /// <param name="xLongitude">the coordinate position value representing the longitude or X or Easting</param>
  /// <param name="yLatitude">the coordinate position value representing the latitude or Y or Northing</param>
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


  /// See the method 'defaultToStringImplementation'
  @override
  String toString() {
    return _toStringImplementation(this);
  }

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

  /// <summary>
  /// Sets a custom method to be used for rendering an instance when the 'ToString' method is used.
  /// </summary>
  static void setToStringImplementation(CrsCoordinateToString toStringImplementation) {
    _toStringImplementation = toStringImplementation;
  }  

  /// <summary>
  /// Sets the default method to be used for rendering an instance when the 'ToString' method is used.
  /// </summary>
  static void setToStringImplementationDefault() { 
    _toStringImplementation = defaultToStringImplementation;
  }

}