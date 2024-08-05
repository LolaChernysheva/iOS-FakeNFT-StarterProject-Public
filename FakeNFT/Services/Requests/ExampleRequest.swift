import Foundation

struct ExampleRequest: NetworkRequest {
    var token: String?
<<<<<<< HEAD

=======
    
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL)
    }
}
