require 'cucumber/formatter/io'
require 'cucumber/formatter/progress'

module Cucumber
  module Formatter
    class SuperProfile < Cucumber::Formatter::Progress 

      include Cucumber::Formatter::Io

      attr_reader :step_mother

      def initialize(step_mother, path_or_io, options)
        super
        @example_times = []
      end

      def before_features(features)
        top = (SHOW_TOP==-1 ? 'all' : "top #{SHOW_TOP}")
        @io.print "Super Profiling enabled: show #{top} tests > #{SHOW_ABOVE} seconds.\n"
      end

      def before_steps(*args)
        super
        @time = Time.now
      end

      def after_steps(*args)
        super
        my_time = Time.now - @time

        @example_times << [
          !@exception_raised,
          @scenario[:file_colon_line],
          @scenario[:name],
          Time.now - @time
        ] if @scenario

        # @io.print "feature took #{my_time}"
      end

      def scenario_name(keyword, name, file_colon_line, source_indent)
        @scenario = {name: name, file_colon_line: file_colon_line} 
      end

      def after_features(features)
        super
        dump_example_times
        dump_file_times
        @io.flush
      end

      private

      def dump_example_times
        @io.print "\n\nSuperProfile Report:\n"
        sorted_by_time(@example_times)[0..SHOW_TOP].each do |passed, loc, desc, time|
          @io.print "#{sprintf("%.3f", time)}s\t#{loc}\t#{desc} #{'FAIL' unless passed}\n"
        end
      end

      def dump_file_times
       @io.print "\n\nFiles:\n"

       file_times = Hash.new(0)
       @example_times.each do |passed, loc, desc, time|
         file_times[loc.split(':').first]+=time
       end

       sorted_by_time(file_times).each do |file, time|
         @io.print "#{sprintf("%.3f", time)}s\t#{file}\n"
       end
      end
  
      #sorted by last ascending, reject beyond limit
      def sorted_by_time(times)
        times.to_a.sort_by{|x| x.last}.reverse.reject{|x| x.last < SHOW_ABOVE}
      end
    
    end
  end
end