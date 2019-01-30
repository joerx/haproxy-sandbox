#!/bin/sh

set -ex

# Demo script to test redis connectivity via proxy
# Need to have redis-cli installed for this to work

redis-cli -p 6380 set 'current_date' $(date +%s)
redis-cli -p 6380 get 'current_date'
