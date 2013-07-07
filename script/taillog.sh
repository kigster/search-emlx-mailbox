#!/bin/bash
rails_env=${RAILS_ENV:-development}
log=log/$rails_env.log
cat /dev/null > $log
tail -f $log
