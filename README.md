# address formatting

### A quick example


Given a set of address parts

     house_number:  17
     road:          Rue du Médecin-Colonel Calbairac
     neighbourhood: Lafourguette
     suburb:        Toulouse Ouest
     postcode:      31000
     city:          Toulouse
     county:        Toulouse
     state:         Midi-Pyrénées
     country:       France
     country_code:  FR

you want to write logic to compile addresses in the format

	17 Rue du Médecin-Colonel Calbairac
	31000 Toulouse
	France

or simply

	Rue du Médecin-Colonel Calbairac, Toulouse


This repository contains templates for various address formats around the world to get you started. It also contains test cases.




### Which addresses we're talking about

The intended use-case is database or geocoding systems (forward, reverse, autocomplete) were we know both the country of the address and the language of the user/reader. The address is displayed and not used to print on an envelope.
It is in use on the [OpenCage Geocoder](http://geocoder.opencagedata.com)

We have to deal with

   * incomplete data
   * anything with a name (peaks, bridges, bus stops)
  
   
Unlike [physical post (office) mail](http://www.bitboost.com/ref/international-address-formats.html]) we don't have to deal with

   * Apartment, floor numbers
   * PO boxes
   * using the language of the (destination) address

   


### Write your own formatting logic

We've written a Perl module ([Geo::Address](http://search.cpan.org/perldoc?Geo::Address)) and test suite which uses this configuration, but wanted to make it easy for others to write similar modules in other programming languages. If you do, please let us know so we can feature it here. 


### File format

The files are in [YAML](http://yaml.org/) format. The templates are written in [Mustache](http://mustache.github.io/). Both formats are human readable, strict, solve escaping and support comments. YAML allows references (called "ankers") to avoid copy&paste, Mustache allows sub-templates (called "partials").



### The future

Support all countries in the world.

With more test cases in the future the format needs to evolve. For every rule about addresses there are exceptions and edge cases to consider. Just remember Maybe version 2 will use a custom [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) or embedded [Lua](http://www.lua.org/about.html).

Planned features

  * shorten addresses, e.g. 'Hoover Str' instead of 'Hoover Street'
  * basic formatting of 8/9 digit postcodes
  * text highlighting
  * de-duplication
  * right-to-left

We welcome your pull requests

### Who are we?

Founded in 2006 and based in London, [Lokku](http://www.lokku.com) are long time supporters of OpenStreetMap and open data initiatives. We run the [OpenCage Geocoder](http://geocoder.opencagedata.com). We’re best known for [Nestoria](http://www.nestoria.com), our property search engine where we manage lots of data (geo and otherwise). We also run [#geomob](http://geomobldn.org), a meetup of London location based service developers where we do our best to highlight geoinnovation. 

### Further reading

You may enjoy Michael Tandy's [Falsehoods Programmers Believe about Addresses](http://www.mjt.me.uk/posts/falsehoods-programmers-believe-about-addresses/)

If all this convinces you address are evil, please check out [what3words](http://what3words.com/) which allows you to dispense with them entirely. 