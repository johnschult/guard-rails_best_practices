require 'guard'
require 'guard/guard'
require 'active_support/core_ext/string' # Fixes undefined method `blank?' for "":String

require File.join(File.dirname(__FILE__), "rails_best_practices/version")

module Guard
  class RailsBestPractices < Guard
    autoload :Notifier, 'guard/rails_best_practices/notifier'

    def initialize(watchers = [], options = {})
      super
      options[:run_at_start] = true if options[:run_at_start].nil?
    end

    def start
      run_bestpractices if options[:run_at_start]
    end

    def stop
      true
    end

    def reload
      run_bestpractices
    end

    def run_all
      run_bestpractices
    end

    def run_on_change(paths)
      run_bestpractices
    end

    def run_on_deletion(paths)
    end

    def notify?
      !!options[:notification]
    end

  private
    def run_bestpractices
      UI.info 'Running Rails Best Practices checklist', :reset => true
      started_at = Time.now
      cmd = 'rails_best_practices'
      cmd += options[:cli] if options[:cli]
      @result = system(cmd)
      Notifier::notify( @result, Time.now - started_at ) if notify?
      @result
    end

  end
end
