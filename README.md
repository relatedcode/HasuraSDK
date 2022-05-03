# Unofficial Hasura iOS SDK

## What is this?

Hasura SDK is a toolkit to work with Hasura servers easily.

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

### CocoaPods

To use Hasura SDK with [CocoaPods](https://cocoapods.org) specify in your `Podfile`:

```sh
pod 'HasuraSDK'
```

## GraphQL Interface

By using Hasura SDK, you can connect to single or multiple Hasura servers easily. These server connections can be used for both Queries, Mutations, and Subscriptions.

### Connect to a Server

```swift
import HasuraSDK

let link = "https://your-server-name.hasura.app/v1/graphql"
let secret = "EENWfDvVem9y9urmvyoLRK1YDYENISVnTskZOpcfv6"
let server = HServer(link: link, secret: secret)
```

The server instance above can be used for Queries, and Mutations instantly. For having a live subscriction, we need to initiate the WebSocket connection first.

### WebSocket Connection

For using a WebSocket connection, you need to call the `connect()` method before initiating a subscription.

```swift
server.connect() { error in
  if (error == nil) {
    // do something
  }
}
```

The WebSocket connection can be closed by using the `disconnect()` method.

```swift
server.disconnect()
```

### Mutation

Once you have a live server connection, you can initiate a mutation like:

```swift
server.mutation(query, variables) { result, error in
  if (error == nil) {
    // do something
  }
}
```

The `query` parameter type should be a `String`, containing a valid mutation for your server.

```swift
let query = """
mutation CreateObject($objectId: String, $text: String, $number: Int) {
  createObject(data: {objectId: $objectId, text: $text, number: $number}) {
    objectId, text, number
  }
}
"""
```

The `variables` parameter type should be `[String: Any]`, containing all the necessary variables for the mutation.

```swift
let variables: [String: Any] = ["objectId": "id111", "text": "abcdabcdabcd", "number": 123]
```

### Query

Initiating a query is also pretty straight forward:

```swift
server.query(query, variables) { result, error in
  if (error == nil) {
    // do something
  }
}
```

Where the `query` parameter is something like this:

```swift
let query = """
query ObjectQuery($number: Int) {
  listObjects(filter: {number: {gt: $number}}) {
    items {
      objectId, text, number
    }
  }
}
"""
```

And the `variables` parameter somethig like:

```swift
let variables: [String: Any] = ["number": 123]
```

### Subscription

Setting up a subscription is very similar to the previous implementations:

```swift
let subscriptionId = server.subscription(query, variables) { result, error in
  if (error == nil) {
    // do something
  }
}
```

Where the `query` parameter would look like:

```swift
let query = """
subscription ObjectSubscription($number: Int) {
  subscribeObjects(filter: {number: {gt: $number}}) {
    items {
      objectId, text, number
    }
  }
}
"""
```

And the `variables` parameter somethig like:

```swift
let variables: [String: Any] = ["number": 123]
```

When you no longer need the subscription, you can unsubscribe from it by using:

```swift
server.subscription(cancel: subscriptionId) { error in
  if (error == nil) {
    // do something
  }
}
```

### Result parsing

The query, mutation and subscription results type is a `[String: Any]` dictionary. This dictionary has exactly the same content what Hasura server sends back to the client app.

You should always be aware of what your (query, mutation or subscription) result will be, and take care of the dictionary content by yourself.

There are several different ways to parse and manage the result dictionary.

### Query Library

If you prefer to keep all your mutations, queries and subscriptions in a common library, then you shall add one (or multiple) `*.graphql` file(s) into your Xcode project. The content of these files should be something like this:

```graphql
mutation CreateObject($object: CreateObjectsInput!) {
  createObjects(input: $object) {
    objectId, text, number, double, boolean, createdAt, updatedAt
  }
}

mutation UpdateObject($object: UpdateObjectsInput!) {
  updateObjects(input: $object) {
    objectId, text, number, double, boolean, createdAt, updatedAt
  }
}

query ObjectQuery($updatedAt: String) {
  listObjects(filter: {updatedAt: {gt: $updatedAt}}) {
    items {
      objectId, text, number, double, boolean, createdAt, updatedAt
    }
  }
}

subscription ObjectSubscription {
  onUpdateObjects {
    objectId, text, number, double, boolean, createdAt, updatedAt
  }
}
```

These `*.graphql` files will be managed automatically by the Hasura SDK, so whenever you need a query, a mutation, or a subscription in your codebase, you can have it like this:

```swift
let query = HSQuery["CreateObject"]
```

```swift
let query = HSQuery["ObjectQuery"]
```

```swift
let query = HSQuery["ObjectSubscription"]
```

## Limitations

The Hasura SDK toolkit is in its initial release. It is functional and can handle most workloads.

---

© Related Code 2022 - All Rights Reserved