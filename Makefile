publish-docs:
	rm -rf ./node_modules
	npm install
	git checkout -b gh-pages
	./node_modules/.bin/bit-docs -fd
	git add -f docs/
	git commit -m "Publish docs"
	git push -f origin gh-pages
	git checkout -
	git branch -D gh-pages
