# motorsApp

This app shows my approach to SOLID principles, clean architecture and testing in a SwiftUI iOS app. (as of June 2022!)

The architecture contains four distinct layers:

* Model layer containing Data structs used throughout the app
* UI layer, containing HomeView, associated HomeViewModel, and other smaller views
* Business logic layer, containing the repositories that supply data to the UI
* Networking (Data) layer, containing the APIClient that does network calls to retrieve data

To ensure easy testing, layers are separated by protocols.  This means that during
unit testing, other layers that interface with the system under test, can be mocked to make testing
easy, quick and efficient, and we can easily simulate situations that could be encountered,
such as networking errors or empty returned data.

To ensure isolation of layers so that elements are loosely coupled (which means they can be reused
elsewhere or swapped out easily if required), protocols govern the interfaces between layers.  Heres 
how this works in practise in the architecture:

HomeView, HomeViewModel - knows about:
MotorsQuerying protocol (query fields in, Motor objects back)<br/>
^<br/>
^<br/>
MotorsRepository: MotorsQuerying, knows about:<br/>
APIClient protocol (takes data request, returns data objects)<br/>
^<br/>
^<br/>
MobileAPIClient: APIClient, knows about<br/>
URLSession etc., performs actual network calls<br/>
^<br/>
^<br/>
Internet<br/>
