module SocialStream
  module Models
    # Additional features for models that are Activity Objects
    module Object
      extend ActiveSupport::Concern

      included do
        subtype_of :activity_object,
                   :build => { :object_type => to_s }

        has_many :received_actions,
                 :through => :activity_object

        has_many :activity_object_audiences,
                 :through => :activity_object

        unless self == Actor
          validates_presence_of :author_id, :owner_id, :user_author_id

          after_create :create_post_activity

          # Activate this to filter drafts only
          after_update :create_update_activity
        end

        scope :authored_by, lambda { |subject|
          joins(:activity_object).
            merge(ActivityObject.authored_by(subject))
        }

        scope :not_authored_by, lambda { |subject|
          joins(:activity_object).
            merge(ActivityObject.not_authored_by(subject))
        }

        scope :owned_by, lambda { |subject|
          joins(:activity_object).
            merge(ActivityObject.owned_by(subject))
        }

        scope :shared_with, lambda { |subject|
          joins(:activity_object).
            merge(ActivityObject.shared_with(subject))
        }

        scope :followed_by, lambda { |subject|
          joins(:activity_object).
            merge(ActivityObject.followed_by(subject))
        }
      end
    end
  end
end
