require 'rspec/core/formatters/base_formatter' # for relative_path
require 'rspec/core/formatters/progress_formatter'

module RSpec
  class SuperProfile < RSpec::Core::Formatters::ProgressFormatter
   
    def initialize(*args)
      super
      @example_times = []
    end

    def start(*args)
      top = (SHOW_TOP==-1 ? 'all' : "top #{SHOW_TOP}")
      @output.puts "Super Profiling enabled: top #{top} tests > #{SHOW_ABOVE} seconds."
    end

    def example_started(*args)
      @time = Time.now
    end

    def example_passed(example)
      super
      @example_times << [
        true,
        example_loc(example),
        example.description,
        Time.now - @time
      ]
    end

    def example_failed(example)
      super
      @example_times << [
        false,
        example_loc(example),
        example.description,
        Time.now - @time
      ]
    end

    # improve upon this....
    def dump_summary(duration, example_count, failure_count, pending_count)
      super(duration, example_count, failure_count, pending_count)
      
      dump_example_times
      dump_file_times
      @output.flush
    end

    private

    def dump_example_times
      @output.puts "\nSuperProfile Report:\n"
      sorted_by_time(@example_times)[0..SHOW_TOP].each do |passed, loc, desc, time|
        @output.puts "#{cyan(sprintf("%.3f", time))}s\t#{loc}\t#{desc} #{red('FAIL') unless passed}"
      end
    end

   def dump_file_times
      @output.puts "\n\nFiles:\n"

      file_times = Hash.new(0)
      @example_times.each do |passed, loc, desc, time|
        file_times[loc.split(':').first]+=time
      end

      sorted_by_time(file_times).each do |file, time|
        @output.puts "#{green(sprintf("%.3f", time))}s\t#{file}"
      end
    end

    #sorted by last ascending, reject beyond limit
    def sorted_by_time(times)
      times.to_a.sort_by{|x| x.last}.reverse.reject{|x| x.last < SHOW_ABOVE}
    end

    def example_loc(example)
      # handle rspec <= 2.7 gracefully 
      if RSpec::Core::Metadata.respond_to?(:relative_path)
        RSpec::Core::Metadata::relative_path(example.location) # RSpec 2.10
      else
        RSpec::Core::Formatters::BaseFormatter.relative_path(example.location) # RSpec 2.7
      end
    end

  end

end
