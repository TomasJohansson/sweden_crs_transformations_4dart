import 'package:test/test.dart';
import 'package:sweden_crs_transformations_4dart/sweden_crs_transformations_4dart.dart';
import './dot_net_helpers.dart';

// dart test/crs_projection_factory_test.dart

void main() {

  const int epsgNumberForWgs84 = 4326;
  const int epsgNumberForSweref99tm = 3006; // https://epsg.org/crs_3006/SWEREF99-TM.html
  const int numberOfSweref99projections = 13; // with EPSG numbers 3006-3018
  const int numberOfRT90projections = 6; // with EPSG numbers 3019-3024
  const int numberOfWgs84Projections = 1; // just to provide semantic instead of using a magic number 1 below
  const int totalNumberOfProjections = numberOfSweref99projections + numberOfRT90projections + numberOfWgs84Projections;

  List<CrsProjection> _allCrsProjections;

  setUp(() {
    _allCrsProjections = CrsProjectionFactory.getAllCrsProjections();
  });


  test('getCrsProjectionByEpsgNumber', () {
    Assert.AreEqual(
      CrsProjection.sweref_99_tm,
      CrsProjectionFactory.getCrsProjectionByEpsgNumber(epsgNumberForSweref99tm)
    );

    Assert.AreEqual(
      CrsProjection.sweref_99_23_15,
      CrsProjectionFactory.getCrsProjectionByEpsgNumber(3018) // https://epsg.io/3018
    );

    Assert.AreEqual(
      CrsProjection.rt90_5_0_gon_o,
      CrsProjectionFactory.getCrsProjectionByEpsgNumber(3024)  // https://epsg.io/3018
    );
  });

  test('verifyTotalNumberOfProjections', () {
    Assert.AreEqual(
      totalNumberOfProjections,
      _allCrsProjections.length // retrieved with 'GetAllCrsProjections' in the SetUp method
    );
  });
  
  test('verifyNumberOfWgs84Projections', () {
    Assert.AreEqual(numberOfWgs84Projections, _allCrsProjections.where((crs) => crs.isWgs84()).length);
  });
  
  test('verifyNumberOfSweref99Projections', () {
    Assert.AreEqual(numberOfSweref99projections, _allCrsProjections.where((crs) => crs.isSweref()).length);
  });
  
  test('verifyNumberOfRT90Projections', () {
    Assert.AreEqual(numberOfRT90projections, _allCrsProjections.where((crs) => crs.isRT90()).length);
  });

  test('verifyThatAllProjectionsCanBeRetrievedByItsEpsgNumber', () {
    for(var crsProjection in _allCrsProjections) {
      var crsProj = CrsProjectionFactory.getCrsProjectionByEpsgNumber(crsProjection.getEpsgNumber());
      Assert.AreEqual(crsProjection, crsProj);
    }
  });

}