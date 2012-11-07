#--
# /* ***** BEGIN LICENSE BLOCK *****
#  * 
#  * Copyright (c) 2012 Colin J. Fuller
#  * 
#  * Permission is hereby granted, free of charge, to any person obtaining a copy
#  * of this software and associated documentation files (the Software), to deal
#  * in the Software without restriction, including without limitation the rights
#  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  * copies of the Software, and to permit persons to whom the Software is
#  * furnished to do so, subject to the following conditions:
#  * 
#  * The above copyright notice and this permission notice shall be included in
#  * all copies or substantial portions of the Software.
#  * 
#  * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  * SOFTWARE.
#  * 
#  * ***** END LICENSE BLOCK ***** */
#++

require 'rimageanalysistools'
require 'rimageanalysistools/method/method'

java_import Java::edu.stanford.cfuller.imageanalysistools.image.ImageFactory
java_import Java::edu.stanford.cfuller.imageanalysistools.metric.IntensityPerPixelMetric

module RImageAnalysisTools

  class CentromereFindingMethod < Method

    include_package "edu.stanford.cfuller.imageanalysistools.filter"
  
    def centromere_finding(im)

      im = ImageFactory.createWritable(im)

      filter = []

      filters << LocalMaximumSeparabilityThresholdingFilter.new
      filters << LabelFilter.new
      filters << RecursiveMaximumSeparabilityThresholdingFilter.new
      filters << RelabelFilter.new
      filters << SizeAbsoluteFilter.new
      filters << RelabelFilter.new

      filters.each do |f|

        f.setParameters(parameters)
        f.setReferenceImage(input_images.getMarkerImage)
        f.apply(im)

      end
      
      im

    end

    def normalize_input_image(im)

      rnf = RenormalizationFilter.new
      rnf.setParameters(parameters)
      rnf.apply(im)

    end
    

    def go
      
      mask = ImageFactory.createWritable(input_images.getMarkerImage)

      normalize_input_image(mask)

      bf = BandpassFilter.new
      
      br.setParameters(parameters)

      band_lower = 3.0
      band_upper = 4.0

      bf.setBand(band_lower, band_upper)

      bf.apply(mask)

      centromere_finding(mask)

      m = IntensityPerPixelMetric.new

      q = m.quantify(mask, input_images)
      
      self.quantification= q

      mask

    end
    
    
  end

end
    



