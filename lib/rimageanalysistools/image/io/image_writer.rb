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

module RImageAnalysisTools

  class ImageWriter

    java_import Java::loci.formats.ImageWriter
    java_import Java::ome.xml.model.enums.DimensionOrder
    java_import Java::ome.xml.model.enums.PixelType
    java_import Java::loci.formats.FormatTools
    java_import Java::java.nio.ByteBuffer


    def initialize
      
    end

    def write(filename, image_to_write)

      wr = ImageWriter.new

      m = an_image.getMetadata

      pixels = an_image.getPixelData

      pixel_array = pixels.toImagePlus.getProcessor.getPixels

      m.setPixelsDimensionOrder(DimensionOrder.fromString(pixels.getDimensionOrder.upcase), 0)

      m.setPixelsType(PixelType.fromString(FormatTools.getPixelTypeString(pixels.getDataType)), 0)

      wr.setMetadataRetrieve(m)

      File.unlink(filename) if File.exist?(filename)

      wr.setId(filename)

      pixels.getNumPlanes.times do |i|

        c = i % pixels::size_c
        z = ((i - c)/pixels::size_c) % pixels::size_z
        t = (i - c - pixels::size_c * z)/(pixels::size_z * pixels::size_c)

        conv_index = pixels.toImagePlus.getStackIndex(c+1, z+1, t+1)

        pixels.toImagePlus.setSliceWithoutUpdate(conv_index)
        pixelData = pixels.toImagePlus.getProcessor.getPixels

        size_to_allocate = pixels::size_x * pixels::size_y * FormatTools.getBytesPerPixel(pixels::dataType)

        out = ByteBuffer.allocate(size_to_allocate)
    
        out.asFloatBuffer.put(pixelData)

        wr.savePlane(i, out.array)
  
      end

      wr.close

    end

  end

end





