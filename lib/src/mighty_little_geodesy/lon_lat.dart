/*
* Copyright (c) Tomas Johansson , http://www.programmerare.com
* The code in this library is licensed with MIT.
* The library is based on the C#.NET library 'sweden_crs_transformations_4net' (https://github.com/TomasJohansson/sweden_crs_transformations_4net)
* which in turn is based on 'MightyLittleGeodesy' (https://github.com/bjornsallarp/MightyLittleGeodesy/) 
* which is also released with MIT.
* For more information see the webpage below.
* https://github.com/TomasJohansson/sweden_crs_transformations_4dart
*/

// This class was not part of the original 'MightyLittleGeodesy'
// but the class 'GaussKreuger' has later been changed to return this 'LonLat' instead of array 'double[]'
class LonLat {
  double LongitudeX;
  double LatitudeY;
  
  LonLat(this.LongitudeX, this.LatitudeY);
}