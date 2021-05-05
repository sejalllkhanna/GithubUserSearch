
import Foundation

/*
 This class is helping to read of json file for mocking purpose
 */
class JsonFileReader {
    
    static func getJsonFileData(fileName: String)-> Data? {
        
        var jsonData: Data?
        
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let url = URL(fileURLWithPath: filepath)
                
                do {
                    jsonData = try?Data(contentsOf: url)
                }
            }
        }
        return jsonData
    }
    
}
