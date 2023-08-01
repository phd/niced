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
ifneq ($(shell id -u), 0)
	sudo make $@
else
	mkdir -p /usr/bin
	cp niced /usr/bin/
	mkdir -p /etc/systemd/system
	cp niced.service /etc/systemd/system/
	mkdir -p /etc
	cp nicedrc /etc/
endif

uninstall:
ifneq ($(shell id -u), 0)
	sudo make $@
else
	rm -f /usr/bin/niced
	rm -f /etc/systemd/system/niced.service
endif

remove: uninstall

purge: uninstall
ifneq ($(shell id -u), 0)
	sudo make $@
else
	rm -f /etc/nicedrc
endif
