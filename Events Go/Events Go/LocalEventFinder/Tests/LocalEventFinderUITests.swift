#if canImport(XCTest)
import XCTest

final class LocalEventFinderUITests: XCTestCase {
    func testLaunchSearchOpenSaveAndSavedList() throws {
        let app = XCUIApplication()
        app.launch()

        // Navigate to List tab
        app.buttons["List"].firstMatch.tap()

        // Search field
        let search = app.textFields["Search events"].firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap()
        search.typeText("Tech")

        // Scroll a bit to ensure list populated
        app.swipeUp()

        // Open Saved tab
        app.buttons["Saved"].firstMatch.tap()

        // Check list exists
        XCTAssertTrue(app.navigationBars["Saved"].exists)
    }
}
#endif
