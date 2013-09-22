require 'spec_helper'

describe Upload do
  let(:upload) { Factory(:upload) }

  describe 'validations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should validate_presence_of(:asset_file_name) }

    {
      true => ["name", "name.png", "%&(){}.png"],
      false => ["na/me", "name/"],
    }.each do |is_valid, file_names|
      file_names.each do |file_name|
        spec_name = (is_valid ? "should" : "should not") + " accept filename '#{file_name}'"
        it spec_name do
          upload.asset_file_name = file_name
          upload.valid?.should be(is_valid)
          upload.errors.keys.include?(:asset_file_name).should == !is_valid
        end
      end
    end
  end

  describe 'instance methods' do
    describe '#url' do
      it "should return file's absolute URL" do
        upload.url.should match(/original\/pic.png$/)
      end

      context "with asset style" do
        specify { upload.url(:thumb).should match(/thumb\/pic.png$/) }
      end
    end
  end
end
