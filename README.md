## Description
This is a package to handle online and offline http requests. This package decides whether to load data locally or from the server, also this package helps your app to save data offline and sync later when the device has an internet connection.

You can make GET, POST, PUT, DELETE, or PATCH, and sync the data when
there isn't internet connection.

## Known issues
- You can't make an offline request if you send a `MultipartFile.fromFile`. You have to send `syncDataIfNoConnection: false` in the method parameters.

## Contributing

Contributions are welcomed!

Here is a list of how you can help:

- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Update the documentation / add examples
- Implement new features by making a pull-request