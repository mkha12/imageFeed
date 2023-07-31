
import XCTest

final class ImageFeedUITests: XCTestCase {
    let email = ""
    let password = ""
    let fullname = ""
    let username = ""

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()
        print(app.debugDescription)
    }

    func testAuth() throws {
            app.buttons["Authenticate"].tap()

            let webView = app.webViews["UnsplashWebView"]

            XCTAssert(webView.waitForExistence(timeout: 20), "Web view did not appear in time")

            let loginTextField = webView.descendants(matching: .textField).element
            XCTAssert(loginTextField.waitForExistence(timeout: 5), "Login text field did not appear in time")

            loginTextField.tap()
            loginTextField.typeText(email)
            webView.swipeUp()

            let passwordTextField = webView.descendants(matching: .secureTextField).element
            XCTAssert(passwordTextField.waitForExistence(timeout: 5), "Password text field did not appear in time")

            passwordTextField.tap()
            passwordTextField.typeText(password)
            webView.swipeUp()

            webView.buttons["Login"].tap()

            let tablesQuery = app.tables
            let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

            XCTAssert(cell.waitForExistence(timeout: 5), "Table view cell did not appear in time")
        }

    func testFeed() throws {
        let tablesQuery = app.tables
        sleep(2)

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()

        sleep(2)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["like button"].tap()
        sleep(2)
        cellToLike.buttons["like button"].tap()

        sleep(2)
        cellToLike.tap()
        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)

        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts[fullname].exists)
        XCTAssertTrue(app.staticTexts[username].exists)

        app.buttons["logout button"].tap()

        app.alerts["bye_bye"].scrollViews.otherElements.buttons["logout_yes"].tap()
        sleep(3)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
