require 'pry'
require 'timecop'
require 'retention'

RSpec.describe Retention do
  describe '#initialize' do
    context 'didnt receive days nor months nor years' do
      it 'raises ArgumentError' do
        expect do
          described_class.new
        end.to raise_error(ArgumentError, 'need to receive at least one of the named parameters: days, months, years')
      end
    end
  end

  describe '#keep?' do
    before do
      Timecop.freeze(Time.local(2016,6,15))
    end

    after do
      Timecop.return
    end

    context 'receiving only days' do
      subject { described_class.new(days: 5) }

      context 'within the days retention range' do
        let!(:snapshot_date) { Date.new(2016,6,10) }

        it 'returns true' do
          expect(subject.keep?(snapshot_date)).to be true
        end
      end

      context 'outside the days retention range' do
        let!(:snapshot_date) { Date.new(2016,6,9) }

        it 'returns false' do
          expect(subject.keep?(snapshot_date)).to be false
        end
      end
    end

    context 'receiving only months' do
      subject { described_class.new(months: 4) }

      context 'within the months retention range' do
        let!(:snapshot_date) { Date.new(2016,2,28) }

        it 'returns true' do
          expect(subject.keep?(snapshot_date)).to be true
        end
      end

      context 'outside the months retention range' do
        let!(:snapshot_date) { Date.new(2016,1,31) }

        it 'returns false' do
          expect(subject.keep?(snapshot_date)).to be false
        end
      end
    end

    context 'receiving days and months' do
      subject { described_class.new(days: 15, months: 2) }

      context 'within the months retention range' do
        let!(:snapshot_date) { Date.new(2016,4,30) }

        it 'returns true' do
          expect(subject.keep?(snapshot_date)).to be true
        end
      end

      context 'within the days retention range' do
        let!(:snapshot_date) { Date.new(2016,6,10) }

        it 'returns true' do
          expect(subject.keep?(snapshot_date)).to be true
        end
      end

      context 'within both ranges' do
        let!(:snapshot_date) { Date.new(2016,5,31) }

        it 'returns true' do
          expect(subject.keep?(snapshot_date)).to be true
        end
      end

      context 'ouside both ranges' do
        let!(:snapshot_date) { Date.new(2016,5,30) }

        it 'returns false' do
          expect(subject.keep?(snapshot_date)).to be false
        end
      end
    end

    context 'receiving only years' do
      subject { described_class.new(years: 2) }

      context 'within the years retention range' do
        let!(:snapshot_date) { Date.new(2014,12,31) }

        it 'returns true' do
          expect(subject.keep?(snapshot_date)).to be true
        end
      end

      context 'outside the years retention range' do
        let!(:snapshot_date) { Date.new(2013,12,31) }

        it 'returns false' do
          expect(subject.keep?(snapshot_date)).to be false
        end
      end
    end

    context 'receiving all ranges' do
      subject { described_class.new(days: 166, months: 7, years: 2) }

      context 'within all ranges' do
        let!(:snapshot_date) { Date.new(2015,12,31) }

        it 'returns true' do
          expect(subject.keep?(snapshot_date)).to be true
        end
      end

      context 'within two ranges' do
        let!(:snapshot_date) { Date.new(2016,02,28) }

        it 'returns true' do
          expect(subject.keep?(snapshot_date)).to be true
        end
      end

      context 'within one range' do
        let!(:snapshot_date) { Date.new(2014,12,31) }

        it 'returns true' do
          expect(subject.keep?(snapshot_date)).to be true
        end
      end

      context 'outside all ranges' do
        let!(:snapshot_date) { Date.new(2014,12,30) }

        it 'returns false' do
          expect(subject.keep?(snapshot_date)).to be false
        end
      end
    end
  end

  xcontext 'leap year'
end
