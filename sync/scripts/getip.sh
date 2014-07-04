#!/bin/bash

sudo ifconfig eth0 | grep inet.addr | sed -re "s/.*addr:([^ ]+) .*$/\1/"

