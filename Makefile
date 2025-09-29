clean:
	@Rscript -e 'devtools::clean_dll()'
	@Rscript -e 'devtools::clean_dll("cpp4rtest")'

test:
	@echo "Testing R code"
	@Rscript -e 'devtools::document(); devtools::test(); devtools::install()'
	@echo "Testing C++ code"
	@Rscript -e 'devtools::clean_dll("cpp4rtest"); devtools::load_all("cpp4rtest"); devtools::test("cpp4rtest")'

check:
	@echo "Local"
	@Rscript -e 'devtools::install()'
	@Rscript -e 'devtools::check(); devtools::check("cpp4rtest")'

site:
	@Rscript -e 'devtools::document()'
	@Rscript -e 'pkgdown::build_site()'

install:
	@Rscript -e 'devtools::install()'

clang_format=`which clang-format-20`

format: $(shell find . -name '*.h') $(shell find . -name '*.hpp') $(shell find . -name '*.cpp')
	@${clang_format} -i $?
