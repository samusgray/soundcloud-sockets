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

`bin/run100k.sh`


### Run specs

Rspec unit tests are provided for the DeadLetterQueue and a few other new models.

```
rspec spec/
```


## Thoughts and process

I added some domain specific models to organize things in an extensible manner.
Incoming payloads are transformed into Message instances. Messages have corresponding
Events based on the message `kind`.

The first thing that stuck out to me was the giant case statement.

I replaced this with a system where a Message map's to event class based on it's `kind`. Now, in order to add an Event for new Message type, one adds an Event class in `models/events/`
and includes it's `kind` key in the routes defined by `EventDispatcher`.

I tried to make the code as self documenting as possible, but I also included inline documentation
to help illustrate my thinking behind each new class. As an applicant for the fullstack role, I really
hope this illustrates some of my backend abilities and I really, really hope I have the opportunity to
show you all what I can do in the browser!

Given more time I'd refactor the follower / following mechanics, possibly introduce a User model to
make these relationships easier to work with. The program is processing 100k in 0 seconds, currently,
but I'd like to profile the runtime to see if there are any major red flags to consider.

The concept of a dead letter queue isn't new to me. In other applications I've used Sidekick to manage
retries and such, but implementing one from scratch absolutely was new to me. I hope I understood the intention well enough. As is, it stores `Message`s in categories based on `kind` and spits out the queue at the end of the whole process. In production we'd want to prioritize the stored message based on product requirements and probably store them somewhere outside of the runtime in order to retry sending the payload in the future. These messages could be sent to a new thread specifically responsible for retries, which could skip a few steps and being being passed directly to the
`EventDispatcher`.


TODO:
  * Wrapp all the things in modules

## Future possibilities and ideas

I had a ton of fun working on this. I wasn't so familiar with the domain and thus did not test drive my solution. I circled back to add tests, hoping to at least show some of my testing practices for unit tests.

Besides better test coverage, here's what I'd consider working on if I spend more time on it:

* Profiling and optimization
* Refactor followers abstraction
  - Possibly introduce a User abstraction using a Set for follower management
