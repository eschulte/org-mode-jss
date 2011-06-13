all: babel.pdf

.PHONY: pdf
pdf: babel.pdf

babel.tex: babel.org
	emacs --batch -Q -l init.el -l ~/.emacs.d/src/org/lisp/org-exp-blocks.el babel.org -f org-export-as-latex

babel.pdf: babel.tex
	rm -f babel.aux 
	if pdflatex babel.tex </dev/null; then \
		true; \
	else \
		stat=$$?; touch babel.pdf; exit $$stat; \
	fi
	bibtex babel
	while grep "Rerun to get cross" babel.log; do \
		if pdflatex babel.tex </dev/null; then \
			true; \
		else \
			stat=$$?; touch babel.pdf; exit $$stat; \
		fi; \
	done

babel.ps: babel.pdf
	pdf2ps babel.pdf

clean:
	rm -f *.aux *.log babel.ps *.dvi *.blg *.bbl *.toc *.tex *~ *.out babel.pdf 
