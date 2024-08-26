version = $(shell poetry version -s)

python_sources = $(wildcard st_cookie_manager/*.py) pyproject.toml MANIFEST.in
js_sources := $(wildcard st_cookie_manager/public/*) $(wildcard st_cookie_manager/src/*) st_cookie_manager/tsconfig.json
js_npm_install_marker = st_cookie_manager/node_modules/.package-lock.json

build: st_cookie_manager/build/index.html sdist wheels

sdist: dist/st-cookie-manager-$(version).tar.gz
wheels: dist/st_cookie_manager-$(version)-py3-none-any.whl

js: st_cookie_manager/build/index.html

dist/st-cookie-manager-$(version).tar.gz: $(python_sources) js
	poetry build -f sdist

dist/st_cookie_manager-$(version)-py3-none-any.whl: $(python_sources) js
	poetry build -f wheel

st_cookie_manager/build/index.html: $(js_sources) $(js_npm_install_marker)
	cd st_cookie_manager && npm run build

$(js_npm_install_marker): st_cookie_manager/package.json st_cookie_manager/package-lock.json
	cd st_cookie_manager && npm install

clean:
	-rm -r -f dist/* st_cookie_manager/build/*
