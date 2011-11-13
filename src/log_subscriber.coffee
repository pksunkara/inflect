# BulletSupport.LogSubscriber is an object set to consume BulletSupport.Notifications
# with the sole purpose of logging them. The log subscriber dispatches notifications to
# a registered object based on its given namespace.
#
# An example would be BulletRecord log subscriber responsible for logging queries:
#
# 	  class LogSubscriber extends BulletSupport.LogSubscriber
#   	  sql: (event) ->
#   	    "#{event.payload.name} (#{event.duration}) #{event.payload.sql}"
#
# And it's finally registered as:
#
#     TODO
#   	BulletRecord.LogSubscriber.attach_to bullet_record
#
# Since we need to know all instance methods before attaching the log subscriber,
# the line above should be called after your _BulletRecord.LogSubscriber_ definition.
#
# After configured, whenever a "sql.bullet_record" notification is published,
# it will properly dispatch the event (BulletSupport.Notifications.Event) to
# the sql method.
#
# Log subscriber also has some helpers to deal with logging and automatically flushes
# all logs when the request finishes (via bullet_dispatch.callback notification) in
# a Bullet environment.
class LogSubscriber

  # Embed in a String to clear all previous ANSI sequences.
  CLEAR: "\e[0m"
  BOLD : "\e[1m"

  # Colors
  BLACK  : "\e[30m"
  RED    : "\e[31m"
  GREEN  : "\e[32m"
  YELLOW : "\e[33m"
  BLUE   : "\e[34m"
  MAGENTA: "\e[35m"
  CYAN   : "\e[36m"
  WHITE  : "\e[37m"

  @log_subscribers: ->
    @log_subscribers_var ?= []

  # Set color by using a string or one of the defined constants. If a third
  # option is set to true, it also adds bold to the string. This is based
  # on the Highline implementation and will automatically append CLEAR to the
  # end of the returned String.
  color: (text, color, bold=false) ->
    bold = if bold then @BOLD else ""
    "#{bold}#{@[color.toUpperCase()]}#{text}#{@CLEAR}"

# Export LogSubscriber and Log subscriber class methods
module.exports = LogSubscriber
