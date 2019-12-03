//
//  NovaUITests.swift
//  NovaUITests
//
//  Created by Max Dignan on 9/24/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import XCTest

class NovaUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        app.buttons["Patient Login"].tap()
        
        let collectionViewsQuery = app.collectionViews
        let howAreYouFeelingStaticText = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["How are you feeling?"]/*[[".cells",".images.staticTexts[\"How are you feeling?\"]",".staticTexts[\"How are you feeling?\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        howAreYouFeelingStaticText.tap()
        howAreYouFeelingStaticText.tap()
        
        let newMessageTextView = app.textViews.containing(.staticText, identifier:"New Message").element
        newMessageTextView.tap()
        
        let sendButton = app.buttons["Send"]
        sendButton.tap()
        
        let fantasticTellMeMoreAboutThatStaticText = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Fantastic! Tell me more about that :)"]/*[[".cells",".images.staticTexts[\"Fantastic! Tell me more about that :)\"]",".staticTexts[\"Fantastic! Tell me more about that :)\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        fantasticTellMeMoreAboutThatStaticText.tap()
        fantasticTellMeMoreAboutThatStaticText.tap()
        newMessageTextView.tap()
        sendButton.tap()
        
        let thatSGreatDidYouHappenToHaveAnyDifficultiesStaticText = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["That's great. Did you happen to have any difficulties?"]/*[[".cells",".images.staticTexts[\"That's great. Did you happen to have any difficulties?\"]",".staticTexts[\"That's great. Did you happen to have any difficulties?\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        thatSGreatDidYouHappenToHaveAnyDifficultiesStaticText.tap()
        thatSGreatDidYouHappenToHaveAnyDifficultiesStaticText.tap()
        app.textViews.staticTexts["New Message"].tap()
        sendButton.tap()
        
        let greatILlLetTheDoctorKnowAboutYourGreatDayHaveAnyOtherQuestionsStaticText = collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Great I'll let the doctor know about your great day! Have any other questions?"]/*[[".cells",".images.staticTexts[\"Great I'll let the doctor know about your great day! Have any other questions?\"]",".staticTexts[\"Great I'll let the doctor know about your great day! Have any other questions?\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        greatILlLetTheDoctorKnowAboutYourGreatDayHaveAnyOtherQuestionsStaticText.tap()
        greatILlLetTheDoctorKnowAboutYourGreatDayHaveAnyOtherQuestionsStaticText.tap()
        newMessageTextView.tap()
        sendButton.tap()
        newMessageTextView.tap()
        sendButton.tap()
                // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
