

# 
VERSION := $(shell grep '^Version:' DESCRIPTION | awk '{print $$2}')


.PHONY: test
test:
	Rscript -e "tinytest::test_all()"
	##Rscript -e "library(TransitionModels); tinytest::test_all()"

.PHONY: coverage
coverage:
	Rscript -e "covr::report(file = \"_coverage.html\")"

.PHONY: install
install:
	@echo Installing current version: $(VERSION)
	(cd ../ && \
		R CMD build --no-build-vignettes TransitionModels && \
		R CMD INSTALL TransitionModels_$(VERSION).tar.gz)
####R CMD INSTALL TransitionModels_$(VERSION).tar.gz --configure-args="--enable-verbose")

.PHONY: check
check:
	@echo Checking current version: $(VERSION)
	(cd ../ && \
		R CMD build --no-build-vignettes TransitionModels && \
		R CMD check --as-cran TransitionModels_$(VERSION).tar.gz)
