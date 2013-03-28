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

  ##
  # Thresholds the values in an array according to Otsu's method (Otsu, 1979, DOI: 10.1109/TSMC.1979.4310076).
  # @param [Array] arr an array (1-D) containing the values to be thresholded.
  # @return [Numeric] the threshold value; values <= to this number are below the threshold.
  #
  def self.graythresh(arr)

    num_steps = 1000.0

    min = arr.reduce(Float::MAX) { |a,e| e < a ? e : a }
    max = arr.reduce(-1.0*Float::MAX) { |a,e| e > a ? e : a }
    mean = arr.reduce(0.0) { |a,e| a + e } / arr.length

    sorted = arr.sort

    step_size = (max - min)/(num_steps)

    best_eta = 0.0
    best_threshold_value = 0.0

    counts_upto_k = 0

    mu = 0

    return min if step_size == 0

    min.step(max, step_size) do |k|

      last_count_upto_k = counts_upto_k

      last_count_upto_k.upto(sorted.length-1) do |i|

        if sorted[i] > k then
          break
        end

        counts_upto_k += 1
        mu += sorted[i]*1.0/sorted.length

      end

      omega = counts_upto_k*1.0 / sorted.length

      eta = omega*(1-omega) * ((mean - mu)/(1-omega) - mu/omega)**2

      if eta > best_eta then
        best_eta = eta
        best_threshold_value = k
      end

    end

    best_threshold_value

  end

end
