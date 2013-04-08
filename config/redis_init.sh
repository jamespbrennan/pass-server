#!/bin/sh
#
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.
set -e

REDISPORT=6379
APP_ROOT=/home/deployer/apps/pass-server/current
PIDFILE=/var/run/redis_${REDISPORT}.pid
CONF="$APP_ROOT/config/redis.conf"
CMD="/usr/local/bin/redis-server $CONF"
CLIEXEC=/usr/local/bin/redis-cli

AS_USER=deployer
set -u

run () {
  if [ "$(id -un)" = "$AS_USER" ]; then
    eval $1
  else
    su -c "$1" - $AS_USER
  fi
}


case "$1" in
  start)
    if [ -f $PIDFILE ]
    then
      echo >&2 "$PIDFILE exists, process is already running or crashed"
    else
      echo >&2 "Starting Redis server..."
      run "$CMD"
    fi
    ;;
  stop)
    if [ ! -f $PIDFILE ]
    then
      echo >&2 "$PIDFILE does not exist, process is not running"
    else
      PID=$(cat $PIDFILE)
      echo >&2 "Stopping ..."
      $CLIEXEC -p $REDISPORT shutdown
      while [ -x /proc/${PID} ]
      do
          echo >&2 "Waiting for Redis to shutdown ..."
          sleep 1
      done
      echo >&2 "Redis stopped"
    fi
    ;;
  restart|reload)
    if [ ! -f $PIDFILE ]
    then
      echo >&2 "$PIDFILE does not exist, process is not running"
    else
      PID=$(cat $PIDFILE)
      echo >&2 "Stopping ..."
      $CLIEXEC -p $REDISPORT shutdown
      while [ -x /proc/${PID} ]
      do
          echo >&2 "Waiting for Redis to shutdown ..."
          sleep 1
      done
      echo >&2 "Redis stopped"
    fi
    
    echo >&2 "Starting Redis server..."
    run "$CMD" && echo reloaded OK && exit 0
    ;;
  *)
    echo >&2 "Usage: $0 <start|stop|restart>"
    exit 1
    ;;
esac
