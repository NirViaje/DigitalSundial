##Digital Sundial by Mojoptix

The original post from the author here -
* The episode in [ENGLISH]: http://www.mojoptix.com/2015/10/25/mojoptix-001-digital-sundial/
* L'épisode en [FRANCAIS]: http://www.mojoptix.com/fr/2015/10/12/ep-001-cadran-solaire-numerique

Currently this is just the github copy of the thingiverse file with README.md (this file) -
* http://www.thingiverse.com/thing:1068443/

A general pattern sundial (shadow) generator will be cool.

##Usage

inside [Sundial_Digital_13oct2015.scad](https://github.com/NirViaje/DigitalSundial/blob/master/Sundial_Digital_13oct2015.scad)

```
// Choose what you want to print/display:
// 1: the gnomon
// 2: the central connector piece
// 3: the top part of the lid
// 4: the bottom part of the lid
// 10: display everything
FLAG_PRINT = 4;

FLAG_northern_hemisphere = 1;   // set to 1 for Northen Hemisphere, set to 0 for Southern Hemisphere

FLAG_gnomon_brim = 0;   // Add a brim to the gnomon
FLAG_bottom_lid_support = 1;    // Add some support structure for the lid teeth
```

####Other Digital Sundial on github
* [Sliced digital sundial](https://github.com/osresearch/gnomon) by osresearch
* [Digital Sundial Generator SCAD](https://gist.github.com/mcmadhatter/63ac565c92e911a6d0f9) by mcmadhatter

####Some Interesting Inspiration from [osresearch](https://github.com/osresearch/gnomon#inspiration)
* http://planetarium.hs-bremen.de/planetarium/astroinfo/sonnenuhren/digitalk.htm#total
* http://www.fransmaes.nl/genk/en/gk-zw08-e.htm
