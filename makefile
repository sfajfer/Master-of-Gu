# List all chapter markdown files except the index file
CHAPTERS = $(filter-out Gu Index.md, $(sort $(wildcard *.md)))

# Default target
all: book

# Individual PDF rule
%.pdf: %.md
	pandoc "$<" -o "$@"

# Create standalone index PDF
GuIndex:
	pandoc ./'gu index'/'Gu Index.md' --lua-filter=./columns.lua --output 'Gu_Index.pdf'

CheatSheet:
	pandoc ./'cheat sheet'/CheatSheet.md --lua-filter=./columns.lua --output 'CheatSheet.pdf'

# Build book using processed index
book: GuIndex CheatSheet $(CHAPTERS)
	pandoc $(foreach chapter,$(CHAPTERS),"$(chapter)") -o Chapters.pdf
	cpdf Chapters.pdf Gu_Index.pdf CheatSheet.pdf -o Southern_Border_Master_Of_Gu.pdf
	del Chapters.pdf

# Debug target
debug:
	@echo "CHAPTERS: $(CHAPTERS)"
	@echo "Each chapter:"
	@$(foreach chapter,$(CHAPTERS),echo "  '$(chapter)';)

.PHONY: all clean GuIndex debug