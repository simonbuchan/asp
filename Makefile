BUILD = .build
PROGRAM = as3
OBJECTS = $(addprefix $(BUILD)/, as3.o as3.lex.o)

CXX = g++
LEX = flex

CXXFLAGS += -g --std=c++1y

all: as3

clean:
	rm -rf $(BUILD) as3

$(BUILD) :
	mkdir -p $@

# Don't require flex
.PRECIOUS: %.lex.cc

# Don't try to build these from %.lex.cc!
%.lex :
%.lex.cc : %.lex
	$(LEX) $(LFLAGS) --prefix $* -o $@ $^

$(OBJECTS) : | $(BUILD)
$(OBJECTS) : $(BUILD)/%.o : %.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<

as3 : $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^

