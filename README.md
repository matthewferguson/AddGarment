# AddGarment
Short Coding Assessment - Specs located in repo

The data within AddGarment flows through the Core Data Framework allowing for a Data Driven Event Driven Architecture.  Which allows for a MVI Architecture that breaks out, decouples, the modules as either business logic or Views / View Controllers.  Allowing for Views/View Controllers/View Models the capability of close to plug and play by tapping into the data flow (Core Data).  Plus, this architecture allows for modules to be organized as Swift Packages (Swift Package Manager) now or in the future.   

The Swift Package DataFlowFunnelCD ( https://github.com/matthewferguson/DataFlowFunnelCD ) provides Core Data CRUD operation contention protection of the NSManagedObject. All save operations are performed from Operations (located in the group/folder ‘CRUDOperations’) that are placed on the DataFlowFunnelCD OperationQueue.  This OperationQueue processes one Operation at a time protecting the Core Data stack from aperiodic crashing and data corruption. 

5 Major Modules:
ErrorLogModule  - Manages the error logging submitted to the core data stack
GarmentAddModule - View that allows the input and save of a new Garment add. 
GarmentListModule - View that displays all of the Garments, filters on two sort algorithm, and launches the GarmentAdd. 
Bundle - App main, app scene, core data schema, and CRUDOperations
Add Garment Tests - cleaning and adding test data into the core data persistence. 

Swift Package Manager Dependency
DataFlowFunnelCD  - https://github.com/matthewferguson/DataFlowFunnelCD

Designed on Xcode Version 12.5.1 (12E507) and supports iOS 13 and 14 SDK. 

AutoLayout supported for iPhone size class portrait and landscape. 

 XCTest support to load and remove all of the Garments and ErrorLog table entries.  This will load test data with the following steps. 
1. Find AddGarmentTests folder and open AddGarmentTests.swift. 
2. Run the following single test functions:
	func testDataCleanErrorLogs()
	func testDataCleanGarments()
	func testBulkDataAdd()

Demo Video: 

