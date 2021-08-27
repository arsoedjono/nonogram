describe Nonogram do
  let(:rows) { [[3], [1,3], [3,1], [1,2], [1]] }
  let(:cols) { [[3], [1,1], [5], [2,1], [2]] }

  describe '#solve' do
    subject { described_class.new(rows, cols).solve }

    let(:empty_solution) { Array.new(rows.size) { Array.new(cols.size, ' ') } }

    its(:solution) { is_expected.not_to eq(empty_solution) }
  end
end
