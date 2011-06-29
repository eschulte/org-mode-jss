CC=gcc
EMACS=emacs
BATCH_EMACS=$(EMACS) --batch -Q -l init.el babel.org
REQUIREMENTS=curl dot perl python R sh sqlite3

all: babel.pdf

babel.tex: babel.org
	$(BATCH_EMACS) -f org-export-as-latex

babel.pdf: babel.tex
	rm -f babel.aux 
	if pdflatex babel.tex </dev/null; then \
		true; \
	else \
		stat=$$?; touch babel.pdf; exit $$stat; \
	fi
	bibtex babel
	while grep "Rerun to get" babel.log; do \
		if pdflatex babel.tex </dev/null; then \
			true; \
		else \
			stat=$$?; touch babel.pdf; exit $$stat; \
		fi; \
	done

babel.ps: babel.pdf
	pdf2ps babel.pdf

cocktail.c: babel.org
	$(BATCH_EMACS) -f org-babel-tangle

cocktail: cocktail.c
	$(CC) -o cocktail cocktail.c

check:
	for req in $(REQUIREMENTS); do \
		which $$req > /dev/null || echo "MISSING DEPENDENCY $$req"; \
	done

clean:
	rm -f *.aux *.log babel.ps *.dvi *.blg *.bbl *.toc *.tex *~ *.out babel.pdf cocktail*

real-clean: clean
	rm -f country-codes.csv raw-temps.csv *.pdf *.sqlite
