# NetworkManager

A library to deploy all your network communications.

## AsyncNetwork

This library allows you to make asynchronous network requests using Async-Await.

### Installation

Use Swift Package Manager to install the package in your project ([How to install](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app))

### Guide

To use the library you need to import

```swift
import AsyncNetwork
```

In this example we create a data model object and we send through request body. Then we pass the URLRequest to **AsyncNetwork.shared.request()** function.
It's necessary use **resultType** parameter to indicate the expected type response. If you don't expect a data model and only want a **Data** type, simply don't use this parameter.
If you have a data model for an expected error response, you can use the parameter **errorType**.

```swift
let register = Register(email: "hello@example.com", password: "123456")
let request = URLRequest.registerUser(body: register)
do {
    let (result, _) = try await AsyncNetwork.shared.request(request, resultType: Register.self, errorType: ErrorRes.self)
    print("success: \(result)")
} catch NetworkError.customError(let error as ErrorRes) {
    print("Custom Error: \(error.message)")
} catch {
    print(error.localizedDescription)
}
```

The functions are throws type. If we want to collect the errors we must use do-try-catch. Errors are of type NetworkError.

We can use an URLRequest extension. This way we can customize our request before before making the HTTP request.

```swift
static func registerUser(body: reqRegister) -> URLRequest {
    var request = URLRequest(url: .register)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let bodyEncoded = try? JSONEncoder().encode(body)
    request.httpBody = bodyEncoded
    return request
}
```
