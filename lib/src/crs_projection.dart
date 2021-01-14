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

/// Crs = Coordinate reference system.
/// 
/// The integer values for these enums are the EPSG numbers for the corresponding coordinate reference systems.
/// There are three kind of coordinate systems supported and defined in this enum type below:
///     WGS84
///     SWEREF99 (the new Swedish grid, 13 versions, one national grid and 12 local projection zones)
///     RT90 (the old Swedish grid, 6 local projection zones)
/// There are extensions methods for the enum which can be used to determine one of the above three types. 
/// See also [CrsProjectionExtensions]
/// 
/// Regarding the mentioned EPSG numbers (the enum values), at the links below you may find some more information about "EPSG".
/// https://en.wikipedia.org/wiki/EPSG_Geodetic_Parameter_Dataset
/// https://epsg.org
/// https://epsg.io
enum CrsProjection {

  // Note that Dart enums can not define values, but the values ("index" property) are instead 
  // enumerated, beginning with 0 for the first enum, and 1 for the second, and so on.
  // Therefore it is important to keep the order and be careful about changing the order.
  // The first enum below (with index 0) is wgs84 with EPSG 4326,
  // but then the rest of the enums (starting with index 1) represent EPSG 3006-3024
  // in a sequence, so therefore the EPSG number can be determined from an extension method
  // by adding 3005 to the index value (except for the first wgs84 enum)
  
  /// https://epsg.org/crs_4326/WGS-84.html
  /// https://epsg.io/4326
  /// https://spatialreference.org/ref/epsg/4326/
  /// https://en.wikipedia.org/wiki/World_Geodetic_System#A_new_World_Geodetic_System:_WGS_84
  wgs84, //  = 4326,

  /// "SWEREF 99 TM" (with EPSG code 3006) is the new national projection.
  /// https://www.lantmateriet.se/sv/Kartor-och-geografisk-information/gps-geodesi-och-swepos/referenssystem/tvadimensionella-system/sweref-99-projektioner/
  /// https://epsg.org/crs_3006/SWEREF99-TM.html
  /// https://epsg.io/3006
  /// https://spatialreference.org/ref/epsg/3006/
  sweref_99_tm, // = 3006, // national sweref99 CRS

  // local sweref99 systems (the new swedish national system):
  sweref_99_12_00, // = 3007,
  sweref_99_13_30, // = 3008,
  sweref_99_15_00, // = 3009,
  sweref_99_16_30, // = 3010,
  sweref_99_18_00, // = 3011,
  sweref_99_14_15, // = 3012,
  sweref_99_15_45, // = 3013,
  sweref_99_17_15, // = 3014,
  sweref_99_18_45, // = 3015,
  sweref_99_20_15, // = 3016,
  sweref_99_21_45, // = 3017,
  sweref_99_23_15, // = 3018,


  // local RT90 systems (the old swedish national system):
  rt90_7_5_gon_v, // = 3019,
  rt90_5_0_gon_v, // = 3020,

  /// https://epsg.org/crs_3021/RT90-2-5-gon-V.html
  /// https://epsg.io/3021
  /// https://spatialreference.org/ref/epsg/3021/
  rt90_2_5_gon_v, // = 3021,

  rt90_0_0_gon_v, // = 3022,
  rt90_2_5_gon_o, // = 3023,
  rt90_5_0_gon_o  // = 3024
}