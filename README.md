# Heroku H12 Monitor

This daemon is designed to watch for "stuck" dynos reporting constant H12s (i.e. HTTP 503's) and selectively restart them.

## Why

Occasionally, a dyno can hang and get into a state where it's no longer responding to requests. Due to Heroku's routing mechanics, it will still route requests to this stuck dyno, which will then continue to report H12s. A dyno can get into this state for a number of reasons.

## This isn't a solution...

This monitor is designed as a stop-gap until you can debug and solve the underlying problem of why your dyno's get stuck. However, it can buy you some time while you debug.

## How to use

1. Log into Heroku and get your API key. It's on your My Account page.
2. Edit run.rb and add your API key to line 13. Set your heroku app name on line 14.
3. Run `bundle install`.
4. Start the app in a console by running `ruby run.rb`.

## TODO

1. Add daemon tools to ensure this is continuously running
2. The restarting line is currently commented out (see lib/dyno.rb:37) and untested. Putting this through a dry-run first before turning it on.
3. Could use some more coverage, mostly around the network connection stuff with the log streamer.