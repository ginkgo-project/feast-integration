include ../../../make.inc

help:
	@echo "Usage: make {all rall clean} "
	@echo "make all    -- compile/run all F90 examples for feast_dense interface "
	@echo "make rall   -- compile and run all C examples for feast_dense interface "
	@echo "make clean  -- clean all F90 examples for feast_dense interface "
	@echo "!!!!Please correct accordingly compiler and libraries paths, change compiler options " 
	@echo " in file ../../make.inc !!!!"
	@echo

#==============================================================
# Include the LIB (feast and  lapack - blas)  
#==============================================================
LIB = $(LOCLIBS) $(FEAST_DENSE) $(FEAST) $(FLIBS)
#==============================================================
# List of codes to be compiled 
#==============================================================
EXAMPLES = driver_zfeast_syevx driver_zfeast_syev driver_dfeast_gegv 
#==============================================================
# Compile Link Execute
#==============================================================
all: examples 


examples: 
	@echo $(EXAMPLES)
	@for file in $(EXAMPLES); \
	do \
		echo $(FORT)  $(FFLAGS) $(INCL) -c $$file.f90;\
		$(FORT)  $(FFLAGS) $(INCL) -c $$file.f90 ;\
		echo $(FORT)   -o $$file $$file.o $(LIB) ;\
		$(FORT)   -o $$file $$file.o  $(LIB) ;\
	done


rall: 	examples
	@for file in $(EXAMPLES); \
	do \
                ./$$file; \
	done
#==========================================
# Clean up directory: delete object files 
#==========================================
clean: 
	-@rm  $(EXAMPLES) *.o
