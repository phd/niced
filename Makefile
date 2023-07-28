all: check

check:
	python -m py_compile niced
	rm -rf __pycache__

pylint:
	pylint niced

install:
	mkdir -p /usr/bin
	cp niced /usr/bin/
	mkdir -p /etc/systemd/system
	cp niced.service /etc/systemd/system/
	mkdir -p /etc
	cp nicedrc /etc/

uninstall:
	rm -f /usr/bin/niced
	rm -f /etc/systemd/system/niced.service

remove: uninstall

purge: uninstall
	rm -f /etc/nicedrc
