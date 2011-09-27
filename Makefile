CC=gcc
EMACS=emacs
BATCH_EMACS=$(EMACS) --batch -Q -l init.el jss705.org
REQUIREMENTS=curl dot perl python R sh sqlite3

all: jss705.pdf

jss705.tex: jss705.org init.el
	$(BATCH_EMACS) -f org-export-as-latex

jss705.pdf: jss705.tex
	rm -f jss705.aux 
	if pdflatex jss705.tex </dev/null; then \
		true; \
	else \
		stat=$$?; touch jss705.pdf; exit $$stat; \
	fi
	bibtex jss705
	while grep "Rerun to get" jss705.log; do \
		if pdflatex jss705.tex </dev/null; then \
			true; \
		else \
			stat=$$?; touch jss705.pdf; exit $$stat; \
		fi; \
	done

jss705.ps: jss705.pdf
	pdf2ps jss705.pdf

cocktail.c: jss705.org
	$(BATCH_EMACS) -f org-jss705-tangle

cocktail: cocktail.c
	$(CC) -o cocktail cocktail.c

check:
	for req in $(REQUIREMENTS); do \
		which $$req > /dev/null || echo "MISSING DEPENDENCY $$req"; \
	done

clean:
	rm -f *.aux *.log jss705.ps *.dvi *.blg *.bbl *.toc *.tex *~ *.out jss705.pdf cocktail*

real-clean: clean
	rm -f country-codes.csv raw-temps.csv *.pdf *.sqlite
