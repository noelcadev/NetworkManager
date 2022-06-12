import Foundation

public final class AsyncNetwork {
//    static let shared = AsyncNetwork()
//
//    private init() {}
    
    public static func getNetwork<Received>(
        url:URL,
        builder: @escaping (Data) -> Received?,
        session:URLSession = .shared
    ) async -> Result<Received, NetworkError> {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noHTTP)
            }
            if response.statusCode == 200 {
                if let resultado = builder(data) {
                    return .success(resultado)
                } else {
                    return .failure(.notExpectedData)
                }
            } else {
                return .failure(.statusCode(response.statusCode))
            }
        } catch {
            return .failure(.general(error))
        }
    }
}
