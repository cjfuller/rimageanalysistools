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

java_import Java::edu.stanford.cfuller.imageanalysistools.image.ReadOnlyImageImpl

class ReadOnlyImageImpl

  def box_conservative(lower, upper, dims)

    low_curr = nil
    up_curr = nil

    if getIsBoxed then

      low_curr = getBoxMin
      up_curr = getBoxMax

    else

      low_curr = ImageCoordinate[0,0,0,0,0]
      up_curr = ImageCoordinate.cloneCoord(getDimensionSizes)

    end

    dims.each do |d|
      low_curr[d]= lower[d]
      up_curr[d]= upper[d]
    end

  end

end

module RImageAnalysisTools

  class Drawing

    def draw(im, draw_value = 255.0)

      im.each do |ic|

        if (yield ic) then

          im.setValue(ic, draw_value)

        end

      end

    end
    
    def draw_shape(im, location, shape_name=:circle, shape_parameters= 10)

      if self.respond_to?(shape_name) then

        self.send(shape_name, im, location, shape_parameters)

      end

    end
    
    def circle(im, center, radius)

      lower = ImageCoordinate[center[0]-radius-1, center[1]-radius-1, 0,0,0]
      upper = ImageCoordinate[center[0]+radius+1, center[1]+radius+1, 0,0,0]

      im.box_conservative(lower, upper, [:x, :y])

      draw(im) do |ic|
        
        xdiff = ic[:x] - center[0]
        ydiff = ic[:y] - center[1]

        if (Math.hypot(xdiff, ydiff) - radius).abs <= Math.sqrt(2) then
          true
        else
          false
        end

      end

      lower.recycle
      upper.recycle
        
    end

    def ellipse(im, foci, radius_inc)

      min_x = foci[0][0]
      max_x = foci[1][0]
      min_y = foci[0][1]
      max_y = foci[1][1]

      if foci[1][0] < min_x then
        min_x = foci[1][0]
        max_x = foci[0][0]
      end

      if foci[1][1] < min_y then
        min_y = foci[1][1]
        max_y = foci[0][1]
      end

      radius = radius_inc + Math.hypot(max_x-min_x, max_y-min_y)
      
      lower = ImageCoordinate[min_x-radius-1, min_y-radius-1, 0,0,0]
      upper = ImageCoordinate[max_x+radius+1, max_y+radius+1, 0,0,0]

      im.box_conservative(lower, upper, [:x, :y])
      
      draw(im) do |ic|
        
        xdiff0 = ic[:x] - foci[0][0]
        ydiff0 = ic[:y] - foci[0][1]
        xdiff1 = ic[:x] - foci[1][0]
        ydiff1 = ic[:y] - foci[1][1]

        if (Math.hypot(xdiff0, ydiff0) + Math.hypot(xdiff1, ydiff1) - radius).abs <= Math.sqrt(2) then
          true
        else
          false
        end

      end


    end
    

  end

end
