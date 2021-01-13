import 'package:test/test.dart';
import 'package:sweden_crs_transformations_4dart/sweden_crs_transformations_4dart.dart';

import './dot_net_helpers.dart';

// dart test/crs_projection_extensions_test.dart

void main() {
  const int epsgNumberForWgs84 = 4326;
  const int epsgNumberForSweref99tm = 3006; // https://epsg.org/crs_3006/SWEREF99-TM.html
  const epsgNumberForRT90_5_0_gon_o = 3024;
  const int numberOfSweref99projections = 13; // with EPSG numbers 3006-3018
  const int numberOfRT90projections = 6; // with EPSG numbers 3019-3024
  const int numberOfWgs84Projections = 1; // just to provide semantic instead of using a magic number 1 below
  const int totalNumberOfProjections = numberOfSweref99projections + numberOfRT90projections + numberOfWgs84Projections;

  Set<CrsProjection> _wgs84Projections;
  Set<CrsProjection> _sweref99Projections;
  Set<CrsProjection> _rt90Projections;

  setUp(() {
    _wgs84Projections = { CrsProjection.wgs84 };
    
     _sweref99Projections = {
       CrsProjection.sweref_99_12_00, CrsProjection.sweref_99_13_30, CrsProjection.sweref_99_14_15,
       CrsProjection.sweref_99_15_00, CrsProjection.sweref_99_15_45, CrsProjection.sweref_99_16_30,
       CrsProjection.sweref_99_17_15, CrsProjection.sweref_99_18_00, CrsProjection.sweref_99_18_45,
       CrsProjection.sweref_99_20_15, CrsProjection.sweref_99_21_45, CrsProjection.sweref_99_23_15,
       CrsProjection.sweref_99_tm
    };
    
    _rt90Projections = {
      CrsProjection.rt90_0_0_gon_v, CrsProjection.rt90_2_5_gon_o, CrsProjection.rt90_2_5_gon_v,
      CrsProjection.rt90_5_0_gon_o, CrsProjection.rt90_5_0_gon_v, CrsProjection.rt90_7_5_gon_v
    };
  });

  test('getEpsgNumber', () {
      Assert.AreEqual(
        epsgNumberForWgs84,
        CrsProjection.wgs84.getEpsgNumber()
      );

      Assert.AreEqual(
        epsgNumberForSweref99tm,
        CrsProjection.sweref_99_tm.getEpsgNumber()
      );

      Assert.AreEqual(
        epsgNumberForRT90_5_0_gon_o,
        CrsProjection.rt90_5_0_gon_o.getEpsgNumber()
      );
  });

  test('isWgs84', () {
    Assert.IsTrue(CrsProjection.wgs84.isWgs84());
    Assert.IsFalse(CrsProjection.sweref_99_tm.isWgs84());
    Assert.IsFalse(CrsProjection.rt90_0_0_gon_v.isWgs84());

    Assert.AreEqual(numberOfWgs84Projections, _wgs84Projections.length);

    for(var crsProjection in _wgs84Projections) {
      Assert.IsTrue(crsProjection.isWgs84());
    }
    for(var crsProjection in _sweref99Projections) {
      Assert.IsFalse(crsProjection.isWgs84());
    }
    for(var crsProjection in _rt90Projections) {
      Assert.IsFalse(crsProjection.isWgs84());
    }
  });
  test('isSweref', () {
    Assert.IsFalse(CrsProjection.wgs84.isSweref());
    Assert.IsTrue(CrsProjection.sweref_99_tm.isSweref());
    Assert.IsFalse(CrsProjection.rt90_0_0_gon_v.isSweref());    

    Assert.AreEqual(numberOfSweref99projections, _sweref99Projections.length);

    for(var crsProjection in _wgs84Projections) {
      Assert.IsFalse(crsProjection.isSweref());
    }
    for(var crsProjection in _sweref99Projections) {
      Assert.IsTrue(crsProjection.isSweref());
    }
    for(var crsProjection in _rt90Projections) {
      Assert.IsFalse(crsProjection.isSweref());
    }    
  });

  test('isRT90', () {
    Assert.IsFalse(CrsProjection.wgs84.isRT90());
    Assert.IsFalse(CrsProjection.sweref_99_tm.isRT90());
    Assert.IsTrue(CrsProjection.rt90_0_0_gon_v.isRT90());

    Assert.AreEqual(numberOfRT90projections, _rt90Projections.length);

    for(var crsProjection in _wgs84Projections) {
      Assert.IsFalse(crsProjection.isRT90());
    }
    for(var crsProjection in _sweref99Projections) {
      Assert.IsFalse(crsProjection.isRT90());
    }
    for(var crsProjection in _rt90Projections) {
      Assert.IsTrue(crsProjection.isRT90());
    }
  });    

}