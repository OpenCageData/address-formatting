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

you want to write logic to compile addresses in the format consumers expect

	17 Rue du Médecin-Colonel Calbairac
	31000 Toulouse
	France

or perhaps simply

	Rue du Médecin-Colonel Calbairac, Toulouse

This repository contains templates for various address formats used in
territories around the world. It also contains test cases.

### Which addresses we're talking about

The intended use-case is database or geocoding systems (forward, reverse, autocomplete) where we know both the country of the address and the language of the user/reader. The address is displayed to a consumer (for example in an app) and not used to print on an envelope for actual postal delivery. We use it to format output from the [OpenCage Geocoder](http://geocoder.opencagedata.com).

We have to deal with

   * incomplete data
   * anything with a name (peaks, bridges, bus stops)

Unlike [physical post (office) mail](http://www.bitboost.com/ref/international-address-formats.html) we don't have to deal with

   * apartment/flat number, floor numbers
   * PO boxes
   * using the language of the (destination) address
  
### Processing logic

Our goal with this repository is a series of (programming) language independent templates. Those templates can then be processed by whatever software you like. 

We've written a working implementation of a processer in Perl, see (CPAN: [Geo::Address::Formatter](https://metacpan.org/release/Geo-Address-Formatter), [github repo](https://github.com/lokku/perl-Geo-Address-Formatter)).

If you do write a processor, please let us know so we can list it here. 

### File format

The files are in [YAML](http://yaml.org/) format. The templates are written in [Mustache](http://mustache.github.io/). Both formats are human readable, strict, solve escaping and support comments. YAML allows references (called "ankers") to avoid copy&paste, Mustache allows sub-templates (called "partials").

### How to add your country/territory

1. add a .yaml testcase in `testcases/countries`, using the appropriate ISO 3166-1 alpha-2 code - see `conf/country_codes.yaml`
  * a good way to get sample data is:
      * find an addressed location (house, business, etc) in your
        target territory in OpenStreetMap
      * get the coordinates (lat, long) of the location
      * put the coordinates into the [OpenCage Geocoder demo
        page](http://geocoder.opencagedata.com/demo.html)
      * look at the resulting JSON in the *Raw Response* tab

2. edit `conf/countries/worldwide.yaml`
  * Possibly your country/territory uses an existing generic format as
    defined at the top of the file. If so, great, just map you
    country_code to the generic template. You may still want to add
    clean up code (see the entry for `DE` as an example).
  * If not you need to define a new generic rule set
      * possibly you will need to define new state/region mappings in `conf/state_codes.yaml`

3. to test you will now need to process the .yaml test via a processer
   (see above) and ensure the input leads to the desired output.

If in doubt, please get in touch via github issues.

### The future

Support all countries in the world.

With more test cases in the future the format may need to evolve. For every rule about addresses there are exceptions and edge cases to consider. 

Planned features

  * shorten/abbreviate addresses, e.g. 'Hoover Str' instead of 'Hoover Street'
  * basic formatting of 8/9 digit postcodes
  * text highlighting
  * de-duplication
  * right-to-left

We welcome your pull requests. Together we can address the world!

### Who are we?

Founded in 2006 and based in London, [Lokku](http://www.lokku.com) are long time supporters of OpenStreetMap and open data initiatives. We run the [OpenCage Geocoder](http://geocoder.opencagedata.com). We’re best known for [Nestoria](http://www.nestoria.com), our property search engine, where we manage lots of data (geo and otherwise). We also run [#geomob](http://geomobldn.org), a meetup of London location based service developers where we do our best to highlight geoinnovation. 

### Further reading

Here's [our blog post anouncing this project](http://blog.opencagedata.com/post/99059889253/good-looking-addresses-solving-the-berlin-berlin) and the motivations behind it.

You may enjoy Michael Tandy's [Falsehoods Programmers Believe about Addresses](http://www.mjt.me.uk/posts/falsehoods-programmers-believe-about-addresses/).

If it's actual address data you're after, check out [OpenAddresses](http://openaddresses.io/).

If you want to turn longitude, latitude into addresses or placenames, well that's what a geocoder does. Check out ours: [OpenCage Geocoder](http://geocoder.opencagedata.com).

If all this convinces you address are evil, please check out [what3words](http://what3words.com/) which allows you to dispense with them entirely. 
