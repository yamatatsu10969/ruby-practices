# frozen_string_literal: true

def main
  LS.show
end

class LS
  def self.show
    puts Dir.pwd
    puts Dir.getwd
    puts Dir.glob('*')
    puts Dir.pwd.encode(Encoding::UTF_8)
    p Dir.glob('*')
  end
end

main