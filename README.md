# Instructions

When we do the backup for a specific ERP instance, we keep the snapshot copies according to the Retention Plan.
We need to create a service that receives retention rules and a date, it should tell us if the snapshot of this date should be retained or deleted.

The rules are the following:

#### Bronze: 21 days retention

- We will retain each snapshot daily for 21 days

#### Silver: 21 days and 3 months retention

- We will retain each snapshot daily for 21 days
- We will retain the last snapshot of the month for 3 months

#### Gold (21 days, 3 months and 5 years)

- We will retain each snapshot daily for 21 days
- We will retain the last snapshot of the month for 3 months
- We will retain the last snapshot of the year for 5 years

### Notes about the code

The rules composition can be dynamic so we need to receive them, something like this:

- Retention.new(days: 21, months: 3, years: 5).include? Date.new(2014, 4, 2)
- Retention.new(months: 3).include? Date.new(2014, 4, 2)
- Retention.new(months: 3, years: 5).include? Date.new(2014, 4, 2)

# Solution

Steps to run the specs:

1. clone the repo and enter its folder
1. bundle install
1. bundle exec rspec spec/retention_spec.rb
