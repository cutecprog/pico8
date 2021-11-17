#! /bin/bash
~/pico-8/pico8 &
while true; do
	inotifywait -qq -e CLOSE_WRITE ~/.lexaloffle/pico-8/carts/*.p8
	cd ~/.lexaloffle/pico-8/carts
	git add *.p8
	if test -f msg.p8l; then
		git commit -a -F msg.p8l
		rm msg.p8l
	else
		git commit -am "autocommit"
	fi
done
