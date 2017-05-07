
import Foundation
import Alamofire
import BrightFutures
import Result

func AlamofireRequest(_ url: String) -> Future<String, NoError> {
    return Future<String, NoError> { complete in
        Alamofire.request(url).responseData(completionHandler: { response in
            if let htmlWithoutEncoding = response.result.value,
               let html = String(data: DataEncodingHelper.healing(htmlWithoutEncoding), encoding: .utf8) {
                complete(.success(html))
            }
            // TODO: Add handling for when download fails.
        })
    }
}

func AlamofireRequestWithoutEncoding(_ url: String) -> Future<String, NoError> {
    return Future<String, NoError> { complete in
        Alamofire.request(url).responseString(completionHandler: { response in
            if let html = response.result.value {
                complete(.success(html))
            }
            // TODO: Add handling for when download fails.
        })
    }
}

func AlamofireRequestAsJson(_ url: String) -> Future<DataResponse<Any>, NoError> {
    return Future<DataResponse<Any>, NoError> { complete in
        Alamofire.request(url).responseJSON(completionHandler: { response in
            complete(.success(response))
            // TODO: Add handling for when download fails.
        })
    }
}

func AlamofireRequest(_ url: String, headers: [String:String]) -> Future<String, NoError> {
    return Future<String, NoError> { complete in
        Alamofire.request(url, headers: headers).responseData(completionHandler: { response in
            if let htmlWithoutEncoding = response.result.value,
               let html = String(data: DataEncodingHelper.healing(htmlWithoutEncoding), encoding: .utf8) {
                complete(.success(html))
            }
            // TODO: Add handling for when download fails.
        })
    }
}
