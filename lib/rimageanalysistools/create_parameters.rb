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

java_import Java::edu.stanford.cfuller.imageanalysistools.meta.parameters.ParameterDictionary

class ParameterDictionary

  ##
  # Adds hash-like getter access to ParameterDictionary objects
  #
  # @param key an object whose to_s method returns the name of a parameter
  # 
  # @return [String] the value of the parameter as returned by ParameterDictionary#getValueForKey
  #
  def [](key)
    getValueForKey(key.to_s)
  end

  ##
  # Adds hash-like setter access to ParameterDictionary objects
  #
  # @param key an object whose to_s method returns the name of a parameter
  # @param value an object whose to_s method returns the parameter value being set
  # 
  # @return [void]
  #
  def []=(key, value)
    setValueForKey(key.to_s, value.to_s)
  end

end

module RImageAnalysisTools

  ##
  # Creates a ParameterDictionary from a hash of parameters.
  #
  # @param [Hash] parameter_hash a hash mapping parameters to values
  #
  # @return [ParameterDictionary] a parameter dictionary now containing the specified parameters
  #
  def self.create_parameter_dictionary(parameter_hash)

    p = ParameterDictionary.emptyDictionary

    parameter_hash.each do |k,v|
      p[k]= v
    end

    p

  end



end

