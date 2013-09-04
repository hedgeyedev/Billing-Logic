module BillingLogic
  class BillingCycle
    include Comparable
    attr_accessor :period, :frequency, :anniversary
    TIME_UNITS = { :day => 1, :week => 7, :month => 365/12.0, :semimonth=> 365/24, :year => 365 }

    # Creates a new BillingCycle instance
    #
    # @param opts [Hash] holds :period, :frequency, and :anniversary
    # @return [BillingCycle] a billing cycle with .period, .frequency and .anniversary
    def initialize(opts = {})
      self.period = opts[:period]
      self.frequency = opts[:frequency] || 1
      self.anniversary = opts[:anniversary]
    end

    # Compares self against another BillingCycle instance by #periodicity
    #
    # @param other [BillingCycle] another BillingCycle instance
    # @return [-1, 0, 1] integer determined by which BillingCycle is longer
    def <=>(other)
      self.periodicity <=> other.periodicity
    end

    def periodicity
      time_unit_measure * frequency
    end

    def days_in_billing_cycle_including(date)
      (closest_anniversary_date_including(date) - anniversary).abs
    end

    # Date on which the next payment is due and scheduled to be paid
    # anniversary will always equal date
    def next_payment_date
      closest_future_anniversary_date_including(anniversary)
    end
    
    # Used for prorationing in the single payment strategy
    # Not currently in use
    def closest_anniversary_date_including(date) 
      date_in_past = date < anniversary
      advance_date_by_period(anniversary, date_in_past)
    end

    def closest_future_anniversary_date_including(date)
      return anniversary if anniversary > date
      return advance_date_by_period(anniversary.dup) if anniversary == date
      next_anniversary = anniversary.dup
      while(date > next_anniversary) 
        next_anniversary = advance_date_by_period(next_anniversary)
      end
      next_anniversary
    end

    def advance_date_by_period(date, revert = false)
      operators =   {:month => revert ? :<< : :>>, 
                     :day   => revert ? :-  : :+ }
      case self.period
      when :year
        date.send(operators[:month], (self.frequency * 12))
      when :month
        date.send(operators[:month], self.frequency)
      when :week
        date.send(operators[:month], (self.frequency * 7))
      when :day
        date.send(operators[:month], self.frequency)
      end
    end

    private
    def time_unit_measure
      TIME_UNITS[self.period]
    end

  end
end
