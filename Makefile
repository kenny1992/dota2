define HELPBODY
Available commands:

	make help       - this thing.
	make init       - install python dependancies
	make test       - run tests and coverage
	make pylint     - code analysis
	make build      - pylint + test

endef

export HELPBODY
help:
	@echo "$$HELPBODY"

init:
	pip install -r requirements.txt

test:
	coverage erase
	PYTHONHASHSEED=0 nosetests --verbosity 1 --with-coverage --cover-package=dota2

pylint:
	pylint -r n -f colorized dota2 || true

build: pylint test

clean:
	rm -rf dist dota2.egg-info dota2/*.pyc

dist: clean
	python setup.py sdist

register:
	python setup.py register -r pypi

upload: dist register
	twine upload -r pypi dist/*

pb_fetch:
	wget -nv --show-progress -N -P ./dota2/protobufs/ -i protobuf_list.txt

pb_compile:
	for filepath in `ls ./dota2/protobufs/*.proto`; do \
		protoc --python_out ./dota2/protobufs/ --proto_path=/usr/include --proto_path=./dota2/protobufs "$$filepath"; \
	done;

pb_clear:
	rm -f ./dota2/protobufs/*.proto

pb_update: pb_fetch pb_compile pb_clear
