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

  class ThreadQueue
    
    def self.new_scope_with_vars(*args)
      
      yield *args
      
    end

    def initialize
      @threads = Array.new
      @waiting = Array.new
      @mut = Mutex.new
      @max_threads = 4
      @running = false
    end
    
    attr_reader :running

    def enqueue(&b)
      @mut.synchronize do
        @waiting << b
      end

    end
    
    def start_queue
      
      return nil if @running
      
      @running = true
      
      Thread.new do 
        
        while (not empty?) do
          
          run_thread_if_space
        
          sleep 0.5
        
        end
        
        @running = false
        
      end
      
    end

    def run_thread_if_space
      
      @mut.synchronize do 
        while (not @threads.size == @max_threads) and (not @waiting.empty?) do
          next_task = @waiting.pop
          @threads << Thread.new(next_task) do |task| 
            task.call
          end
        end
      end

    end

    def remove_completed_threads

      dead = Array.new

      @threads.each do |t|
        if not t.alive? then
          dead << t
        end
      end

      @mut.synchronize do
        dead.each {|d| @threads.delete(d)}
      end
                  
    end

    def finish
      while @threads.length > 0
        remove_completed_threads
        sleep 1
      end
    end



    attr_accessor :max_threads 
    
    def has_running_threads?
      remove_completed_threads
      not @threads.empty?
    end
    
    
    def empty?
      @mut.synchronize do
        @threads.empty? and @waiting.empty?
      end
    end

  end

end



