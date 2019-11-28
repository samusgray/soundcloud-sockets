
Added some domain specific models to organize things in an extensible mannor.
Incoming payloads are transformed into Message model instances. Messages have coresponding
Events based on the message `kind`.

In order to add Events for new Message types, one adds an Event model in `models/events/`
and adds the `kind` key to the `EventDispatcher`.


TODO:
  * RDOC all the classes
  * Wrapp all the thingns in modules
  * Validate message strings
  * Specs for DLQ

## Future posabilities and ideas
* Profiling and optimization
* Error handling issues from event stream
  - Message with incorrect formatting

* Refactor followers abstraction
  - Possibly introduce a User abstraction using a Set for follower management
