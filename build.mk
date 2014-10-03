# Find source files in the source directory
SRCDIR := $(dir $(lastword $(MAKEFILE_LIST)))
vpath % $(SRCDIR)
vpath %.lex.cc $(CURDIR)

all :

CXX = g++
LEX = flex

CXXFLAGS += -g --std=c++1y -I$(SRCDIR)

PROGRAM = as3
SOURCES = as3.cc as3.lex.cc
OBJECTS = $(SOURCES:.cc=.o)
DEPENDS = $(SOURCES:.cc=.d)

all: as3 test-as3

# Don't try to build these from %.lex.cc!
%.lex :
%.lex.cc : %.lex
	$(LEX) $(LFLAGS) --prefix $* -o $@ $^
clean::
	rm -f *.lex.cc
$(OBJECTS) : %.o : %.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<
clean::
	rm -f *.o

$(PROGRAM) : $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^
clean::
	rm -f $(PROGRAM)

test-as3 : as3
	$(SRCDIR)tests/run

$(DEPENDS) : %.d : %.cc
	$(CXX) $(CXXFLAGS) -MM -o $@ $<

include $(DEPENDS)
