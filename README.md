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

In this example we crete an data model object and we send through request body. Then we pass the URLRequest to **AsyncNetwork.data()** function.
It's necessary use **build** callback to indicate the expected data response. If you don't expect a data model and only want a **Data** type, simply use Data().
If you have a data model for an expected JSON response, you can use the optional parameter **buildError**.

```swift
let register = Register(email: "hello@example.com", password: "123456")
let request = URLRequest.registerUser(model: register)
let (result, _) = await AsyncNetwork.data(request: request,  builder: { data in
try JSONDecoder().decode(Register.self, from: data)
}, builderError: { data in
// Optional. When you expect an expected error JSON response wit a data model
try JSONDecoder().decode(ErrorRes.self, from: data)
})
```

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

Once we have the result we can check the result success or failure and retrieve the data response.

```swift
switch result {
case .success((let resType, let errorType)):
if let resType = resType {
// Use the resType data response
} else if let errorType = errorType {
// Use the resType data error response with expected data errors responses.
// Optional. Only returns if you pass buildError parameter.
}
case .failure(let error):
// Manage another error cases without a data model 
}
```
