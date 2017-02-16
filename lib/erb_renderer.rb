require 'erb'

class ERBRenderer
  def initialize(dest)
    @dest = dest
    @src = "#{@dest}.erb"
    @erb = ERB.new(File.read(@src))
    @erb.def_method(ERBRenderer, 'render(v)', @src)
  end

  def generate(v)
    File.open(@dest, 'w') { |f|
      f.puts self.render(v)
    }
  end
end
