# JSONSearchLib
A Swift search library for JSON

This is a simple library that wraps JSON objects produced by `NSJONSerialization`.  It performs two functions:

- It adds easy to use subscripting that doesn't require type casting in Swift.
- It provides a recursive search facility.

## Object Wrappers

All objects in the JSON tree are stored as instances of subclasses of `JSON`.  `JSON`.  The sublcasses are

- `JSONArray`
- `JSONObject`
- `JSONString`
- `JSONNumber`
- `JSONNull`
- `JSONBool`

These all do exactly what you would expect.

`JSON` has subscripts for both `String` and `Int`.  These do different things depending on the subclass.  They are declared as follows:

    subscript(index: String) -> JSON?
    subscript(index: Int) -> JSON?

The string subscript works exactly like a string subscrpit on a `Dictionary` if applied to a `JSONObject`.  If applied to anything else, it always returns nil. 

The int subscript returns the object at the given index in a `JSONArray` or `nil` if applied to anything else.  If the index is out of range for the `JSONArray`, the subscript also returns `nil` (as opposed to throwing an exception).  This means the normal unwrapping options apply consistently.

For example, with the following JSON

~~~json
{
	"projects" : [
          {
              "name" : "JSONSearchLib",
              "url" : "https://bitbucket.org/jeremy-pereira/jsonsearchlib"
          },
          {
              "name" : "EnigmaMachine",
              "url" : "https://bitbucket.org/jeremy-pereira/enigmamachine"
          }
    ]
}
~~~

you can access the first name element as follows

~~~swift
if let nameElement = readmeJSON["projects"]?[0]?["name"]
{
    println("\(nameElement)") // Prints "JSONSearchLib"
}
~~~

## Search

Searching is done with the search functions.  All JSON subclasses support the Searchable protocol defined as this:

~~~swift
public protocol Searchable
{
    func search(key: String, recursive: Bool) -> ResultSet
    func search(index: Int) -> ResultSet
    func search(wildCard: WildCard) -> ResultSet
}
~~~

A `ResultSet` is an abstraction of an array of matching JSON elements. 

### Search for Key 

The first form searches for a key in the JSON element to which it applies.

If the element is a string, number, bool or null, the returned set is empty.  

If the element is an array, the returned set is empty unless `recursive` is `true`.  If recursive is true, the result set is the union of performing the same search on all the JSON elements in the array.

If the element is an object, the result set contains the value for the key which is equal to the string.  If `recursive` is `true` it also returns the union of the value for the matching key and the same search performed on all of its values.

### Search for index 
### Search for wildcard 


## Loading and saving JSON