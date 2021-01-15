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

/// Extension methods for the enum CrsProjection.
/// See also [CrsProjection]
extension CrsProjectionExtensions on CrsProjection {

  /// Returns an EPSG number for the enum instance representing a coordinate reference system.
  /// https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset
  int getEpsgNumber() {
    // see the comments within the 'enum CrsProjection' to understand the implementation below
    if(index == 0) { // "index" here means "this.index" where "this"=an instance of CrsProjection
      return _CrsProjectionConstant._epsgForWgs84;
    }
    else {
      return index + _CrsProjectionConstant._differenceBetweenEnumIndexAndEspgNumber;
    }
  }

  /// True if the coordinate reference system is WGS84.
  bool isWgs84() { // this CrsProjection crsProjection
    return this == CrsProjection.wgs84;
  }
  
  /// True if the coordinate reference system is a version of SWEREF99.
  bool isSweref() {
    int epsgNumber = getEpsgNumber();
    return _CrsProjectionConstant._epsgLowerValueForSweref <= epsgNumber && epsgNumber <= _CrsProjectionConstant._epsgUpperValueForSweref;
  }

  /// True if the coordinate reference system is a version of RT90.
  bool isRT90() {
    int epsgNumber = getEpsgNumber();
    return _CrsProjectionConstant._epsgLowerValueForRT90 <= epsgNumber && epsgNumber <= _CrsProjectionConstant._epsgUpperValueForRT90;
  }  

  /// A string representation of an enum instance.
  /// The string returned is the same as the name but uppercased, e.g. wgs84 ==> "WGS84"
  String getAsString() {
    String enumTypenameAndInstanceNameSeparatedWithDot = toString(); // something like "CrsProjection.sweref_99_18_00"
    int indexOfTheDot = enumTypenameAndInstanceNameSeparatedWithDot.indexOf('.');
    String instanceName = enumTypenameAndInstanceNameSeparatedWithDot.substring(indexOfTheDot + 1);
    // print("instanceName " + instanceName); // e.g. "sweref_99_18_00"
    return instanceName.toUpperCase(); // e.g. "SWEREF_99_18_00"
  }    
}

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