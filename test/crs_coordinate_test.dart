// dart test/crs_coordinate_test.dart
import 'package:test/test.dart';
import 'package:sweden_crs_transformations_4dart/sweden_crs_transformations_4dart.dart';
import './dot_net_helpers.dart';
import 'dart:math' as Math;

void main() {
  const int epsgNumberForSweref99tm = 3006; // https://epsg.org/crs_3006/SWEREF99-TM.html

  // https://kartor.eniro.se/m/XRCfh
      //WGS84 decimal (lat, lon)      59.330231, 18.059196
      //RT90 (nord, öst)              6580994, 1628294
      //SWEREF99 TM (nord, öst)       6580822, 674032
  const double stockholmCentralStation_WGS84_latitude = 59.330231;
  const double stockholmCentralStation_WGS84_longitude = 18.059196;
  const double stockholmCentralStation_RT90_northing = 6580994;
  const double stockholmCentralStation_RT90_easting = 1628294;
  const double stockholmCentralStation_SWEREF99TM_northing = 6580822;
  const double stockholmCentralStation_SWEREF99TM_easting = 674032;

  test('transform', () {
    CrsCoordinate stockholmWGS84 = CrsCoordinate.CreateCoordinate(
      CrsProjection.wgs84,
      stockholmCentralStation_WGS84_longitude,
      stockholmCentralStation_WGS84_latitude
    );
    CrsCoordinate stockholmSWEREF99TM = CrsCoordinate.CreateCoordinate(
      CrsProjection.sweref_99_tm,
      stockholmCentralStation_SWEREF99TM_easting,
      stockholmCentralStation_SWEREF99TM_northing
    );
    CrsCoordinate stockholmRT90 = CrsCoordinate.CreateCoordinate(
      CrsProjection.rt90_2_5_gon_v,
      stockholmCentralStation_RT90_easting,
      stockholmCentralStation_RT90_northing
    );

    // Transformations to WGS84 (from SWEREF99TM and RT90):
    _AssertEqual(
      stockholmWGS84, // expected WGS84
      stockholmSWEREF99TM.transform(CrsProjection.wgs84) // actual/transformed WGS84
    );
    _AssertEqual(
      stockholmWGS84, // expected WGS84
      stockholmRT90.transform(CrsProjection.wgs84) // actual/transformed WGS84
    );
    // below is a similar test as one of the above tests but using the overloaded Transform method
    // which takes an integer as parameter instead of an instance of the enum CrsProjection
    int epsgNumberForWgs84 = CrsProjection.wgs84.getEpsgNumber();
    _AssertEqual(
      stockholmWGS84,
      stockholmRT90.transformByEpsgNumber(epsgNumberForWgs84) // testing the overloaded Transform method with an integer parameter
    );


    // Transformations to SWEREF99TM (from WGS84 and RT90):
    _AssertEqual(
      stockholmSWEREF99TM, // expected SWEREF99TM
      stockholmWGS84.transform(CrsProjection.sweref_99_tm) // actual/transformed SWEREF99TM
    );
    _AssertEqual(
      stockholmSWEREF99TM, // expected SWEREF99TM
      stockholmRT90.transform(CrsProjection.sweref_99_tm) // actual/transformed SWEREF99TM
    );


    // Transformations to RT90 (from WGS84 and SWEREF99TM):
    _AssertEqual(
      stockholmRT90,  // expected RT90
      stockholmWGS84.transform(CrsProjection.rt90_2_5_gon_v) // actual/transformed RT90
    );
    _AssertEqual(
      stockholmRT90,  // expected RT90
      stockholmSWEREF99TM.transform(CrsProjection.rt90_2_5_gon_v) // actual/transformed RT90
    );
  });


  test('createCoordinateByEpsgNumber', () {
    const double x = 20.0;
    const double y = 60.0;
    CrsCoordinate crsCoordinate = CrsCoordinate.CreateCoordinateByEpsgNumber(epsgNumberForSweref99tm, x, y);
    Assert.AreEqual(epsgNumberForSweref99tm, crsCoordinate.crsProjection.getEpsgNumber());
    Assert.AreEqual(x, crsCoordinate.xLongitude);
    Assert.AreEqual(y, crsCoordinate.yLatitude);
  });

  test('createCoordinate', () {
    const double x = 22.5;
    const double y = 62.5;
    CrsCoordinate crsCoordinate = CrsCoordinate.CreateCoordinate(CrsProjection.sweref_99_tm, x, y);
    Assert.AreEqual(epsgNumberForSweref99tm, crsCoordinate.crsProjection.getEpsgNumber());
    Assert.AreEqual(CrsProjection.sweref_99_tm, crsCoordinate.crsProjection);
    Assert.AreEqual(x, crsCoordinate.xLongitude);
    Assert.AreEqual(y, crsCoordinate.yLatitude);
  });

  test('equalityTest', () {
    CrsCoordinate coordinateInstance_1 = CrsCoordinate.CreateCoordinate(CrsProjection.wgs84, stockholmCentralStation_WGS84_longitude, stockholmCentralStation_WGS84_latitude);
    CrsCoordinate coordinateInstance_2 = CrsCoordinate.CreateCoordinate(CrsProjection.wgs84, stockholmCentralStation_WGS84_longitude, stockholmCentralStation_WGS84_latitude);
    Assert.AreEqual(coordinateInstance_1.hashCode, coordinateInstance_2.hashCode);
    Assert.AreEqual(coordinateInstance_1, coordinateInstance_2);
    Assert.IsTrue(coordinateInstance_1 == coordinateInstance_2);
    Assert.IsTrue(coordinateInstance_2 == coordinateInstance_1);
    Assert.IsFalse(coordinateInstance_1 != coordinateInstance_2);
    Assert.IsFalse(coordinateInstance_2 != coordinateInstance_1);

    double delta = 0.000000000000001; // see comments further below regarding the value of "delta"
    CrsCoordinate coordinateInstance_3 = CrsCoordinate.CreateCoordinate(
      CrsProjection.wgs84,
      stockholmCentralStation_WGS84_longitude + delta,
      stockholmCentralStation_WGS84_latitude + delta
    );
    Assert.AreEqual(coordinateInstance_1.hashCode, coordinateInstance_3.hashCode);    
    Assert.AreEqual(coordinateInstance_1, coordinateInstance_3);
    Assert.IsTrue(coordinateInstance_1 == coordinateInstance_3); // method "operator =="
    Assert.IsTrue(coordinateInstance_3 == coordinateInstance_1);
    Assert.IsFalse(coordinateInstance_1 != coordinateInstance_3);
    Assert.IsFalse(coordinateInstance_3 != coordinateInstance_1);    

    // Regarding the chosen value for "delta" (which is added to the lon/lat values, to create a slightly different value) above and below,
    // it is because of experimentation this "breakpoint" value has been determined, i.e. the above value still resulted in equality 
    // but when it was increased as below with one decimal then the above kind of assertions failed and therefore the other assertions below 
    // are used instead e.g. testing the overloaded operator "!=".
    // You should generally be cautios when comparing floating point values but the above test indicate that values are considered equal even though 
    // the difference is as 'big' as in the "delta" value above.

    delta = delta * 10; // moving the decimal one bit to get a somewhat larger values, and then the instances are not considered equal, as you can see in the tests below.
    CrsCoordinate coordinateInstance_4 = CrsCoordinate.CreateCoordinate(
      CrsProjection.wgs84,
      stockholmCentralStation_WGS84_longitude + delta,
      stockholmCentralStation_WGS84_latitude + delta
    );
    // Note that below are the Are*NOT*Equal assertions made instead of AreEqual as further above when a smaller delta value was used
    Assert.IsTrue(coordinateInstance_1 != coordinateInstance_4); // Note that the method "operator !=" becomes used here
    Assert.IsTrue(coordinateInstance_4 != coordinateInstance_1);
    Assert.IsFalse(coordinateInstance_4 == coordinateInstance_1);
    Assert.IsFalse(coordinateInstance_4 == coordinateInstance_1);
  });


  test('toStringTest', () {
    CrsCoordinate coordinate = CrsCoordinate.CreateCoordinate(CrsProjection.sweref_99_18_00, 153369.673, 6579457.649);
    Assert.AreEqual(
      "CrsCoordinate [ X: 153369.673 , Y: 6579457.649 , CRS: SWEREF_99_18_00 ]",
      coordinate.toString()
    );

    

    CrsCoordinate coordinate2 = CrsCoordinate.CreateCoordinate(CrsProjection.wgs84, 18.059196, 59.330231);
    const expectedDefaultToStringResultForCoordinate2 = "CrsCoordinate [ Longitude: 18.059196 , Latitude: 59.330231 , CRS: WGS84 ]";
    Assert.AreEqual(
       expectedDefaultToStringResultForCoordinate2,
       coordinate2.toString()
    );

    // now below testing the same coordinate as above but with a custom 'ToString' implementation
    CrsCoordinate.setToStringImplementation(_myCustomToStringFunction);
    Assert.AreEqual(
      "59.330231 , 18.059196",
      coordinate2.toString()
    );
    
    CrsCoordinate.setToStringImplementationDefault(); // restores the default 'ToString' implementation
    Assert.AreEqual(
       expectedDefaultToStringResultForCoordinate2,
       coordinate2.toString()
    );    
  });
}

void _AssertEqual(CrsCoordinate crsCoordinate_1, CrsCoordinate crsCoordinate_2)  {
  Assert.AreEqual(crsCoordinate_1.crsProjection, crsCoordinate_2.crsProjection);
  double maxDifference = crsCoordinate_1.crsProjection.isWgs84() ? 0.000007 : 0.5; // the other (i.e. non-WGS84) value is using meter as unit, so 0.5 is just five decimeters difference
  double diffLongitude = ((crsCoordinate_1.xLongitude - crsCoordinate_2.xLongitude)).abs();
  double diffLatitude = ((crsCoordinate_1.yLatitude - crsCoordinate_2.yLatitude)).abs();            
  
  Assert.IsTrue(diffLongitude < maxDifference);
  Assert.IsTrue(diffLatitude < maxDifference);
}

String _myCustomToStringFunction(CrsCoordinate coordinate) {
  return "${coordinate.yLatitude} , ${coordinate.xLongitude}";
}