clean:
	@Rscript -e 'devtools::clean_dll("cpp4rtest"); cpp4r::register("cpp4rtest")'

test:
	@echo "Testing R code"
	@Rscript -e 'devtools::document(); devtools::test(); devtools::install()'
	@echo "Testing C++ code"
	@Rscript -e 'devtools::clean_dll("cpp4rtest"); devtools::load_all("cpp4rtest"); devtools::test("cpp4rtest")'

check:
	@echo "Checking R code"
	@Rscript -e 'devtools::install(); devtools::check()'
	@echo "Checking C++ code"
	@Rscript -e 'devtools::check("cpp4rtest")'
	
site:
	@Rscript -e 'devtools::document(); pkgdown::build_site()'

install:
	@Rscript -e 'devtools::clean_dll("cpp4rtest"); devtools::install()'

clang_format=`which clang-format-18`

format: $(shell find . -name '*.h') $(shell find . -name '*.hpp') $(shell find . -name '*.cpp')
	@${clang_format} -i $?
