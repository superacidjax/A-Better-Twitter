require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "superacidjax", first_name: "Brian", last_name: "Dear",
                      email: "user@example.com", zip_code: "77088", password: "happydog",
                      password_confirmation: "happydog")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:notes) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:groups) }
  it { should respond_to(:memberships) }
  it { should respond_to(:group_memberships) }
  it { should respond_to(:member?) }
  it { should respond_to(:join!) }

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

  describe "when username is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when first name is not present" do
    before { @user.first_name = " " }
    it { should_not be_valid }
  end

  describe "when last name is not present" do
    before { @user.last_name = " " }
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
      let(:followed_user) { Fabricate(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.notes.create!(content: "Hey hey!") }
      end

      its(:feed) { should include(older_note) }
      its(:feed) { should include(newer_note) }
      its(:feed) { should_not include(unfollowed_note) }
      its(:feed) do
        followed_user.notes.each do |note|
          should include(note)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { Fabricate(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "group associations" do

    before { @user.save }
    let!(:b_group) do
      Fabricate(:group, user: @user, name: "BBB")
    end
    let!(:a_group) do
      Fabricate(:group, user: @user, name: "AAA")
    end

    it "should have the right group in the right order" do
      @user.groups.should == [a_group, b_group]
    end
  end

  describe "joining groups" do
    let(:group) { Fabricate(:group, user_id: 2) }
    before do
      @user.save
      @user.join!(group)
    end

    it { should be_member(group) }
    its(:group_memberships) { should include(group) }
  end

  describe "leaving groups" do
    let(:group) { Fabricate(:group, user_id: 2) }
    let(:member) { Fabricate(:user) }
    before do
      member.save
      member.join!(group)
      member.leave!(group)
    end

    it { should_not be_member(group) }
    its(:group_memberships) { should_not include(group) }
  end

end
