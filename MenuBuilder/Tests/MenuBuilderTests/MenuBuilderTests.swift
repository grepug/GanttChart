import XCTest
@testable import MenuBuilder

final class MenuBuilderTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(MenuBuilder().text, "Hello, World!")
        
        let menu = makeMenu {
            Menu(title: "1") {
                Button(title: "1.1") {
                    
                }
                Divider()
                
                Menu(title: "1.2") {
                    Button(title: "1.2.1") {
                        
                    }
                    
                    Button(title: "1.2.2") {
                        
                    }
                }
            }
        }
        
        print(menu[0].childrenContent())
    }
}
