class Student < ApplicationRecord

    validates :first_name, presence: true

    has_one_attached :profile_picture

    validate :acceptable_image

    def acceptable_image
        return unless profile_picture.attached?

        unless profile_picture.blob.byte_size <= 1.megabyte
            errors.add(:main_image, "is too big")
        end

        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(main_image.content_type)
            errors.add(:main_image, "must be a JPEG or PNG")
        end

  end

end
