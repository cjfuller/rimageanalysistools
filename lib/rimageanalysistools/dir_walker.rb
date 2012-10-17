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
  
  class DirWalker
    
    include Enumerable
    
    def initialize(base_path, exclude_hidden = true)
      
      @base_path = base_path
      @exclude_hidden = exclude_hidden
      
    end
    
    def each
      
      walk_path("") do |ext, f|
        
        yield @base_path + ext + f
        
      end
      
    end
    
    def walk_path(extra)

      Dir.foreach(@base_path + extra) do |f|
        if @exclude_hidden and f.start_with?(".") then
          next
        end
        if File.directory?(@base_path + extra + f) then
          walk_path(@base_path, extra + f + File::Separator) do |ext_rec, f_rec|
            yield ext_rec, f_rec
          end
        else
          yield extra, f
        end
      end

    end
