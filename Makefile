.PHONY: all lib test webclient

COFFEE=node_modules/.bin/coffee
UGLIFY=node_modules/.bin/uglifyjs

# Build the types into javascript in lib/ for nodejs
all: lib webclient

clean:
	rm -rf lib
	rm -rf webclient

test:
	node_modules/.bin/mocha

lib:
	rm -rf lib
	coffee -cbo lib src

webclient/%.uncompressed.js: src/%.coffee before.js after.js
	mkdir -p webclient
	cat before.js > $@
	$(COFFEE) -bpc $< >> $@
	cat after.js >> $@

# Uglify.
webclient/%.js: webclient/%.uncompressed.js
	$(UGLIFY) $< -cmo $@

# Compile the types for a browser.
webclient: webclient/text.js webclient/text-tp2.js
#webclient/json.js won't work yet - it needs the helpers and stuff compiled in as well.

