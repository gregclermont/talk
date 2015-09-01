SRCS=objects.rb

all: $(SRCS:.rb=.png)

%.png: %.dot
	dot $< -Tpng -o $@

%.dot: %.rb
	ruby $< > $@

.PRECIOUS: %.dot

clean:
	rm -f $(SRCS:.rb=.dot) $(SRCS:.rb=.png)
