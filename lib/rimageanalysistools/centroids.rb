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

java_import Java::edu.stanford.cfuller.imageanalysistools.image.ImageCoordinate

module RImageAnalysisTools

  class Centroids

    def self.calculate_centroids_2d(mask)

      centroids = {}
      counts = {}

      mask.each do |ic|

        next unless mask[ic] > 0

        unless centroids[mask[ic]] then
          
          centroids[mask[ic]]= [0.0,0.0]
          counts[mask[ic]]= 0

        end

        centroids[mask[ic]][0]+= ic.get(ImageCoordinate::X)
        centroids[mask[ic]][1]+= ic.get(ImageCoordinate::Y)

        counts[mask[ic]]+= 1

      end

      centroids.each_key do |k|

        centroids[k].map! { |e| e/counts[k] }

      end

      centroids

    end

  end

end

