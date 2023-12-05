#!/bin/sh

gopass sync || gopass clone git@gitlab.n0de.biz:keystores/$(hostname).git
