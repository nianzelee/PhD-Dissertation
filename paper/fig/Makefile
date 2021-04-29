pdflatex-options = -output-directory=./build -halt-on-error
tex-folder = precompile-tex
tex-names = $(shell ls $(tex-folder))
tex-name = 

single:
	@pdflatex $(pdflatex-options) $(tex-folder)/$(tex-name)

all:
	@for i in $(tex-names); do \
        make tex-name=$$i single; \
    done

clean:
	@rm -f ./build/*.aux
	@rm -f ./build/*.log
