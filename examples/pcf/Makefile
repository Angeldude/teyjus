# Modify the path to the Teyjus executables as needed
TEYJUS= ../../source

.PHONY: all eval monotyping polytyping tailrecursion
all: eval monotyping polytyping tailrecursion

eval: eval_test.lp
monotyping: mono_test.lp
polytyping: poly_test.lp
tailrecursion: tr_test.lp

# Everything after this point is generic and should be duplicated
# in user's makefiles

%.lpo : %.mod %.sig
	$(TEYJUS)/tjcc $*

%.lp : %.lpo
	$(TEYJUS)/tjlink $*

-include depend
depend: *.mod *.sig
	$(TEYJUS)/tjdepend *.mod > depend-stage
	mv depend-stage depend

.PHONY: clean
clean:
	rm -f *.lpo *.lp depend
