describe Nonogram do
  let(:rows) { [[3], [1,3], [3,1], [1,2], [1]] }
  let(:cols) { [[3], [1,1], [5], [2,1], [2]] }
  let(:empty_solution) { Array.new(rows.size) { Array.new(cols.size, ' ') } }

  subject(:nonogram) { described_class.new(rows, cols) }

  its(:solution) { is_expected.to eq(empty_solution) }

  describe '#solve' do
    subject { nonogram.solve }

    its(:solution) { is_expected.not_to eq(empty_solution) }
  end
end
