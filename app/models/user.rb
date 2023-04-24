# frozen_string_literal: true

# Generated from devise gem
# For handling user auth
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         # Includeding:
         :trackable

  has_many :warranties, dependent: nil
end
