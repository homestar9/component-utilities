# component-utilities

The purpose of this project is to demonstrate a simple component utility class which assists in extracting an object's public properties into a data transformation object (DTO). DTOs are simplified representations of complex objects which are ideal for passing data around an application (like your persistence layer) or to external APIs.  [You can learn more about DTOs here](https://en.wikipedia.org/wiki/Data_transfer_object).

## How Does This Work?

The `models` folder contains a subfolder called `utils` which is where the `ComponentUtilities` object lives.  At the root of the `models` folder is an `Entity` base class which, when constructed creates an instance of `ComponentUtilities` as a dependency.  The `Entity` base class then exposes a special `getDto()` method which exposes the functionality within the dependency.

Since you should never instantiate a base class on its own, there are two entity classes, `User` and `Vessel` which extend the `Entity` base class.  Each of the entities have both public and private properties.

When you call `getDto()` on an entity, it should return a CFML structure containing all of the public properties of that object for easy transport.

## How Can I Run This?

[Install Commandbox](https://www.ortussolutions.com/products/commandbox).  Download the repo into a subfolder on your computer.  Open CommandBox and navigate to the subfolder.  Type `server start` and Commandbox should automagically download and start up a CFML server for you.  By default it should open a browser and load `index.cfm` in the web root.

You should see two object dumps. The first is a simple representation of an entity, the `User` class.  Note that the private property `secret` is not exposed in the DTO.  The second object dump, `Vessel` should reveal its data along with the child `User` saved as the property `Captain`.  Again, notice that the private properties of both classes `shieldFrequency` and `secret` are not exposed.

## What Is Going on Behind the Scenes?

When you call `getDto()` in an entity class, it calls the corresponding `getDto()` method in the `ComponentUtilities` dependency with a reference to the entity as an argument.  The component utlity then examines the public properties of the entity and attempts to run getter methods to retrieve the data.  If the data returned is another entity or complex object, it attempts to run `getDto()` again recursively.
