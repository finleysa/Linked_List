require 'test/unit'

# I want to ensure that students are shown the tests in the order that is
# easiest to implement.
Minitest::Unit::TestCase.i_suck_and_my_tests_are_order_dependent!

module NSS
  class TestCase < Minitest::Unit::TestCase
  end
end

module MiniTest
  class Unit
    alias_method :original_puke, :puke
    def puke(klass, meth, e)
      unless ENV['EARLY_ESCAPE']
        e = case e
            when MiniTest::Skip then
              @skips += 1
              return "S" unless @verbose
              "Skipped:\n#{meth}(#{klass}) [#{location e}]:\n#{e.message}\n"
            when MiniTest::Assertion then
              @failures += 1
              "Failure:\n#{meth}(#{klass}) [#{location e}]:\n#{e.message}\n"
            else
              @errors += 1
              bt = MiniTest::filter_backtrace(e.backtrace).join "\n    "
              "Error:\n#{meth}(#{klass}):\n#{e.class}: #{e.message}\n    #{bt}\n"
            end
        @report << e
        e[0, 1]
      else
        # Workaround for minitest weirdness: When puke gets called *again* after
        # @exiting has been set to true down below, exit immediately so we don't
        # get an extra SystemExit stack trace.  Exiting without exclamation mark
        # doesn't get the non-zero exit code through, but all teardown handlers
        # have been run at this point, so it's OK to use a hard exit here.
        # exit! 1 if @exiting_from_puke
        result = original_puke(klass, meth, e)
        unless e.is_a?(MiniTest::Skip)
          # Failure or Error, so print the report we just wrote and exit.
          puts "\n#{@report.pop}\n"
          @exiting_from_puke = true
          exit 1
        end
        result
      end
    end
  end
end
