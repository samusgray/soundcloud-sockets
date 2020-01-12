# Follower Maze Challenge

See INSTRUCTIONS.MD for context.

## Setup

The only dependencies are `rspec` and `pry` for testing and debugging respectively.

```
bundle install
```

### Run the server

```
ruby app/app.rb
```

### Running the tester

From the project root, run:

`./bin/run100k.sh`


### Run specs

Rspec unit tests are provided for the DeadLetterQueue and a few other new models.

```
rspec spec/
```

## Future possibilities and ideas

Given more time I'd refactor the follower / following mechanics, possibly introduce a User model to
make these relationships easier to work with, or instead of that, at least a `UserFollowerTracker` sort of thing. Something besides a plain old hash.

The program is processing 100k in 0 seconds, currently. I've tested it with the `run30.sh` and `run100k.sh` with all sorts of different concurrency settings and seems to always run smoothly, but it would be fun to profile the runtime to see if there are any major red flags to consider.

The concept of a dead letter queue isn't new to me. In other applications I've used third parties to manage retries and such, but implementing one from scratch absolutely was new to me! I hope I understood the intention well enough. As is, it stores `Message`s in categories based on `kind` and spits out the queue at the end of the whole process (for demonstration purposes).

In order to retry sending each payload later we'd need to store them somewhere outside of the runtime. Depending on how many of these there are, it might be cool to prioritize each category based on any feedback from product folks on the team. When we retry sending a message, each could be sent to a new thread specifically responsible for them, which could skip also possibly skip a few steps by being  passed directly to the `EventDispatcher`.

Besides better test coverage, here's what I'd consider working on if I spend more time on it:

### Top ideas for future consideration
* Profiling and optimization
* Refactor followers abstraction
  - Possibly introduce a User abstraction using a Set for follower management
* Improve client and event server abstractions with more a flexible, single class
