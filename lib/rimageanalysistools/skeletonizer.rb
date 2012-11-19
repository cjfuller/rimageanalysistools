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
require 'rimageanalysistools/image_shortcuts'

java_import Java::edu.stanford.cfuller.imageanalysistools.image.ImageCoordinate

module RImageAnalysisTools

  class Skeletonizer

    #implementation of skeletonization algorithm presented in Gonzalez & Woods, p 651-652

    def initialize(im)

      @im = im

    end

    def compute_n(ic)

      temp_ic = ImageCoordinate.cloneCoord(ic)

      n = -1  # compensate for 0,0 case

      x_off = [-1,0,1]
      y_off = [-1,0,1]

      x_off.each do |x|
        y_off.each do |y|

          temp_ic[:x] = ic[:x] + x
          temp_ic[:y] = ic[:y] + y

          if @im.inBounds(temp_ic) and @im[temp_ic] == @im[ic] then
            n += 1
          end

        end

      end

      temp_ic.recycle

      n

    end

    def compute_t(ic)

      temp_ic1 = ImageCoordinate.cloneCoord(ic)
      temp_ic2 = ImageCoordinate.cloneCoord(ic)

      pixel_offsets = [[0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1]]

      t = 0

      0.upto(pixel_offsets.length - 2) do |i|
        
        p1 = pixel_offsets[i]
        p2 = pixel_offsets[i+1]

        temp_ic1[:x] = ic[:x] + p1[0]
        temp_ic2[:x] = ic[:x] + p2[0]

        temp_ic1[:y] = ic[:y] + p1[1]
        temp_ic2[:y] = ic[:y] + p2[1]

        v1 = 0
        v2 = 0

        v1 = 1 if @im.inBounds(temp_ic1) and @im[ic] == @im[temp_ic1]
        v2 = 1 if @im.inBounds(temp_ic2) and @im[ic] == @im[temp_ic2]

        t += 1 if v2 - v1 == 1

      end

      temp_ic1.recycle
      temp_ic2.recycle

      t

    end

    def compute_pixel_product(ic, pixel_offsets)

      temp_ic = ImageCoordinate.cloneCoord(ic)

      pixel_offsets.each do |po|

        temp_ic[:x]= ic[:x] + po[0]
        temp_ic[:y]= ic[:y] + po[1]
        
        unless @im.inBounds(temp_ic) and @im[temp_ic] == @im[ic] then
          temp_ic.recycle
          return 0
        end

      end

      temp_ic.recycle

      1

    end

    def pass1(ic)

      n = compute_n(ic)
      
      return false if n < 2 or n > 6

      t = compute_t(ic)

      return false unless t == 1

      pixels246 = [[0, -1], [1, 0], [0, 1]]

      p246 = compute_pixel_product(ic, pixels246)

      return false unless p246 == 0

      pixels468 = [[1, 0], [0, 1], [-1, 0]]

      p468 = compute_pixel_product(ic, pixels468)

      return false unless p468 == 0

      true

    end

    def pass2(ic)

      n = compute_n(ic)
      
      return false if n < 2 or n > 6

      t = compute_t(ic)

      return false unless t == 1

      pixels248 = [[0, -1], [1, 0], [-1, 0]]

      p248 = compute_pixel_product(ic, pixels248)

      return false unless p248 == 0

      pixels268 = [[0, -1], [0, 1], [-1, 0]]

      p268 = compute_pixel_product(ic, pixels268)

      return false unless p268 == 0

      true

    end

    def do_iteration

      flagged1 = []

      @im.each do |ic|

        next if @im[ic] == 0

        should_flag = pass1(ic)

        if should_flag then
          flagged1 << ImageCoordinate.cloneCoord(ic)
        end

      end

      flagged1.each do |ic|

        @im[ic]= 0

        ic.recycle

      end

      flagged2 = []

      @im.each do |ic|
        
        next if @im[ic] == 0

        should_flag = pass2(ic)

        if should_flag then

          flagged2 << ImageCoordinate.cloneCoord(ic)

        end

      end

      flagged2.each do |ic|
        
        @im[ic]= 0

        ic.recycle

      end

      changed = (not (flagged1.empty? and flagged2.empty?))

      changed

    end

    def skeletonize

      while do_iteration do
        
      end

    end


  end

end

