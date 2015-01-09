all: numbers.txt

clean:
	rm char2value numbers.txt chars.txt words.txt pg34811.txt

prepare-debian:
	apt-get install sed wget octave epstool transfig

numbers.txt: chars.txt char2value.sed
	sed -f char2value.sed $^ > $@

char2value.sed: chars.txt
	sort -u $^ | \
	{ N=1; while read C ; do echo "s/$$C/$$N/" ; N=$$((N + 1)) ; done ; } \
	> $@

chars.txt: words.txt
	sed -nr 's/(\w)\w* /\1\n/gp' $^ > $@

words.txt: pg34811.txt Makefile
	sed -n '/^Erster Teil/,/^Überzeugung, eine/p' $^ \
	| sed 's/[^a-zA-ZäöüÄÖÜß]\+/ /g' \
	| tr '\t\n' '  ' \
	| sed 's/ \+/ /g' > $@

pg34811.txt:
	wget http://www.gutenberg.org/cache/epub/34811/pg34811.txt
