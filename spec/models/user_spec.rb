require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "happydog", password_confirmation: "happydog")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:notes) }
  it { should respond_to(:feed) }

  it { should be_valid }
  it { should_not be_admin}

  describe "accessible attributes" do
    it "should not allow access to admin" do
      expect do
        User.new(admin: "1")
      should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  describe "when name in not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " "}
    it { should_not be_valid }
  end

  describe "when a name is too long" do
    before { @user.name= "b"*51}
    it { should_not be_valid }
  end

  describe "when email is invalid" do
    it "should be invalid" do
      addresses = %w[user@example,com user_at_b.com, user@example.
                    jack@jack+ass.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[brian@icouch.me AB_C@jack.co.uk]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_the_same_email = @user.dup
      user_with_the_same_email.email = @user.email.upcase
      user_with_the_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password isn't present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when a password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "b" * 5 }
    it {should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) {should_not be_blank }
  end

  describe "notes associations" do

    before { @user.save }
    let!(:older_note) do
      Fabricate(:note, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_note) do
      Fabricate(:note, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right not in the right order" do
      @user.notes.should == [ newer_note, older_note]
    end

    it "should destroy dependent notes" do
      notes = @user.notes
      @user.destroy
      notes.each do |note|
        note.find_by_id(note.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_note) do
        Fabricate(:note, user: Fabricate(:user))
      end

      its(:feed) { should include(older_note) }
      its(:feed) { should include(newer_note) }
      its(:feed) { should_not include(unfollowed_note) }
    end
  end
end
