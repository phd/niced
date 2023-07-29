all: check

check: syntax pylint pycodestyle

syntax:
	python -m py_compile niced
	rm -rf __pycache__

pylint:
	pylint niced

pycodestyle:
	pycodestyle niced

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
