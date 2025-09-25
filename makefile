# List all chapter markdown files except the gu index (it needs a special command for the double columns)
CHAPTERS = $(sort $(wildcard ./chapters/*.md))

# Default target
all: book

# Individual PDF rule
%.pdf: %.md
	pandoc "$<" -o "$@"

# Create standalone gu index PDF
GuIndex:
	pandoc ./'gu index'/'Gu Index.md' --lua-filter=./libraries/columns.lua --output 'Gu_Index.pdf'

# Create standalone cheat sheet PDF
CheatSheet:
	pandoc ./'cheat sheet'/Cheat_Sheet.md --lua-filter=./libraries/columns.lua --output 'Cheat_Sheet.pdf'

# Build the book from the chapters, gu index, and the cheat sheet on the back
book: GuIndex CheatSheet $(CHAPTERS)
	pandoc $(foreach chapter,$(CHAPTERS),"$(chapter)") -o Chapters.pdf
	cpdf Chapters.pdf Gu_Index.pdf Cheat_Sheet.pdf -o Southern_Border_Master_Of_Gu.pdf
	del Chapters.pdf

# Debug target
debug:
	@echo "CHAPTERS: $(CHAPTERS)"
	@echo "Each chapter:"
	@$(foreach chapter,$(CHAPTERS),echo "  '$(chapter)';)

.PHONY: all clean GuIndex debug