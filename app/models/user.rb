class User < ActiveRecord::Base
  #attr_accessor :first_name, :phone_number, :last_name
  cattr_accessor :form_steps do
    %w(personal professional)
  end

  attr_accessor :form_step

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[facebook]

  validates :fullname, presence: true, length: {maximum: 50}, on: :create
  validates :first_name, presence: true, length: {maximum: 20}, on: :create
  validates :last_name, presence: true, length: {maximum: 20}, on: :create

  # validates :first_name, :presence => true, :on => :update
  # validates :last_name, :presence => true, :on => :update
  validates :phone_number, :presence => true, :on => :update

  validates :phone_number, :last_name, presence: true, if: -> { required_for_step?(:personal) && host? }

  mount_uploader :avatar, AvatarUploader


  has_many :rooms
  has_many :reservations
  has_many :reviews

  has_many :messages
  has_many :notifications, as: :recipient

  belongs_to :role

  delegate :name, to: :role, prefix: true, allow_nil: true

  before_save :assign_role

  after_create :send_admin_mail
  
  def send_admin_mail
     ###Send email stuff here
  end

  def admin?
    role.name == 'Admin'
  end

  def host?
    role.name == 'Host'
  end

  def tenant?
    role.name == 'Tenant'
  end

  def assign_role
    self.role = Role.find_by name: 'Tenant' if role.nil?
  end

  def required_for_step?(step)
    return false if form_step.nil?
    return true if self.form_steps.index(step.to_s) <= self.form_steps.index(form_step)
  end

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    logger.debug "User omiauth NAME -->: #{auth.info.name}"
    if user
      return user
    else
      logger.debug "User omiauth NOUSER NAME -->: #{auth.info.name}"
    	where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.fullname = auth.info.name
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.avatar = auth.info.image
        user.password = Devise.friendly_token[0,20]
        user.save!
      end
    end


  end


end
