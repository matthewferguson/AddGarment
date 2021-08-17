# AddGarment

Coding Assessment - Specs archived in repo

Demo Video: https://www.dropbox.com/s/82h4p25fkavntlk/AddGarment%20%202021-08-16%20at%204.26.06%20PM.mov?dl=0

Note: Open the project as a workspace. Start with "AddGarment.xcworkspace"

AddGarment utilizes a MVI (Model-View-Intent) Architecture with reactive programming patterns.  The Model represents the state of the application.  Intent carries out the View Controller and navigation triggers.  View represents the view components and sub-views. 

The Model represents the state and data flow using the iOS Apple Framework Core Data as a Data Driven Event Driven (persistence) Architecture.  The “View and Intent” is realized with the View Controller and sub-views.  Using Core Data and its Fetch Controller features allows the View-Intent to register for data flow events of interest.  MVI and use of Core Data also allows for decoupling of modules or Packages that can tap into a centralized data flow.  Allowing business logic and Views/View Controllers (with changing events) to exist as modules/Swift Packages. 

Within AddGarment a module will setup NSFetchResultsControllerDelegate to present event changes within the model - event driven.  Updating and inserting changes are handled with Operations, reusable dependency injection operations, that are placed on a ‘save’ contention protection OperationQueue (DataFlowFunnelCD - open source Swift Package). 

The Swift Package DataFlowFunnelCD ( https://github.com/matthewferguson/DataFlowFunnelCD ) provides Core Data CRUD operation contention protection of the NSManagedObject. All save operations are performed from Operations (located in the group/folder ‘CRUDOperations’) that are placed on the DataFlowFunnelCD OperationQueue.  This OperationQueue processes one Operation at a time protecting the Core Data stack from aperiodic crashing and data corruption. 

Swift Package Manager Dependency
DataFlowFunnelCD  - https://github.com/matthewferguson/DataFlowFunnelCD

5 Major Modules:

1) ErrorLogModule  - Manages the error logging submitted to the core data stack, 
2) GarmentAddModule - View that allows the input and save of a new Garment add, 
3) GarmentListModule - View that displays all of the Garments, filters on two sort algorithm, and launches the GarmentAdd, 
4) Bundle - App main, app scene, core data schema, and CRUDOperations,
5) Add Garment Tests - cleaning and adding test data into the core data persistence. 

Designed on Xcode Version 12.5.1 (12E507) and supports iOS 13 and 14 SDK. 

AutoLayout supported for iPhone size class portrait and landscape. 

 XCTest support to load and remove all of the Garments and ErrorLog table entries.  This will load test data with the following steps. 

1. Find AddGarmentTests folder, then open AddGarmentTests.swift. 

2. You can run the following single test runs for the desired remove all or add all to the persistence layer:
	func testDataCleanErrorLogs(),
	func testDataCleanGarments(),
	func testBulkDataAdd()


