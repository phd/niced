all: check

check: syntax pylint pycodestyle

syntax:
	python3 -m py_compile niced
	rm -rf __pycache__

pylint:
	pylint niced

pycodestyle:
	pycodestyle niced

run:
	sudo ./niced --config-file ./niced.conf

man:
	man ./niced.8

install:
ifneq ($(shell id -u), 0)
	sudo make $@
else
	mkdir -p /usr/bin
	cp niced /usr/bin/
	mkdir -p /etc/systemd/system
	cp niced.service /lib/systemd/system/
	mkdir -p /etc
	cp -n niced.conf /etc/
	mkdir -p /usr/share/man/man8/
	cp niced.8 /usr/share/man/man8/
	systemctl daemon-reload
endif

uninstall:
ifneq ($(shell id -u), 0)
	sudo make $@
else
	rm -f /usr/bin/niced
	rm -f /lib/systemd/system/niced.service
endif

remove: uninstall

purge: uninstall
ifneq ($(shell id -u), 0)
	sudo make $@
else
	rm -f /etc/niced.conf
endif

service_status:
	sudo systemctl status niced.service

service_enable:
	sudo systemctl enable niced.service

service_disable:
	sudo systemctl disable niced.service

service_start:
	sudo systemctl start niced.service

service_stop:
	sudo systemctl stop niced.service

service_restart:
	sudo systemctl restart niced.service

service_logs:
	sudo journalctl -u niced.service -b
