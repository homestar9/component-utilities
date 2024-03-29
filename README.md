# component-utilities

The purpose of this project is to demonstrate a simple component utility class method which extracts an object's public properties into a data transformation object (DTO). DTOs are simplified representations of complex objects which are ideal for passing around in an application, like a persistence layer, or to external APIs.  [You can learn more about DTOs here](https://en.wikipedia.org/wiki/Data_transfer_object).

Todo: Add additional utility methods for added functionality. 

## How Does This Work?

The `models` folder contains a subfolder called `utils` which is where the `ComponentUtilities` object lives.  At the root of the `models` folder is an `Entity` base class which, when constructed, creates an instance of `ComponentUtilities` as a dependency.  The `Entity` base class then exposes a special `getDto()` method which exposes the functionality within the dependency.

Since you should never instantiate a base class on its own, there are two entity classes, `User` and `Vessel` which extend the `Entity` base class.  Each of the entities has both public and private properties.

When you call `getDto()` on an entity, it should return a CFML structure containing all of the public properties of that object for easy transport.

The dump should look like this:

![example dump](https://i.imgur.com/y5WBWjA.png "example dump")


## How Can I Run This?

[Install Commandbox](https://www.ortussolutions.com/products/commandbox).  Download the repo into a subfolder on your computer.  Open CommandBox and navigate to the subfolder.  Type `server start` and Commandbox should automagically download and start up a CFML server for you.  By default, it should open a browser and load `index.cfm` in the web root.

You should see two object dumps. The first is a simple representation of an entity, the `User` class.  Note that the private property `secret` is not exposed in the DTO.  The second object dump, `Vessel` should reveal its data along with the child `User` saved as the property `Captain`.  Again, notice that the private properties of both classes `shieldFrequency` and `secret` are not exposed.

## What Is Going on Behind the Scenes?

When you call `getDto()` in an entity class, it calls the corresponding `getDto()` method in the `ComponentUtilities` dependency with a reference to the entity as an argument.  The component utility then examines the public properties of the entity and attempts to run getter methods to retrieve the data.  If the data returned is another entity or complex object, it attempts to run `getDto()` again recursively.

## Do You Have Any Ideas?

Do you know a way to make this utility more useful?  Are there other utility methods you can think of that would be beneficial to add?  Please feel free to submit pull requests or comment with your ideas. I would love to hear what you think!
