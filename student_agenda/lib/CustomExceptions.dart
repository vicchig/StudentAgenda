//DEFINE CUSTOM EXCEPTION CLASSES HERE

class NullArgumentException implements Exception{
  String argumentName = "";
  String functionName = "";

  NullArgumentException(String argumentName, String functionName){
    this.argumentName = argumentName;
    this.functionName = functionName;
  }

  String toString(){
    return "Tried calling function " + functionName+"()" + " with argument " +
           "'" + argumentName + "'" + " as null!";
  }
}