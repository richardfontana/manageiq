FactoryGirl.define do
  factory :ems_folder do
    sequence(:name) { |n| "Test Folder #{seq_padded_for_sorting(n)}" }
  end

  factory :datacenter, :parent => :ems_folder, :class => "Datacenter" do
  end
end
