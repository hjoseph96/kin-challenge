require_relative '../lib/policy_ocr'

describe PolicyOcr do
  it "loads" do
    expect(PolicyOcr).to be_a Module
  end

  it 'loads the sample.txt' do
    expect(fixture('sample').lines.count).to eq(44)
  end

  it 'correctly reads ascii numbers' do
    digits = PolicyOcr.ascii_to_digits

    expect(digits.size).to eq(11)
    expect(digits).to eq(%w[000000000 111111111 222222222 333333333 444444444 555555555 666666666 777777777 888888888 999999999 123456789])
  end

  it 'validates the policy numbers' do
    validations = PolicyOcr.validate_policy_numbers

    incorrect_policy_number = validations.select {|v| v[:policy_number] == '111111111' }.first

    correct_policy_number = validations.select {|v| v[:policy_number] == '123456789' }.first

    expect(incorrect_policy_number[:valid]).to be_falsey
    expect(correct_policy_number[:valid]).to be_truthy
  end
end
