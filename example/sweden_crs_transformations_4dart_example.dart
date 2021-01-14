import 'package:sweden_crs_transformations_4dart/sweden_crs_transformations_4dart.dart';

void main() {
    // The location of Stockholm Central Station, according to Eniro:
    // https://kartor.eniro.se/m/XRCfh
        //WGS84 decimal (lat, lon)        59.330231, 18.059196
        //RT90 (northing, easting)        6580994, 1628294
        //SWEREF99 TM (northing, easting) 6580822, 674032
    const stockholmCentralStation_WGS84_latitude = 59.330231;
    const stockholmCentralStation_WGS84_longitude = 18.059196;

    final CrsCoordinate stockholmWGS84 = CrsCoordinate.CreateCoordinate(
      CrsProjection.wgs84,
      stockholmCentralStation_WGS84_longitude,
      stockholmCentralStation_WGS84_latitude
    );

    final CrsCoordinate stockholmSweref99tm = stockholmWGS84.transform(CrsProjection.sweref_99_tm);
    print('stockholmSweref99tm X: ${stockholmSweref99tm.xLongitude}');
    print('stockholmSweref99tm Y: ${stockholmSweref99tm.yLatitude}');
    print('stockholmSweref99tm ToString: ${stockholmSweref99tm.toString()}');
    // Output from the above:
    // stockholmSweref99tm X: 674032.357
    // stockholmSweref99tm Y: 6580821.991
    // stockholmSweref99tm 'ToString': CrsCoordinate [ X: 674032.357 , Y: 6580821.991 , CRS: SWEREF_99_TM ]

    final List<CrsProjection> allProjections = CrsProjectionFactory.getAllCrsProjections();
    for(final crsProjection in allProjections) {
      print(stockholmWGS84.transform(crsProjection));
    }
    // Output from the above loop:
    // CrsCoordinate [ Longitude: 18.059196 , Latitude: 59.330231 , CRS: WGS84 ]
    // CrsCoordinate [ X: 674032.357 , Y: 6580821.991 , CRS: SWEREF_99_TM ]
    // CrsCoordinate [ X: 494604.69 , Y: 6595151.116 , CRS: SWEREF_99_12_00 ]
    // CrsCoordinate [ X: 409396.217 , Y: 6588340.147 , CRS: SWEREF_99_13_30 ]
    // CrsCoordinate [ X: 324101.998 , Y: 6583455.373 , CRS: SWEREF_99_15_00 ]
    // CrsCoordinate [ X: 238750.424 , Y: 6580494.921 , CRS: SWEREF_99_16_30 ]
    // CrsCoordinate [ X: 153369.673 , Y: 6579457.649 , CRS: SWEREF_99_18_00 ]
    // CrsCoordinate [ X: 366758.045 , Y: 6585657.12 , CRS: SWEREF_99_14_15 ]
    // CrsCoordinate [ X: 281431.616 , Y: 6581734.696 , CRS: SWEREF_99_15_45 ]
    // CrsCoordinate [ X: 196061.94 , Y: 6579735.93 , CRS: SWEREF_99_17_15 ]
    // CrsCoordinate [ X: 110677.129 , Y: 6579660.051 , CRS: SWEREF_99_18_45 ]
    // CrsCoordinate [ X: 25305.238 , Y: 6581507.028 , CRS: SWEREF_99_20_15 ]
    // CrsCoordinate [ X: -60025.629 , Y: 6585277.577 , CRS: SWEREF_99_21_45 ]
    // CrsCoordinate [ X: -145287.219 , Y: 6590973.148 , CRS: SWEREF_99_23_15 ]
    // CrsCoordinate [ X: 1884004.1 , Y: 6598325.639 , CRS: RT90_7_5_GON_V ]
    // CrsCoordinate [ X: 1756244.287 , Y: 6587493.237 , CRS: RT90_5_0_GON_V ]
    // CrsCoordinate [ X: 1628293.886 , Y: 6580994.18 , CRS: RT90_2_5_GON_V ]
    // CrsCoordinate [ X: 1500248.374 , Y: 6578822.84 , CRS: RT90_0_0_GON_V ]
    // CrsCoordinate [ X: 1372202.721 , Y: 6580977.349 , CRS: RT90_2_5_GON_O ]
    // CrsCoordinate [ X: 1244251.702 , Y: 6587459.595 , CRS: RT90_5_0_GON_O ]
}