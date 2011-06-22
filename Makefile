all: babel.pdf

EXP_BLOCKS=~/.emacs.d/src/org/lisp/org-exp-blocks.el
CC=gcc

.PHONY: pdf
pdf: babel.pdf

babel.tex: babel.org
	emacs --batch -Q -l init.el -l $(EXP_BLOCKS) babel.org -f org-export-as-latex
# The above line has a hackey site-specific fix loading code which has
# not yet been added to Emacs.
#	emacs --batch -Q -l init.el babel.org -f org-export-as-latex

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
	emacs --batch -Q -l init.el -l $(EXP_BLOCKS) babel.org -f org-babel-tangle

cocktail: cocktail.c
	$(CC) -o cocktail cocktail.c

clean:
	rm -f *.aux *.log babel.ps *.dvi *.blg *.bbl *.toc *.tex *~ *.out babel.pdf cocktail*

real-clean: clean
	rm -f country-codes.csv raw-temps.csv *.pdf *.sqlite
