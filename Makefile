CXX = g++
LEX = flex

CXXFLAGS = -g --std=c++1y

all: as3

clean:
	rm -f *.o as3

# Don't require flex
.PRECIOUS: %.lex.cc

%.lex.cc : %.lex
	$(LEX) $(LFLAGS) --prefix $* -o $@ $^

as3 : as3.o as3.lex.o
	$(CXX) $(CXXFLAGS) -o $@ $^

