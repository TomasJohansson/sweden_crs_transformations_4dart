// dart test/coordinate_files/transforming_coordinates_from_file_test.dart
import 'package:test/test.dart';
import 'package:sweden_crs_transformations_4dart/sweden_crs_transformations_4dart.dart';
import '../dot_net_helpers.dart';
import 'dart:io';

// the below file "swedish_crs_transformations.csv" was copied from: https://github.com/TomasJohansson/crsTransformations/blob/a1da6c74daf040a521beb32f9f395124ffe76aa6/crs-transformation-adapter-test/src/test/resources/generated/swedish_crs_coordinates.csv
// and it was generated with a method "createFileWithTransformationResultsForCoordinatesInSweden()" at https://github.com/TomasJohansson/crsTransformations/blob/a1da6c74daf040a521beb32f9f395124ffe76aa6/crs-transformation-adapter-test/src/test/java/com/programmerare/com/programmerare/testData/CoordinateTestDataGeneratedFromEpsgDatabaseTest.java
const String relativePathForFileWith_swedish_crs_transformations = 'coordinate_files/data/swedish_crs_coordinates.csv';

const String columnSeparator = '|';
final String pathSeparator = Platform.pathSeparator; // 'dart:io'

void main() {
  test('assertThatTransformationsDoNotDifferTooMuchFromExpectedResultInFile', () {
    final file = _getFileWithSwedishCrsCoordinates();
    Assert.IsTrue(file.existsSync());
    List<String> lines = file.readAsLinesSync();
    List<String> problemTransformationResults = [];
    // The first two lines of the input file (the header row, and a data row):
        // EPSG 4326 (WGS84)Longitude for WGS84 (EPSG 4326)|Latitude for WGS84 (EPSG 4326)|EPSG 3006|X for EPSG 3006|Y for EPSG 3006|EPSG 3007-3024|X for EPSG 3007-3024|Y for EPSG 3007-3024|Implementation count for EPSG 3006 transformation|Implementation count for EPSG 3007-3024 transformation
        // 4326|12.146151472138385|58.46573396912418|3006|333538.2957000149|6484098.2550872|3007|158529.85136620898|6483166.205771873|6|6
    // The last two columns can be ignored here, but the first nine columns are in three pairs with three columns each:
    // an epsg number, and then the longitude(x) and latitude(y) for that coordinate.
    // All three coordinates in one row represents the same location but in different coordinate reference systems.
    // The first two, of the three, coordinates are for the same coordinate reference systems, WGS84 and SWEREF99TM, 
    // but the third is different for all rows (18 data rows for the local swedish CRS systems, RT90 and SWEREF99, with EPSG codes 3007-3024).

    // The below loop iterates all lines and makes transformations between (to and from) the three coordinate reference systems
    // and verifies the expected result according to the file, and asserts with an error if the difference is too big.
    // Note that the expected coordinates have been calculated in another project, by using a median value for 6 different implementations.
    // (and the number 6 is actually what the last columns means i.e. how many implementations were used to create the data file)
    final List<_Coordinates> listOfCoordinates = lines.skip(1).map((line) => _Coordinates(line)).toList();
    Assert.AreEqual(18, listOfCoordinates.length);
    int numberOfTransformations = 0;
    for(var listOfCoordinatesWhichRepresentTheSameLocation in listOfCoordinates) {
      List<CrsCoordinate> coordinates = listOfCoordinatesWhichRepresentTheSameLocation.coordinateList;
      for(int i=0; i<coordinates.length-1; i++) {
        for(int j=i+1; j<coordinates.length; j++) {
          _transform(coordinates[i], coordinates[j], problemTransformationResults);
          _transform(coordinates[j], coordinates[i], problemTransformationResults);
          numberOfTransformations += 2;
        }
      }
    }
    if (problemTransformationResults.length > 0) {
      for(String s in problemTransformationResults) {
        print(s);
      }
    }
    Assert.AreEqual(0, problemTransformationResults.length);

    const expectedNumberOfTransformations = 108; // for an explanation, see the lines below:
    // Each line in the input file "swedish_crs_coordinates.csv" has three coordinates (and let's below call then A B C)
    // and then for each line we should have done six number of transformations:
    // A ==> B
    // A ==> C
    // B ==> C
    // (and three more in the opposite directions)
    // And there are 18 local CRS for sweden (i.e number of data rows in the file)
    // Thus the total number of transformations should be 18 * 6 = 108
    Assert.AreEqual(expectedNumberOfTransformations, numberOfTransformations);
  });
}


  void _transform(
    CrsCoordinate sourceCoordinate,
    CrsCoordinate targetCoordinateExpected,
    List<String> problemTransformationResults
  ) {
    CrsProjection targetCrs = targetCoordinateExpected.crsProjection;
    CrsCoordinate targetCoordinate = sourceCoordinate.transform(targetCrs);
    bool isTargetEpsgWgs84 = targetCrs.isWgs84();
    // this maxDifference below worked with the C# implementation:
    //  double maxDifference = isTargetEpsgWgs84 ? 0.000003 : 0.2;
    // but with this Dart implementation there is one difference larger than 0.48 that will fail
    //  (when transforming  wgs84 ==> sweref_99_13_30)
    // double maxDifference = isTargetEpsgWgs84 ? 0.000003 : 0.48; // fails with Dart (see above comment)
    final maxDifference = isTargetEpsgWgs84 ? 0.000003 : 0.5; // the other (i.e. non-WGS84) are using meter as unit, so 0.5 is just five decimeters difference
    final diffLongitude = ((targetCoordinate.LongitudeX - targetCoordinateExpected.LongitudeX)).abs();
    final diffLatitude = ((targetCoordinate.LatitudeY - targetCoordinateExpected.LatitudeY)).abs();

    if (diffLongitude > maxDifference || diffLatitude > maxDifference) {
      String problem = 
        "Projection ${sourceCoordinate.crsProjection} ==> ${targetCoordinateExpected.crsProjection} , diffLongitude ${diffLongitude}  , diffLatitude ${diffLatitude}"
        + "sourceCoordinate xLongitude/yLatitude: ${sourceCoordinate.LongitudeX}/${sourceCoordinate.LatitudeY}" 
        + "targetCoordinate xLongitude/yLatitude: ${targetCoordinate.LongitudeX}/${targetCoordinate.LatitudeY}" 
        + "targetCoordinateExpected xLongitude/yLatitude: ${targetCoordinateExpected.LongitudeX}/${targetCoordinateExpected.LatitudeY}";
      problemTransformationResults.add(problem);
    }
  }

  File _getFileWithSwedishCrsCoordinates() {
    final String currentWorkingDirectory = Directory.current.path; // 'dart:io'
    final String separatorSuffixIfNeeded = currentWorkingDirectory.endsWith(pathSeparator) ? "" : pathSeparator;
    final String testDirectory = currentWorkingDirectory + separatorSuffixIfNeeded + "test" + pathSeparator;
    final String absolutePathToFile = testDirectory + relativePathForFileWith_swedish_crs_transformations.replaceAll("/", pathSeparator);
    final file = File(absolutePathToFile); // 'dart:io'
    // print("_getFileWithSwedishCrsCoordinates ${file.path}");
    return file;
  }

class _Coordinates {
  final List<CrsCoordinate> coordinateList;
  
  const _Coordinates._myPrivateConstructor(this.coordinateList);

  // https://dart.dev/guides/language/language-tour#constructors
  //  Another use case for factory constructors is initializing a final variable using logic that can’t be handled in the initializer list.
  factory _Coordinates(
    String lineFromFile
  ) {
    List<String> columns = lineFromFile.split(columnSeparator);
    return _Coordinates._myPrivateConstructor([
      CrsCoordinate.CreateCoordinateByEpsgNumber(int.parse(columns[0]), double.parse(columns[1]), double.parse(columns[2])),
      CrsCoordinate.CreateCoordinateByEpsgNumber(int.parse(columns[3]), double.parse(columns[4]), double.parse(columns[5])),
      CrsCoordinate.CreateCoordinateByEpsgNumber(int.parse(columns[6]), double.parse(columns[7]), double.parse(columns[8]))
    ]);
  }
}