﻿/*
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

/// Helper class for the 'GaussKreuger' class.
/// This class was not part of the original 'MightyLittleGeodesy'
/// but the class 'GaussKreuger' has later been changed to return this 'LatLon' instead of array 'double[]'
class LatLon {
  double xLongitude;
  double yLatitude;
  
  LatLon(this.yLatitude, this.xLongitude);
}