class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable#, :omniauth_providers => [:google_oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :profile_name, :provider, :uid, :name

has_many :statuses

def full_name
	first_name + ' ' + last_name
end

#def self.from_omniauth(auth)
    #where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      #user.provider = auth.provider
      #user.uid = auth.uid
      #user.profile_name=auth.info.name
      #user.oauth_token = auth.credentials.token
      #user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      #user.save!
    #end
#end



def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  unless user
    user = User.create(profile_name:auth.extra.raw_info.name,
                          provider:auth.provider,
                          uid:auth.uid,
                          first_name:auth.info.first_name,
                          last_name:auth.info.last_name,

                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
                         )
    
  end
  user
end


def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(profile_name: data["name"],
             first_name: data["first_name"],
             last_name: data["last_name"],
             email: data["email"],

             password: Devise.friendly_token[0,20]
            )
    end
    user
end

def self.new_with_session(params, session)
  if session["devise.user_attributes"]
    new(session["devise.user_attributes"], without_protection: true) do |user|
      user.attributes = params
      user.valid?
    end
  else
    super
   #super.tap do |user|

    # if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
    #   user.provider = data["provider"]
    #   user.email = data["email"] if user.email.blank?
    #   user.first_name=data["first_name"]
    #   user.last_name=data["last_name"]
    #   user.profile_name=data["name"]
    #   user.save 
    # end
    end
  #end
end

  def password_required?
    super && provider.blank?
  end

  def update_with_password (params, *options)
    if password_required?
      update_attributes(params, *options)
    else
      super
    end
  end
end