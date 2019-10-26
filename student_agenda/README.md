# Student Agenda



## Dev Notes

### How to call a cloud function in Flutter

1. Import cloud function package

```Java
import 'package:cloud_functions/cloud_functions.dart';
```
2. Create a function callable

```Java
final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'helloWorld')
        ..timeout = const Duration(seconds: 30);
```
This will create an object that can be called later, the function name is the name of the function in firebase. Additionally make sure to add a timeout on the callable.

3. When needed (ex: `onPressed` call) call the the callable

```Java
onPressed: () async {
  try {
    final HttpsCallableResult result = await callable.call(); 
    print(result.data);
  } on CloudFunctionsException catch (e) {
    print('caught firebase functions exception');
    print(e.code);
    print(e.message);
    print(e.details);
  } catch (e) {
    print('caught generic exception');
    print(e);
  }
}
```
In this example the `onPressed` call will call an `async` function that, in a try/catch, will call the previously made callable and save the returned data in a `HttpsCallableResult` object. Getting the data from the `HttpsCallableResult` object depends on the returned data but a simple `result.data` will work for most cases
