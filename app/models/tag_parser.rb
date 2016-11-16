class TagParser

  def self.parse(text)
    tags_array = text.scan(/\B#\w+/).map { |t| t[1..-1].downcase }
    tags = []
    tags_array.each do |tag|
      tags << Tag.find_or_create_by!(name: tag)
    end
    tags
  end

end