# NetworkManager

A library to deploy all your network communications. 

AsyncNetwork class allows you to make asynchronous network requests using Async-Await.

### Installation

Use Swift Package Manager to install the package in your project ([How to install](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app))

### Guide

To use the library you need to import

```swift
import NetworkManager
```

In this example, we instantiate a RegisterBody object to encapsulate the request body data. This object is then used to create a URLRequest for registering a user.

The URLRequest is passed to the **AsyncNetwork.shared.request()** function. This function is designed to handle network requests asynchronously, returning a tuple with the response data and the associated HTTPURLResponse.

It is essential to explicitly define the expected response type in the tuple returned by the AsyncNetwork.shared.request() function. This response type should be a Codable conforming type, which enables the automatic decoding of the JSON response into a Swift data model. If your expected response does not adhere to a Codable structure and you only need the raw Data, specifying the tuple type is not necessary.

In cases where you anticipate a specific error format that conforms to Codable, you can utilize the errorType parameter. This allows the function to handle and return errors in a structured format.

In the example below, we declare the type of result in the tuple as Register, which is a Codable conforming type. This declaration ensures that the response data is automatically decoded into a Register object. If the decoding is successful, the result is then printed. The code also demonstrates handling various types of network errors, including status code errors and custom errors defined by ErrorRes.

```swift
let body = RegisterBody(email: "hello@example.com", password: "123456")
let request = URLRequest.registerUser(body: body)


do {
    let (result, _): (Register, _) = try await AsyncNetwork.shared.request(request, errorType: ErrorRes.self)
    print("Success: \(result)")
} catch NetworkError.invalidStatusCode(let code) {
    print("Status code error: \(code)")
} catch NetworkError.customError(let error as ErrorRes) {
    print("Custom Error: \(error.message)")
} catch {
    print(error.localizedDescription)
}
```

The functions are type throws. If we want to collect the errors we must use try-catch. Errors are of type NetworkError.

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

Also we can create the request easier with the NetworkUtils class using the function **createRequest**. This function constructs a `URLRequest` using the provided URL, HTTP method, and body. The body of the request is encoded as JSON. This function is generic and can be used with any type that conforms to `Codable`. It can throw an error if encoding the body to JSON fails.

```swift
    let register = reqRegister(email: "eve.holt@reqres.in", password: "pistol")

    do {
        let request = try NetworkUtils.createRequest(url: .register, body: register, method: .post)
        let (result, _): (Register, _) = try await AsyncNetwork.shared.request(request, logData: true, errorType: ErrorRes.self)
        print("success: \(result)")
    } catch NetworkError.customError(let error as ErrorRes) {
        print("Custom Error: \(error.error)")
    } catch {
        print(error.localizedDescription)
    }
```

 
