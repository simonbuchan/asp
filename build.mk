# Find source files in the source directory
SRCDIR=$(dir $(lastword $(MAKEFILE_LIST)))
vpath % $(SRCDIR)

PROGRAM = as3
OBJECTS = as3.o as3.lex.o

CXX = g++
LEX = flex

CXXFLAGS += -g --std=c++1y -I$(SRCDIR)

all: as3

clean:
	rm -rf *.o as3

# Don't try to build these from %.lex.cc!
%.lex :
vpath %.lex.cc $(CURDIR)
%.lex.cc : %.lex
	$(LEX) $(LFLAGS) --prefix $* -o $@ $^

$(OBJECTS) : %.o : %.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<

as3 : $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^
