import Foundation

struct NFTRequest: NetworkRequest {
<<<<<<< HEAD
  var endpoint: URL?

  init(id: String) {
    guard let endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)") else { return }
    self.endpoint = endpoint
  }
=======
    var token: String?
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
>>>>>>> f05c1aeb510623a91e58024a1959f91bfd8a7d8f
}
