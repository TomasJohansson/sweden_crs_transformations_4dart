import 'package:test/test.dart';

// This Dart project have been ported from .NET , 
// and the below helper class is "simulating" a .NET class.
// Of course the method invocations in the tests e.g. 'Assert.AreEqual' 
// can be modified e.g. to switch order of the parameters for 'AreEqual' and directly 
// use the Dart 'expect' function instead, but to keep the traceability i.e. 
// make it easier to look in git history and see changes with the original code, 
// there will be fewer changes if the original code with 'Assert.AreEqual' 
// is kept as it was with the .NET implementation

class Assert {
  // https://docs.microsoft.com/en-us/dotnet/api/microsoft.visualstudio.testtools.unittesting.assert.areequal?view=mstest-net-1.3.2#Microsoft_VisualStudio_TestTools_UnitTesting_Assert_AreEqual_System_Object_System_Object_
  // public static void AreEqual (object expected, object actual);
  static void AreEqual(Object expected, Object actual) {
    // The parameters of the .NET class is as in the above order (actual, expected)
    // while "actual" is the first parameter for Dart test function "expect" as below.
    expect(actual, expected);
  }

  static void IsTrue(bool actual) {
    expect(actual, true);
  }  
  static void IsFalse(bool actual) {
    expect(actual, false);
  }    
}