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

require 'rimageanalysistools/initjava'

java_import Java::edu.stanford.cfuller.imageanalysistools.frontend.LocalAnalysis

module RImageAnalysisTools

  IM_OUTPUT_DIR = "output_images"
  QUANT_OUTPUT_DIR = "quantification"

  def self.handle_output(original_filename, output_image, quant)
    
    fn_parts = File.split(original_filename)

    im_dir = File.expand_path(IM_OUTPUT_DIR, fn_parts[0])

    quant_dir = File.expand_path(QUANT_OUTPUT_DIR, fn_parts[0])

    Dir.mkdir(im_dir) unless Dir.exist?(im_dir)
    Dir.mkdir(quant_dir) unless Dir.exist?(quant_dir)

    mask_fn = fn_parts[1] + "_output.ome.tif"

    quant_fn = fn_parts[1] + "_quant.txt"

    unless quant.nil? then

      quant_str = LocalAnalysis.generateDataOutputString(quant, params)

      File.open(File.expand_path(quant_fn, quant_dir), 'w') do |f|
        f.puts quant_str
      end

    end

    unless output_image.nil? then

      output_image.writeToFile(File.expand_path(mask_fn, im_dir))

    end

  end

  

end



