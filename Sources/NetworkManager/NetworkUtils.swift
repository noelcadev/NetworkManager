//
//  NetworkUtils..swift
//
//
//  Created by Noel Conde Algarra on 10/12/23.
//

import Foundation

public final class NetworkUtils {
    
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    /// Creates a URLRequest with specified parameters and can throw an error.
    ///
    /// This function constructs a `URLRequest` using the provided URL, HTTP method, and body. The body of the request is encoded as JSON. This function is generic and can be used with any type that conforms to `Codable`. It can throw an error if encoding the body to JSON fails.
    ///
    /// - Parameters:
    ///   - url: The `URL` object representing the endpoint for the request.
    ///   - body: A `Codable` object that will be encoded to JSON and set as the request body. Encoding failure will throw an error.
    ///   - method: The `HTTPMethod` enum value representing the HTTP method to be used for the request.
    ///
    /// - Throws: An `Error` if the JSON encoding of the body fails.
    ///
    /// - Returns: A `URLRequest` configured with the given URL, HTTP method, and JSON-encoded body.
    ///
    /// Usage:
    ///
    /// ```swift
    /// struct LoginRequest: Codable {
    ///     let username: String
    ///     let password: String
    /// }
    ///
    /// let loginDetails = LoginRequest(username: "user123", password: "pass123")
    /// let requestURL = URL(string: "https://example.com/login")!
    /// do {
    ///     let request = try NetworkUtils.createRequest(url: requestURL, body: loginDetails, method: .post)
    ///     // Use the request with your network logic
    /// } catch {
    ///     print("Error creating request: \(error)")
    /// }
    /// ```
    ///
    /// - Note: Ensure that the URL provided is valid and the server expects the body in JSON format.
    public static func createRequest<T: Codable>(url: URL, body: T,  method: HTTPMethod) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let bodyEncoded = try JSONEncoder().encode(body)
        request.httpBody = bodyEncoded

        return request
    }
}
