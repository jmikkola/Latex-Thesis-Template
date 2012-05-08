TARGET=thesis
SOURCES=*.tex *.cls *.bib

#
# makefile
#
# Makefile for LaTeX Documents
#

SHELL=bash


#
# File-extensions to DELETE recursive from here
#
EXTENSION=aux toc idx ind ilg log out lof lot lol bbl blg bak

#
# Targets
#
all: $(TARGET).pdf


#
# Portable Document Format (PDF)
#
$(TARGET).pdf: $(SOURCES)
	@echo "-------------------------------------------------------------------------------"
	@echo "-- Running 'pdflatex $(TARGET).tex'"
	@echo "-------------------------------------------------------------------------------"
	@pdflatex $(TARGET).tex

	@echo ""
	@echo "-------------------------------------------------------------------------------"
	@echo "-- Running 'bibtex $(TARGET)'"
	@echo "-------------------------------------------------------------------------------"
	@bibtex $(TARGET) || @echo "----- BibTeX failed -----" || true

	@echo ""
	@echo "-------------------------------------------------------------------------------"
	@echo "-- Rerunning 'pdflatex $(TARGET).tex' to get cross-references right"
	@echo "-------------------------------------------------------------------------------"
	@pdflatex $(TARGET).tex

	@latex_count=5 ; \
	while egrep -s 'Rerun (LaTeX|to get cross-references right)' \
	$(TARGET).log && [ $$latex_count -gt 0 ] ;\
	do \
		echo "";\
		echo "-------------------------------------------------------------------------------";\
		echo "-- Rerunning 'pdflatex $(TARGET).tex' to get cross-references right" ;\
		echo "-------------------------------------------------------------------------------";\
		pdflatex $(TARGET).tex ;\
		latex_count=`expr $$latex_count - 1` ;\
	done

#
# Show in acroread
#
acroread: $(TARGET).pdf
	acroread $(TARGET).pdf&

#
# Show in kpdf
#
kpdf: $(TARGET).pdf
	okular $(TARGET).pdf &> /dev/null || evince $(TARGET).pdf &> /dev/null || open $(TARGET).pdf &> /dev/null &

#
# Show in preview (on Mac OS X)
#
preview: $(TARGET).pdf
	open $(TARGET).pdf

#
# Clean
#
clean:
	@for EXT in $(EXTENSION); do \
		find . -name \*\.$${EXT} -exec rm -vf \{\} \; ;\
	done
	@rm -vf $(TARGET).pdf

