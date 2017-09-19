# Heroku H12 Monitor

This daemon is designed to watch for "stuck" dynos reporting constant H12s (i.e. HTTP 503's) and selectively restart them.

## Why

Occasionally, a dyno can hang and get into a state where it's no longer responding to requests. Due to Heroku's routing mechanics, that stuck dyno will still receive requests from the router, which will then continue to report H12s.

A dyno can get into this state for a number of reasons, though getting to the root of problem is the only way to a lasting solution.

## How it works

When run, it will connect to the Heroku API and open a streaming HTTP connection to the Heroku logplex, monitoring router events. Each log message is parsed and the `code` is looked at to determine if it's an H12. The alogorithm it follows is:

  * If a dyno reports an H12, increment a counter for that dyno
    * If the dyno exceeds 3 consecutive H12s, issue a restart.
  * Whenever a dyno successfully processes a request, reset the counter.

Thus, a dyno must report three consecutive H12s in order to be considered "stuck". The script will then issue a restart via the Heroku API.

## How to use it

1. Log into Heroku and get your API key. It's on your My Account page.
2. Edit h12-monitor.rb and add your API key to line 14. Set your heroku app name on line 15.
3. Run `bundle install`.
4. Start the app by running `ruby h12-monitor.rb run`

## Example output

When running it in the foreground (i.e. with the `run` option), you'll see output similar to the following:

    $ ruby h12-monitor.rb run
    h12-monitor.rb: process with pid 40464 started.
    I, [2013-02-18T14:38:46.540868 #40464]  INFO -- : Connecting to Heroku logplex for myapp-production.
    I, [2013-02-18T14:52:07.955868 #40464]  INFO -- : myapp-production: monitored 50 lines, 18 dynos reporting
    I, [2013-02-18T15:06:13.414261 #40464]  INFO -- : myapp-production: monitored 100 lines, 20 dynos reporting
    W, [2013-02-18T15:06:14.038075 #40464]  WARN -- : web.12 reports H12 (#1)
    W, [2013-02-18T15:06:14.038225 #40464]  WARN -- : web.12 reports H12 (#2)
    W, [2013-02-18T15:06:14.038402 #40464]  WARN -- : web.12 reports H12 (#3)
    W, [2013-02-18T15:06:14.038443 #40464]  WARN -- : restarting dyno web.12
    I, [2013-02-18T15:06:18.677463 #40464]  INFO -- : myapp-production: monitored 150 lines, 20 dynos reporting

The monitor will print a status line every 50 log lines it processes. If it detects an H12 on a dyno, it will print a WARN message. After three consecutive H12s for the same dyno, it will restart it.

## This isn't a solution...

This monitor is designed as a stop-gap until you can debug and solve the underlying problem of why your dyno's get stuck. However, it can buy you some time while you debug.

## TODO

1. Could use some more coverage, mostly around the network connection stuff with the log streamer.

## License

h12-monitor is Copyright © 2013 Ryan Twomey. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
