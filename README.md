# Follower Maze Challenge!

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

## Thoughts and process

The first thing that stuck out to me was the giant case statement and needless loop nesting. I replaced these with a system where incoming messages were transformed into a `Message` instance, which maps to event handler based on its `kind` attribute. In order to add new events to this system one adds a new event handler class in `app/models/events/` and includes it's `kind` key in the routes defined by `EventDispatcher`.

For event handlers, I chose composition over inheritance. There is an `Event::Base` which gets included in each new handler. Each event that uses it is required to implement its own `process` method which is responsible for looking up the correct users to notify, and passing that along to the `ClientPool` to get sent out.

I added a few other domain specific models to organize things. I tried to make the code as self documenting as possible, but I also included inline documentation to help illustrate my thinking behind each new class.

As an applicant for the fullstack role, I really hope this illustrates some of my backend abilities and I really, really hope I have the opportunity to show you all what I can do in the browser! I don't love the `EventServer` and `ClientServer` models (yo dog I heard you like servers lol); I'd really like to see a single socket / server abstraction that can handle incoming socket connections and packets for broader use cases.

#### Small note
I removed my git history per the request for anonymity. I would prefer to read code like this commit by commit, but I thought t remove it here because, yeah.

## Future possibilities and ideas

Given more time I'd refactor the follower / following mechanics, possibly introduce a User model to
make these relationships easier to work with, or instead of that, at least a `UserFollowerTracker` sort of thing. Something besides a plain old hash.

The program is processing 100k in 0 seconds, currently. I've tested it with the `run30.sh` and `run100k.sh` with all sorts of different concurrency settings and seems to always run smoothly, but it would be fun to profile the runtime to see if there are any major red flags to consider.

The concept of a dead letter queue isn't new to me. In other applications I've used third parties to manage retries and such, but implementing one from scratch absolutely was new to me! I hope I understood the intention well enough. As is, it stores `Message`s in categories based on `kind` and spits out the queue at the end of the whole process (for demonstration purposes).

In order to retry sending each payload later we'd need to store them somewhere outside of the runtime. Depending on how many of these there are, it might be cool to prioritize each category based on any feedback from product folks on the team. When we retry sending a message, each could be sent to a new thread specifically responsible for them, which could skip also possibly skip a few steps by being  passed directly to the `EventDispatcher`.

I had a ton of fun working on this. I wasn't so familiar with the domain and thus did not test drive my solution. I circled back to add tests, hoping to at least show some of my testing practices for unit tests. Besides better test coverage, here's what I'd consider working on if I spend more time on it:

### Top ideas for consideration
* Profiling and optimization
* Refactor followers abstraction
  - Possibly introduce a User abstraction using a Set for follower management
* Improve client and event server abstractions with more a flexible, single class

# Thanks reviewer!

Thank you for taking the time to read my project! https://www.youtube.com/watch?v=zkBMpngSy3Y
