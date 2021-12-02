# Biblio

A collection of Swift libraries for working with bibliographic records.
At the moment, Biblio can retrieve metadata from the Library of Congress, 
CrossRef, GoogleBooks, and websites for individual publishers.
The package is very much a work-in-progress, and may be subject
to breaking changes.


## Installation

Biblio is distributed with the [Swift Package Manager](https://swift.org/package-manager/). 
Add the following code to your `Package.swift` manifest.

``` Swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/iansampson/Biblio", .branch("main"))
    ],
    ...
)
```


## Usage

You can import specific modules for each service
(LibraryOfCongress, CrossRef, GoogleBooks, or Metadata)
or the Biblio module, which aggregates results
from all of the above.

Construct a `Service` object (or `Biblio.Service` if disambiguation
is needed) using an `URLSession`:

``` Swift
let service = Service(urlSession: .shared)
```

Retrieve a stream of asynchronous results by parsing a webpage
and resolving all its ISBNs and DOIs:

``` Swift
for try await instance in service.instancesFromHTML(atURL: ...) {
...
}
```

Retrieve metadata for a specific DOI:

``` Swift
let doi = try DOI("10.123/456")
let instance = try await service.instance(withDOI: doi)
```

Or a specific ISBN:

``` Swift
let isbn = try ISBN("978-0-8223-5656-1")
let instance = try await service.instance(withISBN: isbn)
```
