class Retention
  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def initialize(days: nil, months: nil, years: nil)
    raise(ArgumentError, 'need to receive at least one of the named parameters: days, months, years') if days.nil? && months.nil? && years.nil?

    @today = Date.today
    @days = days
    @months = months
    @years = years
  end

  def keep?(date)
    (retention_of_days.include? date) || (retention_of_months.include? date) || (retention_of_years.include? date)
  end

  private

  def retention_of_days
    return [] if @days.nil?

    days_date = @today - @days
    (days_date..@today)
  end

  def retention_of_months
    return [] if @months.nil?

    (1..@months).map do |counter|
      last_day_of_the_month_for(@today.prev_month(counter))
    end
  end

  def retention_of_years
    return [] if @years.nil?

    (1..@years).map do |counter|
      year = @today.year - counter
      Date.new(year, 12, 31)
    end
  end

  def last_day_of_the_month_for(date)
    Date.new(date.year, date.month, COMMON_YEAR_DAYS_IN_MONTH[date.month])
  end
end
