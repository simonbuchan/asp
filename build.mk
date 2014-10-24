# Find source files in the source directory
SRCDIR := $(dir $(lastword $(MAKEFILE_LIST)))
vpath % $(SRCDIR)
vpath %.lex.cc $(CURDIR)

all :

CXX = clang++
LEX = flex

CXXFLAGS += -g --std=c++1y -I$(SRCDIR)

PROGRAM = as3
SOURCES += as3.cc
SOURCES += as3.lex.cc
SOURCES += tok.cc op.cc
SOURCES += parse.cc parse_expression.cc
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

-include $(DEPENDS)
