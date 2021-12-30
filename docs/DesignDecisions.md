
# Design Decisions

## Why was this library developed?

his library was originally developed to support a flutter Bluetooth library for Concept2 fitness equipment. However, because many other fitness equipment manufacturers are likely to use CSAFE, it seeemed like a useful thing to break out into a separate dart-only library in case someone else is able to make use of it for a different project supporting different fitness equipment.


## The Placeholder System

The concept of Placeholder values is not part of the the spec, but is a feature of this library that allows other libraries or applications to share responsibility for creating commands. For example, libraries can create CommandFactory objects that pre-fill technical details like the command identifier and set up placeholders of a defined size to allow applications or libraries downstream to provide the value of the parameter (like the distance to set a workout for) without requiring this downstream code to know as many technical details of how the "set up a workout" command is implemented.
