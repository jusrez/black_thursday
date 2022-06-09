module Deletable
	def delete(id)
		removed_item = find_by_id(id)
		@all.delete(removed_item)
	end
end
