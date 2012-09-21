# make console.whatever safe in IE
unless window.console and window.console.log
  noop = ->

  methods = ["assert", "clear", "count", "debug", "dir", "dirxml", "error", "exception", "group", "groupCollapsed", "groupEnd", "info", "log", "markTimeline", "profile", "profileEnd", "table", "time", "timeEnd", "timeStamp", "trace", "warn"]
  console = window.console = {}
  console[method] = noop for method in methods
  
# alias "window.log" to "console.log"
window.log = -> console.log.apply console, arguments