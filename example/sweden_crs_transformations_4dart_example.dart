import 'package:sweden_crs_transformations_4dart/sweden_crs_transformations_4dart.dart';

void main() {
  // The location of Stockholm Central Station, according to Eniro:
  // https://kartor.eniro.se/m/XRCfh
      //WGS84 decimal (lat, lon)        59.330231, 18.059196
      //RT90 (northing, easting)        6580994, 1628294
      //SWEREF99 TM (northing, easting) 6580822, 674032
  const stockholmCentralStation_WGS84_latitude = 59.330231;
  const stockholmCentralStation_WGS84_longitude = 18.059196;

  final CrsCoordinate stockholmWGS84 = CrsCoordinate.createCoordinate(
    CrsProjection.wgs84,
    stockholmCentralStation_WGS84_latitude,      
    stockholmCentralStation_WGS84_longitude
  );

  final CrsCoordinate stockholmSweref99tm = stockholmWGS84.transform(CrsProjection.sweref_99_tm);
  print('stockholmSweref99tm X: ${stockholmSweref99tm.xLongitude}');
  print('stockholmSweref99tm Y: ${stockholmSweref99tm.yLatitude}');
  print('stockholmSweref99tm ToString: ${stockholmSweref99tm.toString()}');
  // Output from the above:
  // stockholmSweref99tm X: 674032.357
  // stockholmSweref99tm Y: 6580821.991
  // stockholmSweref99tm ToString: CrsCoordinate [ Y: 6580821.991 , X: 674032.357 , CRS: SWEREF_99_TM ]

  final List<CrsProjection> allProjections = CrsProjectionFactory.getAllCrsProjections();
  for(final crsProjection in allProjections) {
    print(stockholmWGS84.transform(crsProjection));
  }
  // Output from the above loop:
  // CrsCoordinate [ Latitude: 59.330231 , Longitude: 18.059196 , CRS: WGS84 ]
  // CrsCoordinate [ Y: 6580821.991 , X: 674032.357 , CRS: SWEREF_99_TM ]
  // CrsCoordinate [ Y: 6595151.116 , X: 494604.69 , CRS: SWEREF_99_12_00 ]
  // CrsCoordinate [ Y: 6588340.147 , X: 409396.217 , CRS: SWEREF_99_13_30 ]
  // CrsCoordinate [ Y: 6583455.373 , X: 324101.998 , CRS: SWEREF_99_15_00 ]
  // CrsCoordinate [ Y: 6580494.921 , X: 238750.424 , CRS: SWEREF_99_16_30 ]
  // CrsCoordinate [ Y: 6579457.649 , X: 153369.673 , CRS: SWEREF_99_18_00 ]
  // CrsCoordinate [ Y: 6585657.12 , X: 366758.045 , CRS: SWEREF_99_14_15 ]
  // CrsCoordinate [ Y: 6581734.696 , X: 281431.616 , CRS: SWEREF_99_15_45 ]
  // CrsCoordinate [ Y: 6579735.93 , X: 196061.94 , CRS: SWEREF_99_17_15 ]
  // CrsCoordinate [ Y: 6579660.051 , X: 110677.129 , CRS: SWEREF_99_18_45 ]
  // CrsCoordinate [ Y: 6581507.028 , X: 25305.238 , CRS: SWEREF_99_20_15 ]
  // CrsCoordinate [ Y: 6585277.577 , X: -60025.629 , CRS: SWEREF_99_21_45 ]
  // CrsCoordinate [ Y: 6590973.148 , X: -145287.219 , CRS: SWEREF_99_23_15 ]
  // CrsCoordinate [ Y: 6598325.639 , X: 1884004.1 , CRS: RT90_7_5_GON_V ]
  // CrsCoordinate [ Y: 6587493.237 , X: 1756244.287 , CRS: RT90_5_0_GON_V ]
  // CrsCoordinate [ Y: 6580994.18 , X: 1628293.886 , CRS: RT90_2_5_GON_V ]
  // CrsCoordinate [ Y: 6578822.84 , X: 1500248.374 , CRS: RT90_0_0_GON_V ]
  // CrsCoordinate [ Y: 6580977.349 , X: 1372202.721 , CRS: RT90_2_5_GON_O ]
  // CrsCoordinate [ Y: 6587459.595 , X: 1244251.702 , CRS: RT90_5_0_GON_O ]
}