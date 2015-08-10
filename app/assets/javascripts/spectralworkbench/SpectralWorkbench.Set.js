SpectralWorkbench.Set = SpectralWorkbench.Datum.extend({

  // data as it arrives from server-side JSON
  init: function(data) {

    this.json    = data; 
    this.spectra = []; 
    var set = this;

    this.load = function(spectra) {

      set.json.spectra = spectra;

      $.each(spectra, function(i,spectrum) {
     
        set.spectra.push(new SpectralWorkbench.Spectrum(spectrum));
     
      });

    }

    this.d3 = function() {
 
      var data = [];
 
      $.each(set.spectra, function(i,spectrum) {

        data = data.concat([
          {
            values: spectrum.average,
            key:    spectrum.title,
            id:     spectrum.id
          }
        ]);

      });
 
      return data;
 
    }

    this.load(this.json.spectra);

  }

});
