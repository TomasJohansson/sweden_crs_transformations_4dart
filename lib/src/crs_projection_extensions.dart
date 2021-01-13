/*
* Copyright (c) Tomas Johansson , http://www.programmerare.com
* The code in this library is licensed with MIT.
* The library is based on the library 'MightyLittleGeodesy' (https://github.com/bjornsallarp/MightyLittleGeodesy/) 
* which is also released with MIT.
* For more information see the webpage below.
* https://github.com/TomasJohansson/sweden_crs_transformations
*/

/// <summary>
/// Extension methods for the enum CrsProjection.
/// See also <see cref="CrsProjection"/>
/// </summary>

import './crs_projection.dart';

class _CrsProjectionConstant {
  static const int _epsgForWgs84 = 4326;
  static const int _epsgForSweref99tm = 3006;

  // //private const int epsgLowerValueForSwerefLocal = 3007; // the NATIONAL sweref99TM has value 3006 as in the above constant
  // //private const int epsgUpperValueForSwerefLocal = 3018;
  static const int _epsgLowerValueForSweref = _epsgForSweref99tm;
  static const int _epsgUpperValueForSweref = 3018;

  static const int _epsgLowerValueForRT90 = 3019;
  static const int _epsgUpperValueForRT90 = 3024;

  // the swedish projections start at index 1 (in the enum _CrsProjection) with EPSG number 3006 (i.e. the difference is 3006-1)
  static const int _differenceBetweenEnumIndexAndEspgNumber = 3005;
}

extension CrsProjectionExtensions on CrsProjection {
  /// <summary>
  /// The EPSG number for the enum instance representing a coordinate reference system.
  /// The implementation is trivial but it is a convenience method that provides semantic 
  /// through the method name i.e. what the enum value represents 
  /// and it also lets the client code avoid to do the casting.
  /// </summary>
  /// <returns>
  /// An EPSG number.
  /// https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset
  /// </returns>
  int getEpsgNumber() {
    // the EPSG numbers have been used as the values in this enum
    if(index == 0) { // "index" here means "this.index" where "this"=an instance of CrsProjection
      return _CrsProjectionConstant._epsgForWgs84;
    }
    else {
      return index + _CrsProjectionConstant._differenceBetweenEnumIndexAndEspgNumber;
    }
  }

  /// <summary>
  /// True if the coordinate reference system is WGS84.
  /// </summary>
  bool isWgs84() { // this CrsProjection crsProjection
    return this == CrsProjection.wgs84;
  }
  
  /// <summary>
  /// True if the coordinate reference system is a version of SWEREF99.
  /// </summary>
  bool isSweref() {
    int epsgNumber = getEpsgNumber();
    return _CrsProjectionConstant._epsgLowerValueForSweref <= epsgNumber && epsgNumber <= _CrsProjectionConstant._epsgUpperValueForSweref;
  }

  /// <summary>
  /// True if the coordinate reference system is a version of RT90.
  /// </summary>
  bool isRT90() {
    int epsgNumber = getEpsgNumber();
    return _CrsProjectionConstant._epsgLowerValueForRT90 <= epsgNumber && epsgNumber <= _CrsProjectionConstant._epsgUpperValueForRT90;
  }  

  /// <summary>
  /// True if the coordinate reference system is a version of RT90.
  /// </summary>
  String getAsString() {
    String enumTypenameAndInstanceNameSeparatedWithDot = this.toString(); // something like "CrsProjection.sweref_99_18_00"
    int indexOfTheDot = enumTypenameAndInstanceNameSeparatedWithDot.indexOf('.');
    String instanceName = enumTypenameAndInstanceNameSeparatedWithDot.substring(indexOfTheDot + 1);
    // print("instanceName " + instanceName); // e.g. "sweref_99_18_00"
    return instanceName.toUpperCase(); // e.g. "SWEREF_99_18_00"
  }    
}