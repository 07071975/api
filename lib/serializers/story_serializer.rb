class StorySerializer < ActiveModel::Serializer
    attributes :type, :title, :url, :story_content
end
  