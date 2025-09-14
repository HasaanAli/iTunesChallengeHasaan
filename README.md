⚙️ **Tech Stack:** SwiftUI, Combine, MVVM, Repository pattern, RealmDB, Alamofire

## About App:

Search through iTunes Movies. It shows master view and detail view, and allows to mark favorite. Favorite movies info are available offline.


## Design Patterns

### MVVM

It is a UI design pattern (not an architecture) that helps separate UI and related logic into View and ViewModel. View talks to VM, VM processes UI events and provides data to View.

### Repository Pattern

It helps encapsulate different datasources of a one/more entities and provides single interface to other app components that need that data. 
It also contains logic of when to use which data source: e.g, use local data when offline else fetch remote.
    

### Tech Stack
     
It uses following Tech stack:
- UI: SwiftUI
- Swift
- MVVM - Model-View-ViewModel (used Combine because of SwiftUI)
- CocoaPods
- Combine (for search field functionality, for sending updates to subscribers of Repository)
- Persistence: RealmDB
- Alamofire + Codable
- Xibs & Storyboards (not used)
- XCTest (not yet)
- Git


### Code Structure

**Main Screen breakdown:**

- MainScreen
    - FavoritesView/VM
    - SearchList/VM 
    
**Communication flow:**

 `Symbol <-> below means "talks to"`
 
- View <talks to> VM <-> Repository/Manager
- Repository <-> API/DB

<End>
