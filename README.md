# LocationsList


# App Structure

* App structure I use **MVP** with Input-Output approach **Delegate** to notify about updates.

* Use Async/await Swift.

* I use the **Repository** design pattern to act as a Data source from API and UserDefault for saving location.

* Separate the data source of UITableView to other class **LocationsTableViewDataSource**.

* I use **CellReusable** protocol and create 2 extensions for UITableView to reduce code when reusing the cell.

* Use DataLoader.swift to get data from local JSON.

* I used [SwiftLint](https://github.com/realm/SwiftLint) to enhance Swift style.

* I used create UI with code.

* I used SPM.

# Enhancement
 1 - Add more unit-tests.
 2 - Add UITest.
 3 - Use UITableViewDiffableDataSource.


# UnitTest
* I apply  **Arrange, Act and Assert (AAA) Pattern** in Unit Testing.
* I use mocking to Test get data from  NetworkManager, I use the same JSON file to mock data.
* Test get data from API and From Local JSON.

## Demo
![](Demo.gif)

## Info

Name: Ahmed Abdelaziz
Website: https://dimohamdy.herokuapp.com/
Email: dimo.hamdy@gmail.com
