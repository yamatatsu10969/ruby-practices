# frozen_string_literal: true

class PermissionStyle
  def initialize(stat_file)
    @stat_file = stat_file
  end

  def format
    mode = @stat_file.mode.to_s(8)
    permission = mode[- 3..]
    file_owner_permission = permission[0].to_i.to_s(2)
    file_group_permission = permission[1].to_i.to_s(2)
    other_permission = permission[2].to_i.to_s(2)
    convert_to_permission_string(file_owner_permission) + convert_to_permission_string(file_group_permission) + convert_to_permission_string(other_permission)
  end

  private

  def convert_to_permission_string(permission)
    permission.split('').map.each_with_index do |string, index|
      if string == '0'
        '-'
      elsif index.zero?
        'r'
      elsif index == 1
        'w'
      else
        'x'
      end
    end.join
  end
end
